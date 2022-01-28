## Spin up the services  

```bash
cd /home/jm/Documents/repos/data-engineering-zoomcamp/week_2_data_ingestion/airflow
docker-compose up airflow-init
docker-compose up -d
```  

Open browser and go to `localhost:8080`. Log in with `Username: airflow` and `Password: airflow`  

Once finished, shutdown the services with:   

`docker-compose down`