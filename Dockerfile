FROM sherwind/dancer:onbuild

# Copy your module tarball into the container
COPY Dancer2-Plugin-LiteBlog-0.01.tar.gz /tmp/

# Install your module
RUN apt-get update && apt-get install -y cpanminus \
    && cpanm /tmp/Dancer2-Plugin-LiteBlog-0.01.tar.gz

# comment out to use development environment
ENV DANCER_ENVIRONMENT production
