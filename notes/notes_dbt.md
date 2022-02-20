## dbt commands  

```bash
# clone the dbt initial repo 
dbt init

# build dependencies 
dbt deps

# green_tripdata models
dbt run -m stg_green_tripdata
dbt run -m stg_green_tripdata --var 'is_test_run: false'

# yellow_tripdata models
dbt run -m stg_yellow_tripdata
dbt run -m stg_yellow_tripdata --var 'is_test_run: false'

# fhv models
dbt run -m stg_fhv_tripdata --var 'is_test_run: false'
dbt run -m fact_fhv_trips
dbt build --select +fact_trips --var 'is_test_run: false'

# full-refresh 
dbt run --full-refresh --select fact_trips+
```  
