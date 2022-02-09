/* CREATE EXTERNAL TABLES */

-- Creating external table for yellow_tripdata
CREATE OR REPLACE EXTERNAL TABLE deng-338919.trips_data_all.yellow_tripdata_external
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dtc_data_lake_deng-338919/raw/yellow_tripdata_2019-*.parquet', 
          'gs://dtc_data_lake_deng-338919/raw/yellow_tripdata_2020-*.parquet'] 
);


-- Check yellow_trip data
SELECT COUNT(*)
FROM deng-338919.trips_data_all.yellow_tripdata_external;

SELECT * 
FROM deng-338919.trips_data_all.yellow_tripdata_external 
LIMIT 10;


-- Creating external table for fhv_tripdata
CREATE OR REPLACE EXTERNAL TABLE deng-338919.trips_data_all.fhv_tripdata_external
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dtc_data_lake_deng-338919/raw/fhv_tripdata_2019-*.parquet', 
          'gs://dtc_data_lake_deng-338919/raw/fhv_tripdata_2020-*.parquet'] 
);


-- Check fhv_trip data
SELECT COUNT(*)
FROM deng-338919.trips_data_all.fhv_tripdata_external;

SELECT * 
FROM deng-338919.trips_data_all.fhv_tripdata_external 
LIMIT 10;



/* CREATE PARTITIONED TABLES */

-- Create a partitioned table for yellow_tripdata
CREATE OR REPLACE TABLE deng-338919.trips_data_all.yellow_tripdata_partitioned
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM deng-338919.trips_data_all.yellow_tripdata_external;


-- Impact of partition. Scanning ~106 MB of DATA
SELECT DISTINCT(VendorID)
FROM deng-338919.trips_data_all.yellow_tripdata_partitioned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';


-- Let's look into the partitons
SELECT table_name, partition_id, total_rows
FROM trips_data_all.INFORMATION_SCHEMA.PARTITIONS
WHERE table_name = 'yellow_tripdata_partitioned'
ORDER BY total_rows DESC;


-- Create a partitioned table for fhv_tripdata
CREATE OR REPLACE TABLE deng-338919.trips_data_all.fhv_tripdata_partitioned
PARTITION BY
  DATE(pickup_datetime) AS
SELECT * FROM deng-338919.trips_data_all.fhv_tripdata_external;


-- Let's look into the partitons
SELECT table_name, partition_id, total_rows
FROM trips_data_all.INFORMATION_SCHEMA.PARTITIONS
WHERE table_name = 'fhv_tripdata_partitioned'
ORDER BY total_rows DESC;



/* CREATE PARTITIONED AND CLUSTERED TABLES */

-- Creating a partitioned and clustered table for yellow_tripdata
CREATE OR REPLACE TABLE deng-338919.trips_data_all.yellow_tripdata_pc
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM deng-338919.trips_data_all.yellow_tripdata_external;


-- Query scans 1.1 GB
SELECT count(*) as trips
FROM deng-338919.trips_data_all.yellow_tripdata_partitoned
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;


-- Query scans 864.5 MB
SELECT count(*) as trips
FROM deng-338919.trips_data_all.yellow_tripdata_pc
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

