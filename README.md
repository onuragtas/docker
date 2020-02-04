# Docker Development Environment

Create Sentry Secret Key and update .env "SENTRY_SECRET_KEY"

`docker-compose run --rm sentry config generate-secret-key`

After initialize database and create new user

`docker-compose run --rm sentry upgrade`