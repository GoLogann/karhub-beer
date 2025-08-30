package spotify

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"strconv"
	"strings"
	"time"
)

type Client struct {
	ClientID     string
	ClientSecret string
	AccessToken  string
	ExpiresAt    time.Time
	httpClient   *http.Client
}

func NewClient() *Client {
	return &Client{
		ClientID:     os.Getenv("SPOTIFY_CLIENT_ID"),
		ClientSecret: os.Getenv("SPOTIFY_CLIENT_SECRET"),
		httpClient: &http.Client{
			Timeout: 30 * time.Second,
		},
	}
}

func NewClientWithCredentials(clientID, clientSecret string) *Client {
	return &Client{
		ClientID:     clientID,
		ClientSecret: clientSecret,
		httpClient: &http.Client{
			Timeout: 30 * time.Second,
		},
	}
}

func (c *Client) isTokenValid() bool {
	return c.AccessToken != "" && time.Now().Add(30*time.Second).Before(c.ExpiresAt)
}

func (c *Client) ensureValidToken(ctx context.Context) error {
	if !c.isTokenValid() {
		return c.authenticate(ctx)
	}
	return nil
}

func (c *Client) authenticate(ctx context.Context) error {
	auth := base64.StdEncoding.EncodeToString([]byte(fmt.Sprintf("%s:%s", c.ClientID, c.ClientSecret)))

	data := url.Values{}
	data.Set("grant_type", "client_credentials")

	req, err := http.NewRequestWithContext(ctx, "POST", "https://accounts.spotify.com/api/token", bytes.NewBufferString(data.Encode()))
	if err != nil {
		return fmt.Errorf("failed to create auth request: %w", err)
	}

	req.Header.Set("Authorization", "Basic "+auth)
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("authentication request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("authentication failed with status %d: %s", resp.StatusCode, string(body))
	}

	var token TokenResponse
	if err := json.NewDecoder(resp.Body).Decode(&token); err != nil {
		return fmt.Errorf("failed to decode token response: %w", err)
	}
	if token.AccessToken == "" {
		return fmt.Errorf("received empty access token")
	}

	c.AccessToken = token.AccessToken
	c.ExpiresAt = time.Now().Add(time.Duration(token.ExpiresIn-300) * time.Second)
	return nil
}

func (c *Client) makeRequestWithRetry(ctx context.Context, req *http.Request) (*http.Response, error) {
	maxRetries := 3

	var bodyCopy []byte
	if req.Body != nil {
		var err error
		bodyCopy, err = io.ReadAll(req.Body)
		if err != nil {
			return nil, err
		}
		_ = req.Body.Close()
	}

	for attempt := 0; attempt < maxRetries; attempt++ {
		newReq := req.Clone(ctx)
		if bodyCopy != nil {
			newReq.Body = io.NopCloser(bytes.NewReader(bodyCopy))
		}

		resp, err := c.httpClient.Do(newReq)
		if err != nil {
			if attempt == maxRetries-1 {
				return nil, err
			}
			time.Sleep(time.Duration(attempt+1) * time.Second)
			continue
		}

		if resp.StatusCode == http.StatusTooManyRequests {
			retryAfter := resp.Header.Get("Retry-After")
			resp.Body.Close()
			var wait time.Duration = 5 * time.Second
			if retryAfter != "" {
				if secs, convErr := strconv.Atoi(retryAfter); convErr == nil && secs > 0 {
					wait = time.Duration(secs) * time.Second
				}
			}
			if attempt == maxRetries-1 {
				return nil, fmt.Errorf("rate limited after %d attempts", maxRetries)
			}
			time.Sleep(wait)
			continue
		}

		if resp.StatusCode >= 500 {
			resp.Body.Close()
			if attempt == maxRetries-1 {
				return nil, fmt.Errorf("server error %d after %d attempts", resp.StatusCode, maxRetries)
			}
			time.Sleep(time.Duration(attempt+1) * time.Second)
			continue
		}

		return resp, nil
	}

	return nil, fmt.Errorf("max retries exceeded")
}

func (c *Client) handleAPIError(resp *http.Response) error {
	body, _ := io.ReadAll(resp.Body)

	var apiError ErrorResponse
	if json.Unmarshal(body, &apiError) == nil && apiError.Error.Message != "" {
		return fmt.Errorf("spotify API error (%d): %s", apiError.Error.Status, apiError.Error.Message)
	}

	return fmt.Errorf("spotify API error (%d): %s", resp.StatusCode, string(body))
}

