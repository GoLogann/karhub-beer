# KarHub Beer

Backend em **Go** para **recomendar um estilo de cerveja** com base em uma **temperatura** informada e **sugerir uma playlist do Spotify** combinando com o estilo.
Inclui documentação Swagger, persistência em PostgreSQL, **cache em Redis** e **autenticação via Keycloak**.

## Sumário

* [Arquitetura](#arquitetura)
* [Requisitos](#requisitos)
* [Como rodar localmente](#como-rodar-localmente)
* [Variáveis de ambiente](#variáveis-de-ambiente)
* [Banco de dados & Migrações](#banco-de-dados--migrações)
* [Seed de estilos](#seed-de-estilos)
* [Integração Spotify](#integração-spotify)
* [Autenticação (Keycloak)](#autenticação-keycloak)
* [API](#api)
* [Swagger / OpenAPI](#swagger--openapi)
* [Testes](#testes)
* [Padrão de commits](#padrão-de-commits)
* [Roadmap curto](#roadmap-curto)
* [Troubleshooting](#troubleshooting)

---

## Arquitetura

* **Linguagem**: Go (Gin + Uber Fx para DI)
* **Camadas**:

  * `adapter/http`: handlers e rotas (ex.: `/recommend`)
  * `core/usecase`: regras de negócio (ex.: `FindClosest`)
  * `adapter/repository`: persistência (GORM)
  * `infra/postgres`, `infra/spotify`, `infra/redis`
  * `module/*`: módulos Fx (ex.: `BeerModule`, `SpotifyModule`)
* **Domínio**: `BeerStyle`, `Recommendation`, `Playlist` (+ `Validate()` com go-playground/validator)
* **DB**: PostgreSQL + GORM (mutações/migrações via Flyway)
* **Cache**: **Redis (implementado)**
* **Auth**: **Keycloak (implementado)**
* **Docs**: Swagger (swaggo)

---

## Requisitos

* **Go 1.22+**
* **Docker** e **Docker Compose**
* **Make** (opcional)
* Conta Spotify (para Client ID/Secret) — ver [Integração Spotify](#integração-spotify)

---

## Como rodar localmente

1. **Clone** o repositório:

```bash
git clone https://github.com/SEU_USUARIO/karhub-beer.git
cd karhub-beer
```

2. **Crie o `.env`** (veja [Variáveis de ambiente](#variáveis-de-ambiente)):

```bash
cp .env.example .env
```

3. **Suba Postgres e Redis** com Docker Compose:

```yaml
# docker-compose.yml (exemplo)
version: '3.7'
services:
  karhub-beer-postgresql:
    image: postgres:16.4
    container_name: karhub-beer-postgresql
    environment:
      POSTGRES_DB: karhub_beer
      POSTGRES_USER: karhub
      POSTGRES_PASSWORD: karhub
      POSTGRES_HOST_AUTH_METHOD: md5
    ports:
      - "5432:5432"
    networks:
      - karhub-beer-network

  karhub-beer-redis:
    image: redis:7
    container_name: karhub-beer-redis
    ports:
      - "6379:6379"
    networks:
      - karhub-beer-network

networks:
  karhub-beer-network:
    driver: bridge
```

Suba os serviços:

```bash
docker compose up -d
```

4. **Execute as migrações** (ver [Banco de dados & Migrações](#banco-de-dados--migrações)).

5. **Rode a aplicação**:

```bash
# usando main
go run ./cmd/api

# (opcional) com hot-reload: air / reflex / fresh (se configurado)
```

> **Dica** (VS Code): já há um `launch.json` para rodar a `main` automaticamente.

---

## Variáveis de ambiente

`.env` (exemplo):

```ini
# App
PORT=8080
GIN_MODE=release

# Postgres
DB_HOST=localhost
DB_PORT=5432
DB_USER=karhub
DB_PASSWORD=karhub
DB_NAME=karhub_beer
DB_SSLMODE=disable

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Spotify (Client Credentials)
SPOTIFY_CLIENT_ID=SEU_CLIENT_ID
SPOTIFY_CLIENT_SECRET=SEU_CLIENT_SECRET

# Keycloak
KEYCLOAK_BASE_URL=http://localhost:8080
KEYCLOAK_REALM=karhub-beer
KEYCLOAK_CLIENT_ID=karhub-beer-api
KEYCLOAK_CLIENT_SECRET=CHANGE_ME_IF_CONFIDENTIAL
KEYCLOAK_ADMIN_USER=admin
KEYCLOAK_ADMIN_PASS=admin
```

---

## Banco de dados & Migrações

### Flyway

Estrutura típica:

```
migrate/
  changelogs/
    V1__create_beer_styles.sql
    V2__create_recommendations.sql
    # (opcional) V3__uuid_beer_styles.sql
  flyway.config
```

`migrate/flyway.config` (exemplo simples):

```properties
flyway.url=jdbc:postgresql://localhost:5432/karhub_beer
flyway.user=karhub
flyway.password=karhub
flyway.locations=filesystem:/flyway/sql
flyway.connectRetries=60
```

**Rodar migrações com Docker:**

```bash
docker run --rm \
  -v "$(pwd)/migrate/changelogs:/flyway/sql" \
  -v "$(pwd)/migrate/flyway.config:/flyway/conf/flyway.config" \
  flyway/flyway:7.0.2 \
  -configFiles=/flyway/conf/flyway.config migrate
```

### DDL (resumo do que usamos)

* `beer_styles`: `id` (padrão inicial SERIAL; opcional migrar para UUID)
* `recommendations`: `id UUID PK`, `beer_style_id` FK, `input_temperature NUMERIC(5,2)`, `created_at`

> Se migrar `beer_styles` para UUID, garanta **DEFAULT** (`gen_random_uuid()` ou `uuid_generate_v4()`) antes do seed.

---

## Seed de estilos

**Exemplo simples** (funciona quando `beer_styles.id` é SERIAL):

```sql
INSERT INTO beer_styles (name, min_temperature, max_temperature)
VALUES
  ('Weissbier', -1.00, 3.00),
  ('Pilsens',  -2.00, 4.00),
  ('Weizenbier', -4.00, 6.00);
```

> Se **UUID**, crie default para `id` ou inclua o `id` explicitamente.
> Ex.: `ALTER TABLE beer_styles ALTER COLUMN id SET DEFAULT gen_random_uuid();` (extensão `pgcrypto`).

---

## Integração Spotify

A app usa **Client Credentials**:

1. Crie um app no **Spotify Developer Dashboard**.
2. Pegue `Client ID` e `Client Secret`.
3. Preencha no `.env`.
4. A busca de playlist usa o **nome do estilo** como termo (ex.: “Weissbier”, “IPA”, etc.).

---

## Autenticação (Keycloak)

Com o Keycloak implementado, endpoints protegidos exigem **Bearer Token** (OIDC).

**Obter um access token (client credentials):**

```bash
curl -X POST "$KEYCLOAK_BASE_URL/realms/$KEYCLOAK_REALM/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$KEYCLOAK_CLIENT_ID" \
  -d "client_secret=$KEYCLOAK_CLIENT_SECRET" \
  -d "grant_type=client_credentials"
```

**Chamar a API com o token:**

```bash
ACCESS_TOKEN="<<cole-o-token-aqui>>"
curl -X POST http://localhost:8080/recommend \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{"temperature": 2.5}'
```

> **Roles**: garanta que o client/realm possua o **role** esperado pela API (ex.: `user`) e que o middleware valide o token/roles.

---

## API

### POST `/recommend`

Recebe uma temperatura e retorna o estilo mais adequado e uma playlist do Spotify.

**Request**

```json
{
  "temperature": 2.5
}
```

**Response (exemplo)**

```json
{
  "beerStyle": "Weissbier",
  "playlist": {
    "id": "37i9dQZF1DX0BcQWzuB7ZO",
    "name": "Weissbier Vibes",
    "url": "https://open.spotify.com/playlist/37i9dQZF1DX0BcQWzuB7ZO",
    "tracksSample": [
      {"name": "Song A", "artist": "Artist 1", "url": "https://open.spotify.com/track/..."},
      {"name": "Song B", "artist": "Artist 2", "url": "https://open.spotify.com/track/..."}
    ]
  }
}
```

**cURL**

```bash
# se a rota estiver protegida, inclua o Authorization (ver seção Keycloak)
curl -X POST http://localhost:8080/recommend \
  -H "Content-Type: application/json" \
  -d '{"temperature": 2.5}'
```

---

## Swagger / OpenAPI

Gerar docs:

```bash
go install github.com/swaggo/swag/cmd/swag@latest
swag init -g cmd/api/main.go -o docs --parseDependency --parseInternal
```

Acesse no navegador:

```
http://localhost:8080/swagger/index.html
```

---

## Testes

Unitários e integração:

```bash
go test ./...
```
