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

# Manually import the GPG key for NodeSource
RUN rpm --import https://rpm.nodesource.com/gpgkey/nodesource.gpg.key

# Install Node.js to manage JavaScript dependencies
RUN curl -sL https://rpm.nodesource.com/setup_16.x | bash -
RUN dnf install -y nodejs

# Install Bundler and other necessary gems
RUN gem install bundler

# Create and set the working directory
WORKDIR /app

# Copy application files to the container
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy the rest of the application files
COPY . .

# Convert line endings to Unix format
RUN find . -type f -exec dos2unix {} \;

# Set the Rails environment to production
ENV RAILS_ENV production

# Precompile assets for production
RUN bundle exec rails assets:precompile

# Expose the port on which the Rails application will run
EXPOSE 3000

# Command to start the Rails server in production mode
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000", "-e", "production"]
