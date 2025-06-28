FROM ruby:3.4.4-slim-bookworm

# 1. Instalar solo dependencias esenciales para Ruby/Rails
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libxml2 \
    libxslt1.1 \
    libyaml-0-2 \
    libyaml-dev \
    zlib1g \
    libssl3 \
    postgresql-client \
    nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# 2. Configurar entorno de producción
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=true \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# 3. Directorio de trabajo
WORKDIR /app

# 4. Instalar Bundler primero (versión estable)
RUN gem install bundler -v 2.4.22

# 5. Copiar e instalar dependencias Ruby
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

# 6. Copiar aplicación
COPY . .

# 7. Eliminar componentes innecesarios
RUN rm -rf spec test tmp/* log/* .git* .github .vscode

# 8. Exponer puerto y configurar entrypoint
EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]