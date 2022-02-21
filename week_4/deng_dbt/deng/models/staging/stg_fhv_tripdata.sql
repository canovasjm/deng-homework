{{ config(materialized='view') }}

select
    dispatching_base_num as dispatching_base_num,
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,
    cast(PULocationID as integer) as PULocationID,
    cast(DOLocationID as integer) as DOLocationID,
    cast(SR_Flag as integer) as SR_Flag,
    Affiliated_base_number as Affiliated_base_number

from {{ source('staging','fhv_tripdata_pc') }}

-- dbt build --m <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
