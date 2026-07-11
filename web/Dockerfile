FROM chatwoot/chatwoot:v4.15.1

# Rails web. Binds :: (dual-stack) for Railway's IPv6 networking.
# Migrations run via Railway's preDeployCommand (`rails db:chatwoot_prepare`),
# not here — keeps boot fast and migration logs separate.
ENV RAILS_ENV=production \
    NODE_ENV=production \
    INSTALLATION_ENV=docker \
    RAILS_LOG_TO_STDOUT=true \
    ACTIVE_STORAGE_SERVICE=s3_compatible \
    STORAGE_FORCE_PATH_STYLE=false \
    DEFAULT_LOCALE=en \
    POSTGRES_USERNAME=postgres \
    POSTGRES_DATABASE=chatwoot \
    ENABLE_ACCOUNT_SIGNUP=true \
    STORAGE_REGION=auto

CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "::"]
