## Question 1: Start date for the Yellow taxi data (1 point)  

**Q:** You'll need to parametrize the DAG for processing the yellow taxi data that we created in the videos. What should be the start date for this dag?  

**A:** 2019-01-01  


## Question 2: Frequency for the Yellow taxi data (1 point)  

**Q:** How often do we need to run this DAG?  

**A:** Monthly  


## Question 3: DAG for FHV Data (2 points)  

**Q:** How many DAG runs are green for data in 2019 after finishing everything?  

**A:** 12    

While one is able to forward Airflow's GUI container port using a regular terminal, I decided for another approach learned on this [tutorial](https://www.youtube.com/watch?v=OXOiUeHOQ-0&list=PLq4roe1E45w9Vf4iLoCmFmd-t_DtfxVCP) by [@Coder2j](https://twitter.com/Coder2j):     


```bash
# log into scheduler
docker exec -it <scheduler-ID> bash

# perform the backfill for yellow taxi
airflow dags backfill -s 2019-01-01 -e 2021-01-01 yellow_ingestion_gcs_dag

# perform the backfill for fhv taxi
airflow dags backfill -s 2019-01-01 -e 2019-12-01 fhv_ingestion_gcs_dag
airflow dags backfill -s 2020-02-01 -e 2021-01-01 fhv_ingestion_gcs_dag

# log into worker to see the downloaded files
docker exec -it <worker-ID> bash 
```


## Question 4: DAG for Zones (2 points)   

**Q:** Create the final DAG, for Zones. How often does it need to run?   

**A:** Once  

```bash
# log into scheduler
docker exec -it <scheduler-ID> bash

# perform the run for zones
airflow dags test zone_ingestion_gcs_dag 2022-01-31
```  
