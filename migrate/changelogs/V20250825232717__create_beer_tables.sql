CREATE TABLE beer_styles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    min_temperature NUMERIC(5,2) NOT NULL,
    max_temperature NUMERIC(5,2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE beer_styles IS 'Tabela que armazena os estilos de cerveja e suas temperaturas ideais de consumo.';
COMMENT ON COLUMN beer_styles.name IS 'Nome único do estilo de cerveja (ex: IPA, Pilsens, Dunkel).';
COMMENT ON COLUMN beer_styles.min_temperature IS 'Temperatura mínima ideal de consumo do estilo.';
COMMENT ON COLUMN beer_styles.max_temperature IS 'Temperatura máxima ideal de consumo do estilo.';

CREATE TABLE recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    beer_style_id UUID NOT NULL REFERENCES beer_styles(id) ON DELETE CASCADE,
    input_temperature NUMERIC(5,2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE recommendations IS 'Tabela que armazena as recomendações realizadas pelo sistema.';
COMMENT ON COLUMN recommendations.input_temperature IS 'Temperatura fornecida pelo usuário que originou a recomendação.';

CREATE TABLE playlists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    beer_style_id UUID NOT NULL REFERENCES beer_styles(id) ON DELETE CASCADE,
    spotify_id VARCHAR(100) NOT NULL,
    name VARCHAR(200) NOT NULL,
    url TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (beer_style_id, spotify_id)
);

COMMENT ON TABLE playlists IS 'Tabela que armazena playlists do Spotify relacionadas a estilos de cerveja.';
COMMENT ON COLUMN playlists.spotify_id IS 'ID da playlist no Spotify.';
COMMENT ON COLUMN playlists.url IS 'URL pública da playlist no Spotify.';

CREATE INDEX idx_beer_styles_name ON beer_styles USING btree (name);
CREATE INDEX idx_recommendations_beer_style ON recommendations USING btree (beer_style_id);
CREATE INDEX idx_playlists_beer_style ON playlists USING btree (beer_style_id);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = now();
   RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON beer_styles
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();
