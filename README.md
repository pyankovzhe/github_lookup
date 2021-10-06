
Simple [Roda](https://github.com/jeremyevans/roda) application for Github repositories lookup
======================

## Configuration
Configure application with following settings in .env file:

* API_ENDPOINT — github api endpoint
* API_ACCESS_TOKEN — github personal access token()
* APP_SESSION_SECRET - secret token for session(random base64 string)
* APP_ENV — app environment

Generate Github API access token [here](https://github.com/settings/tokens/new).

Geerate APP_SESSION_SECRET with
```
SecureRandom.hex(64)
```
Create .env.local file and override your settings

## Commands

### Build
```sh
docker-compose build app
```
### Run
```sh
docker-compose up -d app
```
### Test
```sh
docker-compose run -e APP_ENV=test --rm app rspec
```
### Rubocop
```sh
docker-compose run --rm app rubocop
```
