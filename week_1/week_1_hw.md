## Question 1. Google Cloud SDK
After running `gcloud --version` I got:

```shell
Google Cloud SDK 369.0.0
bq 2.0.72
core 2022.01.14
gsutil 5.6
```

## Question 2. Terraform

```shell
(base) canovasjm@deng-1:~/data-engineering-zoomcamp/week_1_basics_n_setup/1_terraform_gcp/terraform$ terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/google from the dependency lock file
- Using previously-installed hashicorp/google v4.7.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.


(base) canovasjm@deng-1:~/data-engineering-zoomcamp/week_1_basics_n_setup/1_terraform_gcp/terraform$ terraform plan
var.project
  Your GCP Project ID

  Enter a value: deng-######


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with
the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.dataset will be created
  + resource "google_bigquery_dataset" "dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "trips_data_all"
      + delete_contents_on_destroy = false
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "europe-west6"
      + project                    = "deng-xxxxxx"
      + self_link                  = (known after apply)

      + access {
          + domain         = (known after apply)
          + group_by_email = (known after apply)
          + role           = (known after apply)
          + special_group  = (known after apply)
          + user_by_email  = (known after apply)

          + view {
              + dataset_id = (known after apply)
              + project_id = (known after apply)
              + table_id   = (known after apply)
            }
        }
    }

  # google_storage_bucket.data-lake-bucket will be created
  + resource "google_storage_bucket" "data-lake-bucket" {
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "EUROPE-WEST6"
      + name                        = "dtc_data_lake_deng-xxxxxx"
      + project                     = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + uniform_bucket_level_access = true
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "Delete"
            }

          + condition {
              + age                   = 30
              + matches_storage_class = []
              + with_state            = (known after apply)
            }
        }

      + versioning {
          + enabled = true
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if
you run "terraform apply" now.


(base) canovasjm@deng-1:~/data-engineering-zoomcamp/week_1_basics_n_setup/1_terraform_gcp/terraform$ terraform apply
var.project
  Your GCP Project ID

  Enter a value: deng-######


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with
the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.dataset will be created
  + resource "google_bigquery_dataset" "dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "trips_data_all"
      + delete_contents_on_destroy = false
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "europe-west6"
      + project                    = "deng-xxxxxx"
      + self_link                  = (known after apply)

      + access {
          + domain         = (known after apply)
          + group_by_email = (known after apply)
          + role           = (known after apply)
          + special_group  = (known after apply)
          + user_by_email  = (known after apply)

          + view {
              + dataset_id = (known after apply)
              + project_id = (known after apply)
              + table_id   = (known after apply)
            }
        }
    }

  # google_storage_bucket.data-lake-bucket will be created
  + resource "google_storage_bucket" "data-lake-bucket" {
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "EUROPE-WEST6"
      + name                        = "dtc_data_lake_deng-xxxxxx"
      + project                     = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + uniform_bucket_level_access = true
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "Delete"
            }

          + condition {
              + age                   = 30
              + matches_storage_class = []
              + with_state            = (known after apply)
            }
        }

      + versioning {
          + enabled = true
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.dataset: Creating...
google_storage_bucket.data-lake-bucket: Creating...
google_bigquery_dataset.dataset: Creation complete after 2s [id=projects/deng-xxxxxx/datasets/trips_data_all]
google_storage_bucket.data-lake-bucket: Creation complete after 2s [id=dtc_data_lake_deng-xxxxxx]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

## Question 3. Count records
How many taxi trips were there on January 15? Consider only trips that started on January 15.

```sql
SELECT COUNT(tpep_pickup_datetime)
FROM yellow_taxi_data
WHERE DATE(tpep_pickup_datetime) = '2021-01-15' AND tpep_pickup_datetime IS NOT NULL;
```

Alternative `WHERE` condition, not very elegant:  
```sql
--WHERE tpep_pickup_datetime BETWEEN '2021-01-15 00:00:00' AND '2021-01-15 23:59:59' AND tpep_pickup_datetime IS NOT NULL;
```

## Question 4. Largest tip for each day
Find the largest tip for each day. On which day it was the largest tip in January? Use the pick up time for your calculations.
(Note: it's not a typo, it's "tip", not "trip")

```sql
SELECT DATE(tpep_pickup_datetime), MAX(tip_amount)
FROM yellow_taxi_data
GROUP BY 1
ORDER BY MAX(tip_amount) DESC
LIMIT 10;
```
	
## Question 5. Most popular destination
What was the most popular destination for passengers picked up in central park on January 14? Use the pick up time for your calculations. Enter the zone name (not id). If the zone name is unknown (missing), write "Unknown"

```sql
SELECT COUNT(yellow_taxi_data."DOLocationID"), zones."Zone"
FROM yellow_taxi_data
JOIN zones ON yellow_taxi_data."DOLocationID" = zones."LocationID"
WHERE yellow_taxi_data."PULocationID" =
	(SELECT zones."LocationID"
	FROM zones 
	WHERE "Zone" LIKE '%Central Park%')
 AND DATE(tpep_pickup_datetime) = '2021-01-14'
GROUP BY zones."Zone"
ORDER BY COUNT(yellow_taxi_data."DOLocationID") DESC;
```

```sql
-- Helper query
SELECT zones."LocationID", "Zone"
FROM zones 
WHERE "Zone" LIKE '%Central Park%';
```

## Question 6. Most expensive locations 
What's the pickup-dropoff pair with the largest average price for a ride (calculated based on `total_amount`)? Enter two zone names separated by a slash. For example: "Jamaica Bay / Clinton East"

If any of the zone names are unknown (missing), write "Unknown". For example: "Unknown / Clinton East".

```sql
SELECT 
	yellow_taxi_data."PULocationID", 
	yellow_taxi_data."DOLocationID", 
	CONCAT(COALESCE(zpu."Zone", 'Unknown'), ' / ', COALESCE(zdo."Zone", 'Unknown')) AS most_expensive_locations, 
	AVG(yellow_taxi_data."total_amount")
FROM yellow_taxi_data
JOIN zones AS zpu ON yellow_taxi_data."PULocationID" = zpu."LocationID"
JOIN zones AS zdo ON yellow_taxi_data."DOLocationID" = zdo."LocationID"
GROUP BY 1, 2, 3
ORDER BY AVG(yellow_taxi_data."total_amount") DESC
LIMIT 10;
```
