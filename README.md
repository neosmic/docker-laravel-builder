# Docker containers array for Laravel
This image is intended to create a local Laravel environment for development (only) and can be used either for a from-scratch project or to run an older Laravel project.

## Clean Installation
- Create a project directory and clone the repository: 
```sh
mkdir myAppName
cd myAppName
git clone git@github.com:neosmic/docker-laravel-builder.git
cd docker-laravel-builder
mv .env.example .env
```
- Open `.env` file and set (or keep in mind) needed environment variables, such as Time Zone and Database connection settings.
- Then build and compose up:
```sh
docker compose build 
docker compose up
```
- Generated tree:
```txt
═ applicationName
  ╠ docker-laravelbuilder
  ╚  ╦ .env
     ╠ Dockerfile
     ╠ ... 
  ╚ myapp
     ╠ .env
     ╠ <LaravelFiles>...
```
- Inside the new directory created by docker compose (myapp) you will find the project's files for Laravel including `.env` file for database and other environment variables.
- Set database variables if needed.
- For using the MySQL dbserver service container you should just update connection settings in `.env` Laravel file:
```conf
DB_CONNECTION=mysql
DB_HOST=dbserver
DB_PORT="${DB_SERVER_PORT}"
DB_DATABASE="${MYSQL_DATABASE}"
DB_USERNAME="${MYSQL_USER}"
DB_PASSWORD="${MYSQL_PASSWORD}"
```
- For testing Laravel conection to database just get into the container by: `docker exec -it docker-laravel-builder-backend-1 bash` and type: `php artisan migrate`, and, if everything is ok it should show the migration execution.

## About .env file
You must convert `.env.example` file into `.env` file to properly load Environment Variables into containers before building the image.

## About Dockerfile and .env files
If you need more variables to be loaded during the building process you must add them into `.env` file and beside the first lines of the `Dockerfile`. Otherwise, if you need them only for execution time, feel free to just add them to `.env` file.

If you want to load variables into `.env` Laravel file you can load them by `"${MY_ENV_VAR}"` declared in `.env` beside the Dockerfile

## About building
Building process only can be done with full `docker compose up --build`. It can not be done cleanly with `docker build .` because it brokes the environment variables load.

## About directories
- This repo can create a subdirectory called dbfiles to save database files for persistence. If you don't need such persistence, please comment lines into `docker-compose.yaml` file:
```
    volumes:
      - ./dbfiles:/var/lib/mysql
```
- If you prefer, you can use a docker volume:
```yaml
    volumes:
      - dockerVolDb:/var/lib/mysql
volumes:
   dockerVolDb:
```
- The project files will be created outside of this repo's files (to avoid conflicts with Laravel repo created) and will take the name from the Environment Variable called APP_NAME inside `.env` file


## First Scaffolding in local environment for dev or debug
- For first scaffolding just build with `docker compose build --no-cache`.
- Then `docker compose up` until docker creates all the files and run the built in server.
- `CTRL + C` to stop the server, and `docker compose down`
- Into `Dockerfile` uncomment the line `USER 1000:www-data`
- Then re-run `docker compose build --no-cache`.
- Run `docker compose up -d`.
- Now you can edit your files directly from your app directory created.
- Don't forget to add the DB configurations into `.env` file of your project.

## For existing project
- Place your Laravel files into application_name directory and uncomment the line `USER 1000:www-data` into `Dockerfile`. 
- Then re-build with: `docker compose build --no-cache`
- Run `docker compose up -d`.
- Now you will be able to edit files from your app directory.
- Don't forget to add the DB configurations into `.env` file of your project.

_Note:_ If you don't uncomment line `USER 1000:www-data` into Dockerfile, you wont be able to edit files created inside the container unless you are specifically the root user.