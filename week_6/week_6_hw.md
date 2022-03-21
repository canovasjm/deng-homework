## Question 1   

**Q:** Which option allows Kafka to scale *   

**A:**  

- [ ] consumer.group.id
- [ ] replication
- [ ] consumer.commit.auto
- [x] partitions


## Question 2   

**Q:** Which option provide fault tolerance to kafka *  

**A:**

- [ ] partitions
- [ ] consumer.group.id
- [x] replication
- [ ] cleanup.policy


## Question 3   

**Q:** What is a compact topic? *  

**A:**

- [ ] Topic which deletes messages after 7 days
- [ ] Topic which compact messages based on value
- [ ] Topic which compact messages based on Key
- [ ] All topics are compact topic


## Question 4   

**Q:** Role of schemas in Kafka *  

**A:**

- [ ] Making consumer producer independent of each other
- [ ] Provide possibility to update messages without breaking change
- [ ] Allow control when producing messages
- [ ] Share message information with consumers
 

## Question 5    

**Q:** Which configuration should a producer set to provide guarantee that a message is never lost *   

**A:**

ack=0
ack=1
ack=all


## Question 6   

**Q:** From where all can a consumer start consuming messages from *  

**A:**

Beginning in topic
Latest in topic
From a particular offset
From a particular timestamp
 

## Question 7   

**Q:** What key structure is seen when producing messages via 10 minutes Tumbling window in Kafka stream *

**A:**

Key
[Key, Start Timestamp]
[Key, Start Timestamp + 10 mins, Start Timestamp]
[Key, Start Timestamp, Start Timestamp + 10 mins]


## Question 8    

**Q:** Benefit of Global KTable *

**A:**

Partitions get assigned to KStream
Efficient joins
Network bandwidth reduction


## Question 9   

**Q:** When joining KTable with KTable partitions should be *  

**A:**

Different
Same
Does not matter


## Question 10   

**Q:** When joining KStream with Global KTable partitions should be *  

**A:**

Different
Same
Does not matter
