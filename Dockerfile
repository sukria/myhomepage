# Use a more recent Debian release as base
FROM debian:buster-slim

# Maintainer and metadata (optional but recommended)
LABEL maintainer="sukria@gmail.com" \
      description="image for alexissukrieh.com"

# Install required packages
RUN apt-get update && \
    apt-get install -y perl cpanminus libdbi-perl build-essential libssl-dev libexpat1-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Dancer2, Starman, and other necessary CPAN modules
RUN cpanm -n Dancer2 Starman

# Install LiteBlog and its dependencies
RUN set -e; \
    cpanm --installdeps -n Dancer2::Plugin::LiteBlog || (cat /root/.cpanm/work/*/build.log && false)

RUN set -e; \
    cpanm Dancer2::Plugin::LiteBlog || (cat /root/.cpanm/work/*/build.log && false)

# Set the environment for Dancer2
ENV DANCER_ENVIRONMENT production
#ENV DANCER_APPDIR /app

# Copy your Dancer2 application to the container
COPY . /app

# Set working directory
WORKDIR /app

# Expose the port Starman will run on
EXPOSE 5000

# Start the Dancer2 application with Starman
CMD ["starman", "--workers=2", "bin/app.psgi", "-p", "5000"]
