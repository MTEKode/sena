# Usar la imagen base de GraalVM TruffleRuby
FROM ghcr.io/graalvm/truffleruby-community:latest

# Actualizar el sistema e instalar dependencias necesarias
RUN dnf update -y && \
    dnf -y install gcc-c++ \
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
    dos2unix && \
    dnf clean all

# Instalar NVM y Node.js
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
ENV NVM_DIR /root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install 24 && nvm use 24

# Instalar Bundler y otras gemas necesarias
RUN gem install bundler

# Crear y establecer el directorio de trabajo
WORKDIR /app

# Copiar archivos de la aplicación al contenedor
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copiar el resto de los archivos de la aplicación
COPY . .

# Convertir finales de línea a formato Unix
RUN find . -type f -exec dos2unix {} \;

# Configurar el entorno de Rails a producción
ENV RAILS_ENV production

# Generar secret_key_base y configurarla como variable de entorno
RUN echo "export SECRET_KEY_BASE=$(bundle exec rails secret)" >> /root/.bashrc
ENV SECRET_KEY_BASE $(bundle exec rails secret)

# Precompilar assets para producción
RUN bundle exec rails assets:precompile

# Exponer el puerto en el que se ejecutará la aplicación Rails
EXPOSE 3000

# Comando para iniciar el servidor Rails en modo producción
CMD ["bash", "-c", "source /root/.bashrc && bundle exec rails server -b '0.0.0.0' -p 3000 -e production"]
