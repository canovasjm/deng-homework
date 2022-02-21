## Question 1  

**Q:** What is the count of records in the model fact_trips after running all models with the test run variable disabled and filtering for 2019 and 2020 data only (pickup datetime)?  
You'll need to have completed the "Build the first dbt models" video and have been able to run the models via the CLI. You should find the views and models for querying in your DWH.

**A:** 61588743  

```sql
SELECT COUNT(*)
FROM `deng-338919.dbt_jcanovas.fact_trips`
WHERE EXTRACT(YEAR FROM pickup_datetime) IN (2019, 2020)
```

Alternatively,  

```sql
SELECT COUNT(*)
FROM `deng-338919.dbt_jcanovas.fact_trips`
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2020-12-31'
```


## Question 2   

**Q:** What is the distribution between service type filtering by years 2019 and 2020 data as done in the videos (Yellow/Green)?  
You will need to complete "Visualising the data" videos, either using data studio or metabase.  

**A:** 89.9/10.1   

Link to dashboard [here](https://datastudio.google.com/reporting/168e3faf-6936-46f0-8322-1abe74a5ad69)


## Question 3  

**Q:** What is the count of records in the model stg_fhv_tripdata after running all models with the test run variable disabled (:false)?  
Create a staging model for the fhv data for 2019. Run it via the CLI without limits (is_test_run: false). Filter records with pickup time in year 2019.

**A:** 42084899  

```sql
SELECT COUNT(*) 
FROM `deng-338919.dbt_jcanovas.stg_fhv_tripdata` 
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31';
```


## Question 4  

**Q:** What is the count of records in the model fact_fhv_trips after running all dependencies with the test run variable disabled (:false)?   
Create a core model for the stg_fhv_tripdata joining with dim_zones. Similar to what we've done in fact_trips, keep only records with known pickup and dropoff locations entries for pickup and dropoff locations. Run it via the CLI without limits (is_test_run: false) and filter records with pickup time in year 2019.

**A:** 22676253   

```sql
SELECT COUNT(*) 
FROM `deng-338919.dbt_jcanovas.fact_fhv_trips` 
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31';
```


## Question 5   

**Q:** What is the month with the biggest amount of rides after building a tile for the fact_fhv_trips table?   
Create a dashboard with some tiles that you find interesting to explore the data. One tile should show the amount of trips per month, as done in the videos for fact_trips, based on the fact_fhv_trips table.

**A:** January  

Link to dashboard [here](https://datastudio.google.com/reporting/168e3faf-6936-46f0-8322-1abe74a5ad69). Double checking my answer with SQL:  

```sql
SELECT  
    EXTRACT (year from pickup_datetime) AS year,
    EXTRACT (month from pickup_datetime) AS month, 
    COUNT(*) AS num_rides
FROM `deng-338919.dbt_jcanovas.fact_fhv_trips` 
GROUP BY year, month
ORDER BY num_rides DESC
```
