**Disclaimer**

Almost done with stock market data

**Prerequisite**

Install postgres (psql), redis, golang, python, kafka

Set up database (init.sql file on root)

https://www.conduktor.io/kafka/how-to-install-apache-kafka-on-windows/  (kafka)

https://redis.io/docs/latest/operate/oss_and_stack/install/install-redis/install-redis-on-linux/ (redis)

sudo systemctl status redis-server (check redis status)


**Backend service**

Create .env (for go services: oppenhomies/server)

Example:

```commandline
HOST=localhost
PORT=5432
USER=postgres
DB_NAME=capstone
PASSWORD=

userPoolID=
clientID=
clientSecret=

REDIS_ADDR=localhost:6379
KAFKA_BROKERS=(your own ip).224:9092
```

Create .env (for python services: oppenhomies/)

Example:

```commandline
KAFKA_HOST=(your own ip)
KAFKA_PORT=9092
```

```commandline
cd server 
go mod tidy
<!-- go run cmd/main.go -->
```

**Python server**

Create dist folder, put a tar.gz file in

Create virtual env


```commandline
cd fc-data
pip install dist/ssi_fc_data-2.2.2.tar.gz
pip install -r requirements.txt
```

Run insert_all_stocks.py (took a while)

<!-- Run the main.py file -->



**Bruh**

cd home/kafka/kafka_2.13-3.7.0

./bin/zookeeper-server-start.sh ./config/zookeeper.properties

./bin/kafka-server-start.sh ./config/server.properties
