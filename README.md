### Using Apache Kafka and Confluent ksqlDB to stream data from PostgreSQL into ksqlDB

This project includes dataset and the script needed to load the source data into a PostgreSQL table. 
Open your PostgreSQL database with username and password "postgres" using your favourite database manager.

##### Clone this repository and enter the directory
```bash
git clone https://github.com/isa96/kafka-ksqldb-docker && cd kafka-ksqldb-docker
```

##### Create Kafka stacks with Docker Compose
```bash
sudo docker compose up -d
```

##### Load source data into PostgreSQL database
```bash
python3 load_postgres.py
```

##### Enter the ksqlDB CLI
```bash
sudo docker exec -it ksqldb ksql
```

##### Run this query to create a connector to PostgreSQL
```sql
CREATE SOURCE CONNECTOR jdbc_connector WITH (
  'connector.class'          = 'io.confluent.connect.jdbc.JdbcSourceConnector',
  'connection.url'           = 'jdbc:postgresql://postgresql:5432/postgres',
  'connection.user'          = 'postgres',
  'connection.password'      = 'postgres',
  'topic.prefix'             = 'jdbc_',
  'table.whitelist'          = 'application_record',
  'mode'                     = 'bulk'
);
```

##### Run this query to create a stream from a PostgreSQL table
```sql
CREATE STREAM stream_table (
    ID INTEGER,
    CODE_GENDER STRING,
    FLAG_OWN_CAR STRING,
    FLAG_OWN_REALTY STRING,
    CNT_CHILDREN INTEGER,
    AMT_INCOME_TOTAL DOUBLE,
    NAME_INCOME_TYPE STRING,
    NAME_EDUCATION_TYPE STRING,
    NAME_FAMILY_STATUS STRING,
    NAME_HOUSING_TYPE STRING,
    DAYS_BIRTH INTEGER,
    DAYS_EMPLOYED INTEGER,
    FLAG_MOBIL INTEGER,
    FLAG_WORK_PHONE INTEGER,
    FLAG_PHONE INTEGER, 
    FLAG_EMAIL INTEGER, 
    OCCUPATION_TYPE STRING, 
    CNT_FAM_MEMBERS INTEGER
)
WITH (kafka_topic='jdbc_application_record', format='json', partitions=1);
```

##### Run this query to view the stream
```sql
SELECT rowtime, * FROM stream_table EMIT CHANGES;
```

##### Run this query to create a table from the the stream made
```sql
CREATE TABLE final_table AS
  SELECT
    ID                    AS client_id,
    CODE_GENDER           AS gender,
    MAX(AMT_INCOME_TOTAL) AS annual_income,
    NAME_INCOME_TYPE      AS income_source,
    NAME_EDUCATION_TYPE   AS education_level,
    NAME_FAMILY_STATUS    AS marriage_status
  FROM stream_table
  GROUP BY ID, CODE_GENDER, NAME_INCOME_TYPE, NAME_EDUCATION_TYPE, NAME_FAMILY_STATUS
  EMIT CHANGES;
```

##### Run this query to view the table
```sql
SELECT * FROM final_table;
```

##### Open Confluent Control Center to manage and monitor ksqlDB
```
localhost:9021
```

##### View the stream via Confluent Control Center
![Stream Table in Command Center](https://user-images.githubusercontent.com/110159876/208239535-4cd5c539-51f7-475c-aa37-28825a6f8f50.jpg)

##### View the table via Confluent Control Center
![Final Table in Command Center](https://user-images.githubusercontent.com/110159876/208239537-7ed20560-9c23-4201-847b-0b8e3bc2d4ee.jpg)
