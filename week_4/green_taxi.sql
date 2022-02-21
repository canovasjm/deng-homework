/* CREATE EXTERNAL TABLES */

-- Creating external table for green_tripdata
CREATE OR REPLACE EXTERNAL TABLE deng-338919.trips_data_all.green_tripdata_external
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dtc_data_lake_deng-338919/raw/green_tripdata_2019-*.parquet', 
          'gs://dtc_data_lake_deng-338919/raw/green_tripdata_2020-*.parquet'] 
);
