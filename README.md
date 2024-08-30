# README

## Install Docker

### create local network
- docker network create local-network

### create database
- docker compose run --rm web rails db:create

### migrate
- docker compose run --rm web rails db:migrate

### run the app
- docker compose up
- access http://localhost:3000/weather

### run specs
- docker compose run -e "RAILS_ENV=test" web bundle exec rspec
