# 🍺 KarHub Beer API

Backend em **Go** desenvolvido como desafio técnico para vaga de **Desenvolvedor Backend**.  
O sistema recomenda um **estilo de cerveja** com base na **temperatura informada** e sugere uma **playlist do Spotify** compatível com o estilo escolhido.

---

## 🚀 Tecnologias & Recursos Implementados

- **Go (Gin + Fx + GORM)** → API principal
- **PostgreSQL 16** → Banco de dados relacional
- **SQLite** → Banco in-memory para testes automatizados
- **Flyway** → Controle de migrações
- **Redis 7** → Cache de consultas e sessões
- **Keycloak 26** → Autenticação e gerenciamento de usuários
- **Swagger (OpenAPI)** → Documentação interativa da API
- **Jaeger (OpenTelemetry)** → Tracing e observabilidade
- **Docker Compose** → Orquestração dos serviços

### Funcionalidades Extras

- Autenticação de usuários via Keycloak
- Integração com **Spotify API** para playlists
- Documentação automática via Swagger (`/swagger/index.html`)
- Observabilidade com traces enviados ao **Jaeger UI**
- Módulos desacoplados (`beer`, `spotify`, `auth`, etc.)
- Validações de entidades de domínio com `validator`

---

## 🚀 Como Executar a Aplicação

### Opção 1: 🐳 Execução Completa com Docker Compose

#### 1. Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

#### 2. Clone o repositório

```bash
git clone https://github.com/GoLogann/karhub-beer.git
cd karhub-beer
```

#### 3. Configure as variáveis

Crie um arquivo `.env` (se necessário) ou edite o `docker-compose.yml`.

⚠️ **Para rodar a integração com Spotify é necessário definir `SPOTIFY_CLIENT_ID` e `SPOTIFY_CLIENT_SECRET`.**

#### 4. Suba os containers

```bash
docker compose up --build
```

#### 5. Prepare o Keycloak (reset + dump)

Após subir os containers, é necessário carregar o dump do Keycloak no banco correto:

```bash
chmod +x reset_keycloak.sh
./reset_keycloak.sh
```

Este script irá:
- Resetar o schema public do banco keycloak
- Aplicar o dump localizado em `dumps/keycloak_dump_*.sql`

---

### Opção 2: 🔧 Desenvolvimento Local (API rodando via Go)

#### 1. Pré-requisitos

