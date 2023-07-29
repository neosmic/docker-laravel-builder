# Docker containers array for Laravel
This image is intended to create a local Laravel environment for development (or production), and can be used either for a from scratch project or to run an older Laravel project.

## About .env file
You must convert `.env.example` file into `.env` file to properly load Environment Variables into containers.

## About Dockerfile and .env files
If you need more variables to be loaded during building process you must add them into `.env` file and among the first lines of the `Dockerfile`. Otherwise if you need them only for execution time, feel free to just add them into `.env` file

## About building
Building process only can be done with full `docker compose up --build`. It can not be done clean with `docker build .` because it brokes environment var load.

## About directories
This repo creates a subdirectory called dbfiles to save database files for persistence. If you don't need such persistence, please comment lines into `docker-compose.yaml` file:
```
    volumes:
      - ./dbfiles:/var/lib/mysql
```

The project files will be create outside of this repo files (to avoiding conflicts with laravel repo created), and will take the name from the Environment Variable called APP_NAME inside `.env` file