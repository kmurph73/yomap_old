require 'byebug'
require 'json'
require 'pg'
root = '/Users/kmurph/code/gmaps/data'
csv_location = '/Users/kmurph/code/gmaps/data/your_csv.csv'

db_exists = false
@conn = 'blah'

def createdb
  p 'createdb'
  conn = PG.connect(dbname: 'template1')
  conn.exec %{
    SELECT pg_terminate_backend(pg_stat_activity.pid)
    FROM pg_stat_activity
    WHERE pg_stat_activity.datname = 'dragworld'
      AND pid <> pg_backend_pid()
  }

  conn.exec %{ DROP DATABASE IF EXISTS dragworld }
  conn.exec %{ CREATE DATABASE dragworld }
end

createdb

conn = PG.connect(dbname: 'dragworld')

conn.exec %{
  CREATE TABLE territories (
      type        varchar(20),
      country     varchar(20),
      state       varchar(20),
      name        varchar(100),
      abbrev      varchar(100),
      slug        varchar(100)
  )
}

conn.exec %{
  COPY territories FROM '#{csv_location}' DELIMITER ',' CSV HEADER;
}