- [Go 1.21+](https://golang.org/dl/)
- [Docker](https://docs.docker.com/get-docker/) (para serviços de infraestrutura)

#### 2. Clone o repositório

```bash
git clone https://github.com/GoLogann/karhub-beer.git
cd karhub-beer
```

#### 3. Configure o arquivo `.env`

Crie um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```bash
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USER=karhub
DB_PASSWORD=karhubbeer
DB_NAME=karhub_beer
DB_SSLMODE=disable
DB_TIMEZONE=America/Sao_Paulo
DB_CONNECT_TIMEOUT=10

# Spotify Integration
SPOTIFY_CLIENT_ID=yyy
SPOTIFY_CLIENT_SECRET=xxx

# Keycloak Configuration
KC_BASE_URL=http://localhost:8080
KC_ISSUER_URL=http://localhost:8080/realms/karhub-beer
KC_CLIENT_ID=karhub-beer-api
KC_REALM=karhub-beer
KC_ADMIN_USER=admin
KC_ADMIN_PASS=admin

# Redis Configuration
REDIS_HOST=localhost:6379

# OpenTelemetry Configuration
OTEL_SERVICE_NAME=karhub-beer-api
OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4318
```

#### 4. Suba os serviços de infraestrutura (sem a API)

```bash
# Subir apenas PostgreSQL, Redis, Keycloak e Jaeger
docker compose up karhub-beer-postgresql karhub-beer-flyway karhub-beer-redis karhub-keycloak karhub-beer-jaeger -d
```

#### 5. Prepare o Keycloak (reset + dump)

```bash
chmod +x reset_keycloak.sh
./reset_keycloak.sh
```

#### 6. Instale as dependências Go

```bash
go mod tidy
```

#### 7. Execute a aplicação

```bash
# Rodar a partir da main
go run cmd/api/main.go

# Ou compilar e executar
go build -o karhub-beer cmd/api/main.go
./karhub-beer
```

A API estará disponível em: **http://localhost:8081**

---

## 🔗 Acessando os Serviços

| Serviço    | URL/Porta                                    | Descrição                              |
|------------|----------------------------------------------|----------------------------------------|
| API        | http://localhost:8081                        | Endpoints da aplicação                 |
| Swagger    | http://localhost:8081/swagger                | Documentação da API                    |
| PostgreSQL | localhost:5432 (user: karhub)               | Banco principal                        |
| Redis      | localhost:6379                               | Cache                                  |
| Keycloak   | http://localhost:8080                        | Gestão de usuários (admin/admin)      |
| Jaeger     | http://localhost:16686                       | Observabilidade e traces               |

---

## 🛠 Endpoints da API

### Autenticação
- `POST /api/v1/auth/register` → Registrar usuário
- `POST /api/v1/auth/login` → Login de usuário

### Cervejas
- `GET /api/v1/beers/` → Listar todos os estilos de cerveja
- `GET /api/v1/beers/:id` → Buscar estilo por ID
- `POST /api/v1/beers/` → Criar novo estilo de cerveja
- `PUT /api/v1/beers/:id` → Atualizar estilo de cerveja
- `DELETE /api/v1/beers/:id` → Remover estilo de cerveja

### Recomendação
- `POST /api/v1/beers/recommend` → Recomendar estilo de cerveja com base na temperatura

### Documentação
- `GET /swagger/*any` → Swagger UI (OpenAPI Docs)

---

## 🧪 Testando a API

### Exemplo: recomendação de cerveja

**Entrada:**

```bash
curl -X POST http://localhost:8081/api/v1/beers/recommend \
  -H "Content-Type: application/json" \
  -d '{"temperature": -7}'
```

**Resposta real da API:**

```json
{
  "beerStyle": "Red ale",
  "playlist": {
    "id": "725Wk64x3hOdHAkfpkLrNU",
    "name": "Louvores anos 80/90 (as melhores)",
    "link": "https://open.spotify.com/playlist/725Wk64x3hOdHAkfpkLrNU",
    "image": "https://image-cdn-ak.spotifycdn.com/image/ab67706c0000da8428feff50d644ded703138785",
    "tracks": [
      {
        "id": "3DQxotqYj2H7V9fLHx1JYo",
        "name": "Solução",
        "artist": "Grupo Álamo",
        "link": "https://open.spotify.com/track/5ikXhcS5b6I9MRbZhTFwX6"
      },
      {
        "id": "1VJFyixnIuV2UnI1n3DLD3",
        "name": "Situações",
        "artist": "Grupo Logos",
        "link": "https://open.spotify.com/track/1VJFyixnIuV2UnI1n3DLD3"
      },
      {
        "id": "2h5rtIrRBA1sBduaNXIZLY",
        "name": "Ó Senhor Jesus",
        "artist": "Prisma Brasil",
        "link": "https://open.spotify.com/track/2h5rtIrRBA1sBduaNXIZLY"
      },
      {
        "id": "3izO0RLgAHv5cqM38rp0Cy",
        "name": "Outra faixa...",
        "artist": "Artista Exemplo",
        "link": "https://open.spotify.com/track/3izO0RLgAHv5cqM38rp0Cy"
      }
    ]
  }
}
```

---

## 🔑 Fluxo de Autenticação com Keycloak

### 1. Registrar usuário

```bash
curl -X POST http://localhost:8081/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testeMa1l2",
    "email": "testeMa1l2@asss.com",
    "password": "123456",
    "roles": ["admin"]
  }'
```

### 2. Fazer login

```bash
curl -X POST http://localhost:8081/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testeMa1l2",
    "password": "123456"
  }'
```

**Resposta:**

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI..."
}
```

### 3. Consumir endpoint protegido

```bash
curl -X GET http://localhost:8081/api/v1/beers/ \
  -H "Authorization: Bearer SEU_ACCESS_TOKEN"
```

---

## 📂 Estrutura do Projeto

```
karhub-beer/
 ┣ cmd/api/           # Main da API
 ┣ adapter/           # Handlers HTTP & Repositórios
 ┣ core/              # Casos de uso (usecases)
 ┣ domain/            # Entidades e validações
 ┣ infra/             # Integrações externas (Spotify, Keycloak, Redis)
 ┣ migrate/           # Migrações Flyway
 ┣ dumps/             # Dumps do PostgreSQL (Keycloak e Karhub)
 ┣ docs/              # Swagger
 ┣ test/              # Testes automatizados
 ┃ ┣ handler/         # Testes unitários dos handlers HTTP
 ┃ ┣ integration/     # Testes de integração end-to-end
 ┃ ┣ repository/      # Testes unitários dos repositórios
 ┃ ┗ usecase/         # Testes unitários dos casos de uso
 ┣ reset_keycloak.sh  # Script para resetar e aplicar dump no Keycloak
 ┣ docker-compose.yml
 ┗ README.md
```

---

---

## 🧪 Testes Automatizados

O projeto implementa uma **estratégia de testes abrangente** com diferentes níveis:

### Tipos de Testes Implementados

- **Testes Unitários de Handlers** (`test/handler/`) → Validam os endpoints HTTP com mocks
- **Testes Unitários de Use Cases** (`test/usecase/`) → Testam a lógica de negócio isoladamente  
- **Testes Unitários de Repositórios** (`test/repository/`) → Validam operações de banco com SQLite in-memory
- **Testes de Integração** (`test/integration/`) → Testam fluxos completos end-to-end

### Executando os Testes

```bash
# Executar todos os testes
go test ./test/...

# Testes com coverage
go test -cover ./test/...

# Testes específicos por módulo
go test ./test/handler/
go test ./test/usecase/
go test ./test/repository/
go test ./test/integration/
```

### Principais Cenários Cobertos

- ✅ CRUD completo de estilos de cerveja
- ✅ Recomendação por temperatura com algoritmo de proximidade
- ✅ Integração com cache Redis (mock)
- ✅ Integração com Spotify API (mock)
- ✅ Validações de entrada e tratamento de erros
- ✅ Fluxos end-to-end completos
- ✅ **SQLite in-memory** para isolamento total dos testes

### Exemplo de Setup de Testes

Os testes utilizam **SQLite in-memory** para garantir isolamento e performance:

```go
func setupTestDB(t *testing.T) *gorm.DB {
    os.Setenv("TEST_ENV", "true")

    db, err := gorm.Open(sqlite.Open(":memory:"), &gorm.Config{})
    if err != nil {
        t.Fatalf("falha ao abrir banco em memória: %v", err)
    }

    err = db.AutoMigrate(&domain.BeerStyle{})
    if err != nil {
        t.Fatalf("falha ao migrar schema: %v", err)
    }

    return db
}
```

**Vantagens do SQLite in-memory:**
- ⚡ **Performance** → Execução extremamente rápida
- 🔒 **Isolamento** → Cada teste tem seu próprio banco limpo
- 🧪 **Simplicidade** → Não requer configuração externa
- 📦 **Portabilidade** → Funciona em qualquer ambiente

---

## ✅ Observações

- O banco `karhub_beer` é populado automaticamente com o dump inicial
- O banco `keycloak` é criado vazio e populado via `reset_keycloak.sh`
- Persistência garantida via volumes: `postgres_data`, `redis_data`, `keycloak_data`
- O healthcheck garante que os serviços sobem na ordem correta
- **Cobertura de testes** implementada em todas as camadas da aplicação