func (c *Client) SearchPlaylists(ctx context.Context, query, market string, limit, offset int) ([]PlaylistInfo, error) {
	if strings.TrimSpace(query) == "" {
		return nil, fmt.Errorf("query cannot be empty")
	}
	if limit <= 0 || limit > 50 {
		limit = 10
	}
	if offset < 0 {
		offset = 0
	}
	if err := c.ensureValidToken(ctx); err != nil {
		return nil, fmt.Errorf("token validation failed: %w", err)
	}

	qs := url.Values{}
	qs.Set("q", query)
	qs.Set("type", "playlist")
	qs.Set("limit", strconv.Itoa(limit))
	qs.Set("offset", strconv.Itoa(offset))
	if market != "" {
		qs.Set("market", market)
	}
	searchURL := "https://api.spotify.com/v1/search?" + qs.Encode()

	req, err := http.NewRequestWithContext(ctx, "GET", searchURL, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create search request: %w", err)
	}
	req.Header.Set("Authorization", "Bearer "+c.AccessToken)

	resp, err := c.makeRequestWithRetry(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("search request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, c.handleAPIError(resp)
	}

	var searchResp SearchResponse
	if err := json.NewDecoder(resp.Body).Decode(&searchResp); err != nil {
		return nil, fmt.Errorf("failed to decode search response: %w", err)
	}

	var playlists []PlaylistInfo
	for _, p := range searchResp.Playlists.Items {
		if p.ID == "" || p.Name == "" {
			log.Printf("Skipping empty playlist: ID='%s', Name='%s'", p.ID, p.Name)
			continue
		}
		
		var image string
		if len(p.Images) > 0 {
			image = p.Images[0].URL
		}
		playlists = append(playlists, PlaylistInfo{
			ID:    p.ID,
			Name:  p.Name,
			Link:  p.ExternalUrls.Spotify,
			Image: image,
		})
	}

	if len(playlists) == 0 {
		return nil, fmt.Errorf("no valid playlist found for query: %s", query)
	}

	return playlists, nil
}

func (c *Client) GetAllPlaylistTracks(ctx context.Context, playlistID, market string) ([]TrackInfo, error) {
	if strings.TrimSpace(playlistID) == "" {
		return nil, fmt.Errorf("playlist ID cannot be empty")
	}
	if err := c.ensureValidToken(ctx); err != nil {
		return nil, fmt.Errorf("token validation failed: %w", err)
	}

	baseURL := fmt.Sprintf("https://api.spotify.com/v1/playlists/%s/tracks", playlistID)
	qs := url.Values{}
	qs.Set("limit", "100")   
	qs.Set("additional_types", "track")
	if market != "" {
		qs.Set("market", market)
	}
	nextURL := baseURL + "?" + qs.Encode()

	var all []TrackInfo
	for {
		req, err := http.NewRequestWithContext(ctx, "GET", nextURL, nil)
		if err != nil {
			return nil, fmt.Errorf("failed to create tracks request: %w", err)
		}
		req.Header.Set("Authorization", "Bearer "+c.AccessToken)

		resp, err := c.makeRequestWithRetry(ctx, req)
		if err != nil {
			return nil, fmt.Errorf("tracks request failed: %w", err)
		}
		if resp.StatusCode != http.StatusOK {
			defer resp.Body.Close()
			return nil, c.handleAPIError(resp)
		}

		var tr TracksResponse
		if err := json.NewDecoder(resp.Body).Decode(&tr); err != nil {
			resp.Body.Close()
			return nil, fmt.Errorf("failed to decode tracks response: %w", err)
		}
		resp.Body.Close()

		for _, item := range tr.Items {
			if item.Track == nil || item.Track.Type != "track" {
				continue
			}
			track := item.Track
			if track.Name == "" || len(track.Artists) == 0 {
				continue
			}
			all = append(all, TrackInfo{
				ID:     track.ID,
				Name:   track.Name,
				Artist: track.Artists[0].Name,
				Link:   track.ExternalUrls.Spotify,
			})
		}

		if tr.Next == "" {
			break
		}
		nextURL = tr.Next
	}

	return all, nil
}


func (c *Client) GetPlaylistWithTracks(ctx context.Context, query, market string) (*PlaylistInfo, error) {
	playlists, err := c.SearchPlaylists(ctx, query, market, 10, 0)
	if err != nil {
		return nil, fmt.Errorf("failed to search playlist: %w", err)
	}
	
	log.Printf("Found %d valid playlists for query '%s'", len(playlists), query)
	
	pl := playlists[0]
	log.Printf("Selected playlist: ID='%s', Name='%s'", pl.ID, pl.Name)

	tracks, err := c.GetAllPlaylistTracks(ctx, pl.ID, market)
	if err != nil {
		return nil, fmt.Errorf("failed to get playlist tracks: %w", err)
	}

	pl.Tracks = tracks
	log.Printf("Loaded %d tracks for playlist '%s'", len(tracks), pl.Name)
	return &pl, nil
}

func (c *Client) Authenticate(ctx context.Context) error {
	return c.authenticate(ctx)
}

func (c *Client) Close() {
	c.AccessToken = ""
	c.ExpiresAt = time.Time{}
}