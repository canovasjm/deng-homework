## Docker useful commands  

- List running containers   

`docker ps`  

- Enter into a container whose id is `ad58789390ea`, for example `airflow_airflow-worker`   

`docker exec -it ad58789390ea bash`  

- List docker networks, for example to connect two `docker-compose`   

`docker network ls`  
