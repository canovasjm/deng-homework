## Airflow Setup

1. Create a new sub-directory called `airflow` in your `project` dir  

2. **Set the Airflow user**:

    On Linux, the quick-start needs to know your host user-id and needs to have group id set to 0. 
    Otherwise the files created in `dags`, `logs` and `plugins` will be created with root user. 
    You have to make sure to configure them for the docker-compose:

    ```bash
    mkdir -p ./dags ./logs ./plugins
    echo -e "AIRFLOW_UID=$(id -u)" > .env
    ```  

3. **Docker Build**:

    When you want to run Airflow locally, you might want to use an extended image, 
    containing some additional dependencies - for example you might add new python packages, 
    or upgrade airflow providers to a later version.
    
    Create a `Dockerfile` pointing to Airflow version you've just downloaded, 
    such as `apache/airflow:2.2.3`, as the base image,
       
    And customize this `Dockerfile` by:
    * Adding your custom packages to be installed. The one we'll need the most is `gcloud` to connect with the GCS bucket/Data Lake.  
    * Also, integrating `requirements.txt` to install libraries via  `pip install`  

   
4. **Import the official docker setup file** from the latest Airflow version:
   ```shell
   curl -LfO 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml'
   ```
   
5. It could be overwhelming to see a lot of services in here. 
   But this is only a quick-start template, and as you proceed you'll figure out which unused services can be removed.
   Eg. [Here's](docker-compose-nofrills.yml) a no-frills version of that template.

7. **Docker Compose**:

    Back in your `docker-compose.yaml`:
   * In `x-airflow-common`: 
     * Remove the `image` tag, to replace it with your `build` from your Dockerfile, as shown
     * Mount your `google_credentials` in `volumes` section as read-only
     * Set environment variables `GOOGLE_APPLICATION_CREDENTIALS` and `AIRFLOW_CONN_GOOGLE_CLOUD_DEFAULT`
   * Change `AIRFLOW__CORE__LOAD_EXAMPLES` to `false` (optional)


## Spin up the services  

```bash
cd /home/jm/Documents/repos/data-engineering-zoomcamp/week_2_data_ingestion/airflow
docker-compose up airflow-init
docker-compose up -d
```  

Open browser and go to `localhost:8080`. Log in with `Username: airflow` and `Password: airflow`  

Once finished, shutdown the services with:   

```
docker-compose down
```

To stop and delete containers, delete volumes with database data, and download images, run:

```
docker-compose down --volumes --rmi all
```

or

```
docker-compose down --volumes --remove-orphans
```  
