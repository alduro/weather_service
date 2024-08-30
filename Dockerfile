# Use an official Ruby runtime as a parent image
FROM ruby:3.2

# Set the working directory in the container
WORKDIR /weather-service

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install the Rails gems
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Expose port 3000 to the Docker host
EXPOSE 3000

# Specify the default command to run when the container starts
CMD ["rails", "server", "-b", "0.0.0.0"]

