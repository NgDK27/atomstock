**Disclaimer**

Almost done with stock market data

**Prerequisite**

Install postgres (psql), redis, golang, python

Set up database (init.sql file on root)

**Backend service**

Create .env

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
```

```commandline
cd server 
go mod tidy
go run cmd/main.go
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

Run the main.py file
