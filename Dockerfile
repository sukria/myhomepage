FROM perl:latest

WORKDIR /app

# Copy only the necessary files for installing dependencies
COPY Makefile.PL /app/

# Install build tools and the dependencies from Makefile.PL
RUN cpanm --installdeps .

# Now copy the rest of your Dancer2 app into the container
COPY . /app

# Expose the port Dancer2 runs on
EXPOSE 4444

CMD ["plackup", "bin/app.psgi"]
