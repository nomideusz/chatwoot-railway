# Deploy and Host Chatwoot on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/MSjkSW?utm_medium=integration&utm_source=button&utm_campaign=chatwoot)

[Chatwoot](https://www.chatwoot.com/) is the open-source customer support platform: a shared inbox for email, website live chat, WhatsApp, Instagram, Telegram and more, with automations, canned responses, CSAT surveys, and Captain AI — a self-hosted alternative to Intercom and Zendesk.

## About Hosting Chatwoot

Chatwoot v4 is a Rails application with a real background-job tier. This template runs it as four Railway services: the web app (Rails/Puma), a dedicated Sidekiq worker (emails, automations, campaigns — kept off the web process so conversations stay snappy), PostgreSQL 16 **with pgvector** (required by v4 for Captain AI; the missing extension is why older Chatwoot templates broke on upgrade), and password-protected Redis for queues and ActionCable. Attachments go to a **Railway bucket over S3** instead of a service volume, and database migrations run as a Railway pre-deploy command (`rails db:chatwoot_prepare`) so every upgrade migrates itself. First boot takes ~2 minutes of migrations, then create your admin account at the web service's domain.

## Common Use Cases

- Omnichannel support desk: email, live chat widget, and social messengers in one shared inbox
- WhatsApp customer service — pair with an Evolution API deployment for the unofficial WhatsApp channel, or use the official Cloud API
- Product teams replacing Intercom/Zendesk seats with a self-hosted alternative plus Captain AI answers

## Dependencies for Chatwoot Hosting

- All bundled: PostgreSQL 16 (pgvector), Redis 7, Sidekiq worker, and a Railway bucket for attachments
- SMTP credentials (any provider) if you want outbound email notifications — add them post-deploy

### Deployment Dependencies

- [Chatwoot self-hosted documentation](https://www.chatwoot.com/docs/self-hosted)
- [Template source on GitHub](https://github.com/nomideusz/chatwoot-railway)

### Implementation Details

**Your Chatwoot URL is the `web` service's domain.** First visit shows the signup page — the first account created is the instance owner. Set `ENABLE_ACCOUNT_SIGNUP=false` on both `web` and `worker` afterwards to close public registration.

Service map:

| Service | Image | Role |
|---|---|---|
| web | `chatwoot/chatwoot:v4.15.1` | Rails app + ActionCable, public domain; runs `rails db:chatwoot_prepare` pre-deploy |
| worker | `chatwoot/chatwoot:v4.15.1` (CMD sidekiq) | Background jobs: mail, automations, campaigns |
| postgres | `pgvector/pgvector:pg16` | Database + vector store (Captain AI), on a volume |
| redis | `redis:7-alpine` | Sidekiq queues + ActionCable pubsub (append-only, on a volume) |

Variable wiring (lives in the template composer; documented here for maintenance):

- **Shared by web / worker**: `SECRET_KEY_BASE` (generated, alphanumeric), `FRONTEND_URL=https://${{web.RAILWAY_PUBLIC_DOMAIN}}`, `POSTGRES_HOST=${{postgres.RAILWAY_PRIVATE_DOMAIN}}`, `POSTGRES_USERNAME=postgres`, `POSTGRES_PASSWORD=${{postgres.POSTGRES_PASSWORD}}`, `POSTGRES_DATABASE=chatwoot`, `REDIS_URL=redis://:${{redis.REDIS_PASSWORD}}@${{redis.RAILWAY_PRIVATE_DOMAIN}}:6379`, `REDIS_PASSWORD=${{redis.REDIS_PASSWORD}}`, `ENABLE_ACCOUNT_SIGNUP=true`, `STORAGE_BUCKET_NAME`/`STORAGE_ACCESS_KEY_ID`/`STORAGE_SECRET_ACCESS_KEY` (Railway bucket), `STORAGE_ENDPOINT` (full https:// endpoint), `STORAGE_REGION=auto`
- **web**: `PORT=3000` (explicit service variable — Railway injects `PORT=8080` over image ENV) and `deploy.preDeployCommand = bundle exec rails db:chatwoot_prepare`
- **postgres**: `POSTGRES_PASSWORD` (generated); volume at `/var/lib/postgresql/data`
- **redis**: `REDIS_PASSWORD` (generated); volume at `/data`

Notes and limits:

- Rails binds `::` (dual-stack) in the web Dockerfile — required for Railway's IPv6 networking.
- Without SMTP variables (`MAILER_SENDER_EMAIL`, `SMTP_*`), password resets and email notifications are silently skipped; live chat and agent workflows work regardless.
- Captain AI features need an OpenAI-compatible key added in Chatwoot's super-admin console; pgvector is already enabled for it.
- Scale the `worker` service replicas if campaign sends or automations queue up.

## Why Deploy Chatwoot on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Chatwoot on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
