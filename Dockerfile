ARG RUBY_VERSION=3.4.7
FROM ruby:${RUBY_VERSION}-slim AS base
WORKDIR /app
ENV BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=test

FROM base AS build
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential && \
    rm -rf /var/lib/apt/lists/*
COPY Gemfile Gemfile.lock .ruby-version ./
RUN gem install bundler --version "$(tail -n 1 Gemfile.lock | tr -d ' ')" && \
    bundle install
COPY . .

FROM base
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app
RUN useradd --create-home app
USER app
ARG APP_VERSION=dev
ENV APP_VERSION=${APP_VERSION} \
    RACK_ENV=production
EXPOSE 9292
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "9292"]