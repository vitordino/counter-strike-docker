# CS 1.6 HLDS + AMX MOD X + CSDM


Build & run
-----------

1. Create `.env` configuration file from example file:

    ```
    $ cp example.env .env
    ```

2. Build image with HLDS Server. It includes raw Steam HLDS + Metamod + DProto + AMX MOD X:

    ```
    $ docker-compose build hlds
    ```

3. Build custom server image based on hlds image. It includes maps, configuration and the other customization stuff:
 
    ```
    $ docker-compose build server
    ```
    
4. Edit `.env` configuration variables if needed (see image entrypoint file `hlds_run.sh` if you want to figure out how variables are used).

5. Start your server:

    ```
    $ docker-compose up -d server
    ```

6. Enjoy ;)
