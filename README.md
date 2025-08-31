Boa! 👍 Faz todo sentido deixar o README bem claro, já que o avaliador vai clonar o repo, rodar o `docker compose up` e esperar que tudo funcione sem esforço extra.
Segue um modelo de README.md que cobre: **overview do projeto**, **stack utilizada**, **instruções para rodar com Docker Compose**, e **como acessar cada serviço**.

---

# 🍺 KarHub Beer API

Backend em **Go** desenvolvido como desafio técnico para vaga de **Desenvolvedor Backend**.
O sistema recomenda um **estilo de cerveja** com base na **temperatura informada** e sugere uma **playlist do Spotify** compatível com o estilo escolhido.

## 🚀 Tecnologias & Recursos Implementados

* **Go (Gin + Fx + GORM)** → API principal
* **PostgreSQL 16** → Banco de dados relacional
* **Flyway** → Controle de migrações
* **Redis 7** → Cache de consultas e sessões
* **Keycloak 26** → Autenticação e gerenciamento de usuários
* **Swagger (OpenAPI)** → Documentação interativa da API
* **Jaeger (OpenTelemetry)** → Tracing e observabilidade
* **Docker Compose** → Orquestração dos serviços

### Funcionalidades Extras

* Autenticação de usuários via Keycloak.
* Integração com **Spotify API** para playlists.
* Documentação automática via Swagger (`/swagger/index.html`).
* Observabilidade com traces enviados ao **Jaeger UI**.
* Módulos desacoplados (`beer`, `spotify`, `auth`, etc.).
* Validações de entidades de domínio com `validator`.

---

## 🐳 Como Rodar com Docker Compose

### 1. Pré-requisitos

* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/install/)

### 2. Clone o repositório

```bash
git clone https://github.com/GoLogann/karhub-beer.git
cd karhub-beer
```

### 3. Configure as variáveis

Crie um arquivo `.env` (se necessário) ou edite o `docker-compose.yml`.
⚠️ Para rodar a integração com Spotify é necessário definir `SPOTIFY_CLIENT_ID` e `SPOTIFY_CLIENT_SECRET`.

### 4. Suba os containers

```bash
docker compose up --build
```

### 5. Acesse os serviços

| Serviço        | URL/Porta                                                      | Descrição                          |
| -------------- | -------------------------------------------------------------- | ---------------------------------- |
| **API**        | [http://localhost:8081](http://localhost:8081)                 | Endpoints da aplicação             |
| **Swagger**    | [http://localhost:8081/swagger](http://localhost:8081/swagger) | Documentação da API                |
| **PostgreSQL** | localhost:5432 (user: `karhub`)                                | Banco principal                    |
| **Redis**      | localhost:6379                                                 | Cache                              |
| **Keycloak**   | [http://localhost:8080](http://localhost:8080)                 | Gestão de usuários (`admin/admin`) |
| **Jaeger**     | [http://localhost:16686](http://localhost:16686)               | Observabilidade e traces           |

---

## 🧪 Testando a API

1. Gere um token de autenticação no **Keycloak** (realm: `karhub-beer`).
2. Faça uma requisição de recomendação:

```bash
curl -X POST http://localhost:8081/recommend \
  -H "Content-Type: application/json" \
  -d '{"temperature": 3.5}'
```

Resposta esperada:

```json
{
  "beerStyle": "Pilsens",
  "playlist": "URL da playlist do Spotify"
}
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
 ┣ docs/              # Swagger
 ┣ docker-compose.yml
 ┗ README.md
```

---

## ✅ Observações

* Os dados de seed inicial (cervejas + realm do Keycloak) são carregados automaticamente via **volumes SQL** no PostgreSQL.
* Persistência garantida via volumes: `postgres_data`, `redis_data`, `keycloak_data`.
* O **healthcheck** garante que os serviços sobem na ordem correta.