## Question 1   

**Q:** What is count for fhv vehicles data for year 2019?. Can load the data for cloud storage and run a count(*)  

**A:** 42084899  

```sql
SELECT COUNT(*)
FROM deng-338919.trips_data_all.fhv_tripdata_partitioned
WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31';
```  

Alternatively,  

```sql
SELECT COUNT(*)
FROM deng-338919.trips_data_all.fhv_tripdata_partitioned
WHERE EXTRACT(YEAR FROM pickup_datetime) = 2019;
```

## Question 2   

**Q:** How many distinct dispatching_base_num we have in fhv for 2019. Can run a distinct query on the table from question 1   

**A:** 792    

```sql
SELECT COUNT(DISTINCT dispatching_base_num)
FROM( 
    SELECT dispatching_base_num
    FROM deng-338919.trips_data_all.fhv_tripdata_partitioned
    WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31'
);
```

Alternatively,  

```sql
WITH fhv_dbn_2019 AS (
    SELECT DISTINCT dispatching_base_num
    FROM deng-338919.trips_data_all.fhv_tripdata_partitioned
    WHERE DATE(pickup_datetime) BETWEEN '2019-01-01' AND '2019-12-31'
)

SELECT COUNT(dispatching_base_num)
FROM fhv_dbn_2019;
```

## Question 3  

**Q:** Best strategy to optimise if query always filter by dropoff_datetime and order by dispatching_base_num?   
Review partitioning and clustering video. We need to think what will be the most optimal strategy to improve query performance and reduce cost.  

**A:** Partition by dropoff_datetime and cluster by dispatching_base_num

```sql
-- Creating a partitioned and clustered table for fhv_tripdata
CREATE OR REPLACE TABLE deng-338919.trips_data_all.fhv_tripdata_pc
PARTITION BY DATE(dropoff_datetime)
CLUSTER BY dispatching_base_num AS
SELECT * FROM deng-338919.trips_data_all.fhv_tripdata_external;
```

## Question 4    

**Q:** What is the count, estimated and actual data processed for query which counts trip between 2019/01/01 and 2019/03/31 for dispatching_base_num B00987, B02060, B02279?.  
Create a table with optimized clustering and partitioning, and run a count(*). Estimated data processed can be found in top right corner and actual data processed can be found after the query is executed.

**A:** Count: 26558, Estimated data processed: 400 MB, Actual data processed: 155 MB  

```sql
-- In order to get results similar to the available options in the form
SELECT COUNT(*)
FROM deng-338919.trips_data_all.fhv_tripdata_pc
WHERE dropoff_datetime BETWEEN '2019-01-01' AND '2019-03-31' 
AND dispatching_base_num IN('B00987', 'B02060', 'B02279')
--Count: 26558
--Estimated data processed: 400 MB
--Actual data processed: 165 MB

--------------------------------------------------------
-- My other attemps
SELECT COUNT(*)
FROM deng-338919.trips_data_all.fhv_tripdata_pc
WHERE DATE(dropoff_datetime) BETWEEN '2019-01-01' AND '2019-03-31' 
AND dispatching_base_num IN('B00987', 'B02060', 'B02279')
--Count: 26643
--Estimated data processed: 400 MB
--Actual data processed: 155 MB

SELECT COUNT(*)
FROM deng-338919.trips_data_all.fhv_tripdata_pc
WHERE DATE(dropoff_datetime) BETWEEN '2019-01-01' AND '2019-03-30' 
AND dispatching_base_num IN('B00987', 'B02060', 'B02279')
--Count: 26558
--Estimated data processed: 400 MB
--Actual data processed: 155 MB

SELECT COUNT(*)
FROM deng-338919.trips_data_all.fhv_tripdata_pc
WHERE DATE(pickup_datetime) >= '2019-01-01' AND DATE(dropoff_datetime) <= '2019-03-31' 
AND dispatching_base_num IN('B00987', 'B02060', 'B02279')
--Count: 26643
--Estimated data processed: 600 MB
--Actual data processed: 246 MB
```


## Question 5   

**Q:** What will be the best partitioning or clustering strategy when filtering on dispatching_base_num and SR_Flag?. Review partitioning and clustering video. Partitioning cannot be created on all data types.

**A:** Cluster by dispatching_base_num and SR_Flag


#### 5.1) Data types  

Let's explore the data types of dispatching_base_num and SR_Flag, and how many distinct values we have for each  

```sql
SELECT COUNT(DISTINCT SR_Flag)
FROM deng-338919.trips_data_all.fhv_tripdata_partitioned;
--Count: 43
--SR_Flag is INTEGER

SELECT COUNT(DISTINCT dispatching_base_num)
FROM deng-338919.trips_data_all.fhv_tripdata_partitioned;
--Count: 880
--dispathing_base_num is STRING
```

dispathing_base_num is of type STRING, so it's not allowed to partition by dispathing_base_num. For more details, refer to [BQ docs](https://cloud.google.com/bigquery/docs/partitioned-tables)       

#### 5.2) Creating two sample tables    

Now let's create two sample tables that we'll query later  

```sql
-- Creating a partitioned by SR_Flag and clustered by dispatching_base_num table for fhv_tripdata
CREATE OR REPLACE TABLE deng-338919.trips_data_all.fhv_tripdata_pc3
PARTITION BY RANGE_BUCKET(SR_Flag, GENERATE_ARRAY(0,2,1))
CLUSTER BY dispatching_base_num AS
SELECT * FROM deng-338919.trips_data_all.fhv_tripdata_external;
```

```sql
-- Irregular number of rows in partitions. Also, there are lot of NULLs
SELECT table_name, partition_id, total_rows
FROM `trips_data_all.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'fhv_tripdata_pc3'
ORDER BY total_rows DESC;
```

```sql
-- Creating a clustered table by dispatching_base_num and SR_Flag for fhv_tripdata
CREATE OR REPLACE TABLE deng-338919.trips_data_all.fhv_tripdata_c
CLUSTER BY dispatching_base_num, SR_Flag AS
SELECT * FROM deng-338919.trips_data_all.fhv_tripdata_external;
```

#### 5.3) Measure query performance with a sample query   

Let's now measure query performance on the two different tables we created in 5.2)   

```sql
-- Partitioned and clustered table
SELECT * 
FROM deng-338919.trips_data_all.fhv_tripdata_pc3
WHERE dispatching_base_num = 'B02846' AND SR_Flag = 10;
--Actual data processed: 138 MB

-- Only clustered table
SELECT * 
FROM deng-338919.trips_data_all.fhv_tripdata_c
WHERE dispatching_base_num = 'B02846' AND SR_Flag = 10;
--Actual data processed: 17.7 MB
```

## Question 6    

**Q:** What improvements can be seen by partitioning and clustering for data size less than 1 GB?. Partitioning and clustering also creates extra metadata. Before query execution this metadata needs to be processed.  

**A:** Can be worse due to metadata    

## Question 7 (Not required)      

**Q:** In which format does BigQuery save data  
Review big query internals video.

**A:** Columnar    