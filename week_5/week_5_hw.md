## Question 1. Install Spark and PySpark     

**Q:** Install Spark, run PySpark, create a local spark session and execute `spark.version`. What's the output?    

**A:** '3.0.3'  



## Question 2. HVFHW February 2021  

**Q:** Download the HVFHV data for february 2021: `wget https://nyc-tlc.s3.amazonaws.com/trip+data/fhvhv_tripdata_2021-02.csv`  
Read it with Spark using the same schema as we did in the lessons. Repartition it to 24 partitions and save it to parquet. What's the size of the folder with results (in MB)?   

**A:** 208 MB  



## Question 3. Count records  

**Q:** How many taxi trips were there on February 15? Consider only trips that started on February 15.   

**A:** 367170  



## Question 4. Longest trip for each day  

**Q:** Now calculate the duration for each trip. Trip starting on which day was the longest?  

**A:** 2021-02-11    



## Question 5. Most frequent dispatching_base_num  

**Q:** Now find the most frequently occurring `dispatching_base_num` in this dataset. How many stages this spark job has?  

**A:** 3  



## Question 6. Most common locations pair  

**Q:** Find the most common pickup-dropoff pair. For example: "Jamaica Bay / Clinton East". Enter two zone names separated by a slash.  
If any of the zone names are unknown (missing), use "Unknown". For example, "Unknown / Clinton East".

**A:**  East New York / East New York   



## Bonus question. Join type   

**Q:** For finding the answer to Q6, you'll need to perform a join. What type of join is it? And how many stages your spark job has?   

**A:** It's a join between a large table and a small table. It uses broadcast exchange type of join.   
For this question I have 2 Spark jobs, the first with 1 stage (where the zones table is read) and the other with 3 stages   

