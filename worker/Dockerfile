FROM chatwoot/chatwoot:v4.15.1

# Sidekiq: emails, automations, campaign sends, webhook delivery.
ENV RAILS_ENV=production \
    NODE_ENV=production \
    INSTALLATION_ENV=docker \
    RAILS_LOG_TO_STDOUT=true \
    ACTIVE_STORAGE_SERVICE=s3_compatible \
    STORAGE_FORCE_PATH_STYLE=false \
    POSTGRES_USERNAME=postgres \
    POSTGRES_DATABASE=chatwoot \
    ENABLE_ACCOUNT_SIGNUP=true \
    STORAGE_REGION=auto

CMD ["bundle", "exec", "sidekiq", "-C", "config/sidekiq.yml"]
