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


**AI-Feature**
## Install dependencies

Install poetry https://python-poetry.org/
```aiignore
cd ./ai_backend
poetry install
```

## Initialize API Keys
1. Create a .env in the root folder
2. Copy+Paste this template:
   
LANGFUSE_SECRET_KEY="YOUR_LANGFUSE_SECRET_KEY"

LANGFUSE_PUBLIC_KEY="YOUR_LANGFUSE_PUBLIC_KEY"

LANGFUSE_HOST="https://cloud.langfuse.com"

OPENAI_API_KEY='YOUR_OPENAI_API_KEY'

VOYAGE_API_KEY ='YOUR_VOYAGE_API_KEY'

## Back-end
### Install dependencies

cd backend

python3 -m venv .venv

source .venv/bin/activate

pip install -r requirements.txt

### Setup Instructions for Running Flask Backend with Flutter Frontend

1. Check local network IP Address

Run the following command to find your local network IP address:

`ifconfig`

Note the IP address associated with your network interface (usually starts with **`192.168.x.x`**).

2. Allow Flask Port in Firewall:

- Open port `5000` in the firewall to allow incoming connections:

sudo ufw allow 5000

- Verify the firewall status:

sudo ufw status

3. Verify Flask Server is Running:

- Check that Flask is listening on the correct port:

sudo lsof -i -P -n | grep LISTEN

The output should include a line similar to:

python    7464       phongtran    4u  IPv4  51710      0t0  TCP *:5000 (LISTEN)

4. Update API URL in Flutter App:

Modify the `apiUrl` in `openai_service.dart` to reflect your local network IP address:

final String apiUrl = 'http://{local_network_IP_address}:5000/generate_response';

### Run Back-end

cd backend

python app.py

## Front-end
### Install packages

flutter pub get

### Run Front-end

flutter run
