# Use the GraalVM TruffleRuby base image
FROM ghcr.io/graalvm/truffleruby-community:latest

# Update the system and install necessary dependencies
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

# Install NVM and Node.js
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
ENV NVM_DIR /root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install 24 && nvm use 24

# Install Bundler and other necessary gems
RUN gem install bundler

# Create and set the working directory
WORKDIR /app

# Copy application files to the container
COPY Gemfile Gemfile.lock .env ./

# Configure bundle for PROD
RUN bundle config set without 'development test'
RUN bundle install

# Copy the rest of the application files
COPY . .

# Convert line endings to Unix format
RUN find . -type f -exec dos2unix {} \;

# Set the Rails environment to production
ENV RAILS_ENV production

# Generate secret_key_base and set it as an environment variable
RUN echo "export SECRET_KEY_BASE=$(bundle exec rails secret)" >> /root/.bashrc
ENV SECRET_KEY_BASE $(bundle exec rails secret)

# Precompile assets for production with trace
RUN bundle exec rails assets:precompile

# Expose the port on which the Rails application will run
EXPOSE 3000

# Command to start the Rails server in production mode
CMD ["bash", "-c", "source /root/.bashrc && bundle exec rails server -b '0.0.0.0' -p 3000 -e production"]
