# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.2.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Precompile assets with all required dummy env vars
RUN SECRET_KEY_BASE_DUMMY=1 \
    DB_NAME=dummy_db \
    DB_USERNAME=dummy_user \
    DB_PASSWORD=dummy_pass \
    DATABASE_URL=postgresql://dummy_user:dummy_pass@localhost:5432/dummy_db \
    RAILS_MAX_THREADS=5 \
    ./bin/rails assets:precompile

FROM base

# Copy built artifacts
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]