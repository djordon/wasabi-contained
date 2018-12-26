# Wasabi-contained

The puprose of this repository is allow for easily testing out and launching [wasabi](https://github.com/intuit/wasabi), an A/B Testing Service open sourced by Intuit. 

Wasabi's default install process (as of release [1.0.20181205072204](https://github.com/intuit/wasabi/tree/1.0.20181205072204)), installs a bunch of stuff on your local machine, and may really screw things up. This repo contains a modified install process to build wasabi entirely within a few docker containers. This makes things easier on your home machine, and makes the world a kinder place.


## How to use


Installation
------------

You need Docker 17.05 or higher and docker-compose. I'm not sure what version of docker-compose is necessary, but I used version 1.23.3 without issue.


Steps to build wasabi
---------------------

1. Download the repository.

    ```bash
    git clone git@github.com:djordon/wasabi-contained.git
    cd wasabi-contained
    ```
2. Build the images. This takes 5-10 minutes.

    ```bash
    docker-compose build
    ```
3. Run migrations on cassandra. Also modify mysql's configuration.

    ```bash
    docker-compose up cassandra mysql
    ...
    # In another terminal
    docker-compose run --rm cassandra-setup
    docker-compose run --rm mysql-setup
    ```
4. Boot up the API and UI.

    ```bash
    docker-compose up wasabi-api wasabi-ui
    ```
5. Checkout wasabi in your browser at `http://localhost:9090`. The username is `admin`, the password is `admin`.


Default parameters
------------------

You may want to log into the either the MySQL or Cassandra databases. 
* **Cassandra**. The username and password for the Cassandra db is `cassandra` and `cassandra`, and the keyspace is `wasabi_experiments`. The URL is `cassandra://127.0.0.1:9042/wasabi_experiments`.
* **MySQL**. The username and password for the MySQL db is `readwrite` and `readwrite`, and the database is `wasabi`. The login URL is `jdbc:mysql://127.0.0.1:3306/wasabi`.

These can be changed by modifying the relevant variables in the `.env` file.
