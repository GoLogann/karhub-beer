# KarHub Beer

Backend em **Go** para **recomendar um estilo de cerveja** com base em uma **temperatura** informada e **sugerir uma playlist do Spotify** combinando com o estilo.
Inclui documentação Swagger, persistência em PostgreSQL e cache opcional em Redis.

## Sumário

* [Arquitetura](#arquitetura)
* [Requisitos](#requisitos)
* [Como rodar localmente](#como-rodar-localmente)
* [Variáveis de ambiente](#variáveis-de-ambiente)
* [Banco de dados & Migrações](#banco-de-dados--migrações)
* [Seed de estilos](#seed-de-estilos)
* [Integração Spotify](#integração-spotify)
* [Autenticação (opcional: Keycloak)](#autenticação-opcional-keycloak)
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
  * `infra/postgres`, `infra/spotify`, `infra/redis` (opcional)
  * `module/*`: módulos Fx (ex.: `BeerModule`, `SpotifyModule`)
* **Domínio**: `BeerStyle`, `Recommendation`, `Playlist` (+ `Validate()` com go-playground/validator)
* **DB**: PostgreSQL + GORM (mutações/migrações via Flyway)
* **Cache**: Redis (opcional)
* **Auth**: Keycloak (opcional, preparado)
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

3. **Suba Postgres (e Redis opcional)** com Docker Compose:

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

4. **Execute migrações** (ver [Banco de dados & Migrações](#banco-de-dados--migrações)).

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

# Redis (opcional)
REDIS_HOST=localhost
REDIS_PORT=6379

# Spotify (Client Credentials)
SPOTIFY_CLIENT_ID=SEU_CLIENT_ID
SPOTIFY_CLIENT_SECRET=SEU_CLIENT_SECRET

# Keycloak (opcional)
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

1. Crie um app em [https://developer.spotify.com/dashboard](https://developer.spotify.com/dashboard)
2. Pegue `Client ID` e `Client Secret`
3. Preencha no `.env`
4. A busca de playlist usa o **nome do estilo** como termo (ex.: “Weissbier”, “IPA”, etc.)

> **Cache opcional**: se `REDIS_HOST/PORT` estiverem setados, podemos cachear resultados de playlist por estilo.

---

## Autenticação (opcional: Keycloak)

* Realm: `karhub-beer`
* Client: `karhub-beer-api`
* Para proteger rotas, ative o middleware e **crie o realm role `user`** (erro comum: “Role not found”).
* Neste MVP, `/recommend` pode ficar **público** para facilitar a validação do desafio.

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

Sugestões:

* Usecase: `FindClosest` (intervalos, empates, bordas)
* Handler: `/recommend` (200, 400, 404)
* Integração com DB (mock ou container)

---

## Padrão de commits

* `feat:` nova funcionalidade
* `fix:` correção de bug
* `docs:` documentação
* `chore:` manutenção/infra/CI
* `refactor:` melhoria interna sem mudar comportamento
* `test:` testes

Ex.: `feat(spotify): buscar playlist por estilo e retornar top 3 faixas`

---

## Roadmap curto

* [ ] Conectar Spotify no `/recommend` (retornar `playlist_url` + 3–5 faixas)
* [ ] Cache Redis para buscas de playlist por estilo
* [ ] Proteger endpoints com Keycloak (role `user`)
* [ ] Mais testes (unit/integration) e exemplos no Swagger
* [ ] (Opcional) Migrar `beer_styles.id` para UUID para consistência

---

## Troubleshooting

* **DNS/host Postgres**: erro `hostname resolving error`
  → Verifique `DB_HOST` no `.env` (se está `localhost` ou `karhub-beer-postgresql` dependendo do ambiente).

* **Spotify 401**:
  → Confirme `SPOTIFY_CLIENT_ID/SECRET` e que a autenticação Client Credentials está ativa.

* **Swagger não abre**:
  → Garanta que o `swag init` foi executado e a rota do `gin-swagger` está registrada.