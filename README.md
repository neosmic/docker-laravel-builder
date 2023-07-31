# Docker containers array for Laravel
This image is intended to create a local Laravel environment for development (or production) and can be used either for a from-scratch project or to run an older Laravel project.

## About .env file
You must convert `.env.example` file into `.env` file to properly load Environment Variables into containers.

## About Dockerfile and .env files
If you need more variables to be loaded during the building process you must add them into `.env` file and beside the first lines of the `Dockerfile`. Otherwise, if you need them only for execution time, feel free to just add them to `.env` file.

If you want to load variables into `.env` Laravel file you can load them by `"${MY_ENV_VAR}"` declared in `.env` beside the Dockerfile

For using the MySQL dbserver service container you should just update connection settings in `.env` Laravel file:
```conf
DB_CONNECTION=mysql
DB_HOST=dbserver
DB_PORT="${DB_SERVER_PORT}"
DB_DATABASE="${MYSQL_DATABASE}"
DB_USERNAME="${MYSQL_USER}"
DB_PASSWORD="${MYSQL_PASSWORD}"
```

## About building
Building process only can be done with full `docker compose up --build`. It can not be done cleanly with `docker build .` because it brokes the environment variables load.

## About directories
This repo creates a subdirectory called dbfiles to save database files for persistence. If you don't need such persistence, please comment lines into `docker-compose.yaml` file:
```
    volumes:
      - ./dbfiles:/var/lib/mysql
```

The project files will be created outside of this repo's files (to avoid conflicts with Laravel repo created) and will take the name from the Environment Variable called APP_NAME inside `.env` file