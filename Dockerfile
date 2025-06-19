# Usar la imagen base de GraalVM TruffleRuby
FROM ghcr.io/graalvm/truffleruby-community:latest

# Actualizar el sistema e instalar dependencias necesarias
RUN dnf update -y
RUN dnf -y install gcc-c++ \
    glibc-headers \
    make \
    patch \
    libxml2 \
    libxml2-devel \
    libxslt \
    libxslt-devel \
    xz \
    git \
    vim \
    curl \
    dos2unix

# Instalar Node.js para gestionar las dependencias de JavaScript
RUN curl -sL https://rpm.nodesource.com/setup_16.x | bash -
RUN dnf module list nodejs

# Instalar Bundler y otras gemas necesarias
RUN gem install bundler

# Crear y establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos de la aplicación al contenedor
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Configuracion de Mongoid
RUN bundle exec rails g mongoid:config

# Copiar el script de entrada y darle permisos de ejecución
COPY bin/docker-entrypoint /app/bin/docker-entrypoint
RUN chmod +x /app/bin/docker-entrypoint

# Copiar el resto de los archivos de la aplicación
COPY . .

RUN find . -type f -exec dos2unix {} \;


# Configurar el entorno de Rails para desarrollo
ENV RAILS_ENV development

# Exponer el puerto en el que la aplicación Rails se ejecutará
EXPOSE 3000

# Configurar el script de entrada para desarrollo
# ENTRYPOINT ["/app/bin/docker-entrypoint"]

# Comando para iniciar el servidor Rails en modo desarrollo
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
