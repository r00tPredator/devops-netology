# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

### Ответ 1:
```
root@uboo-pc:~# docker exec -it pg-docker bash
root@2c08e9f0c95c:/# psql -h localhost -p 5432 -U postgres -W
Password: 
psql (13.6 (Debian 13.6-1.pgdg110+1))

# Вывод списка БД
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
   
-----------+----------+----------+------------+------------+--------------------
---
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres        
  +
           |          |          |            |            | postgres=CTc/postgr
es
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres        
  +
           |          |          |            |            | postgres=CTc/postgr
es
(3 rows)

# Подключения к БД
# \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
# connect to new database (currently #"postgres")

# Вывод списка таблиц
# list tables, views, and sequences
# \d[S+]
postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner   
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
      

# Вывод описания содержимого таблиц. 
# describe table, view, sequence, or index
# \d[S+]  NAME  
postgres=# \dS+ pg_index
                                      Table "pg_catalog.pg_index"
     Column     |     Type     | Collation | Nullable | Default | Storage  | Sta
ts target | Description 
----------------+--------------+-----------+----------+---------+----------+----
----------+-------------
 indexrelid     | oid          |           | not null |         | plain    |    
          | 
 indrelid       | oid          |           | not null |         | plain    |    
          | 
 indnatts       | smallint     |           | not null |         | plain    |    

# выхода из psql
postgres-# \q
root@2c08e9f0c95c:/# 

```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

### Ответ 2:
```
# Скопируем backup в volumes на хосте
sudo cp test_dump.sql /var/lib/docker/volumes/vol_postgres/_data

# На докере заходим в posgres
root@2c08e9f0c95c:/# psql -h localhost -p 5432 -U postgres -W

# Создаем базу данных
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=# \q

# Восстановливаем бэкап БД в `test_database`.
root@2c08e9f0c95c:/var/lib/postgresql/data# psql -U postgres -f ./test_dump.sql test_database
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE

# Опять заходим в posgres и подключаемся к test_databse
root@2c08e9f0c95c:/var/lib/postgresql/data# psql -h localhost -p 5432 -U postgres -W
postgres=# \c test_database
Password:
You are now connected to database "test_database" as user "postgres".
test_database=# 
test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner   
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

# Проводим операцию ANALYZE для сбора статистики по таблице
test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE

# Используя таблицу [pg_stats], находим столбец таблицы `orders` 
test_database=# SELECT avg_width FROM pg_stats WHERE tablename='orders';
 avg_width 
-----------
         4
        16
         4
(3 rows)

```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

### Ответ 3:

```
# Преобразуем существующую таблицу в партиционированную (partitioned table). 
# Для этого пересоздадим таблицу.
test_database=# alter table orders rename to orders_simple;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_1 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_2 partition of orders for values from (499) to (999999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_simple;
INSERT 0 8

test_database=# \dt
                   List of relations
 Schema |      Name      |       Type        |  Owner   
--------+----------------+-------------------+----------
 public | orders         | partitioned table | postgres
 public | orders_1       | table             | postgres
 public | orders_2       | table             | postgres
 public | orders_simple  | table             | postgres
(4 rows)

# Да, ручное разбиение можно было исключить, если изночально она была бы секционированной таблицей(table), а не партиционированной (partitioned table).

```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?


### Ответ 4:
```
# Создаем бэкап БД `test_database`.
root@2c08e9f0c95c:/var/lib/postgresql/data# pg_dump -U postgres -d test_database > test_database_dump.sql
# Проверяем.
root@2c08e9f0c95c:/var/lib/postgresql/data# ls
base	      pg_hba.conf    pg_notify	   pg_stat	pg_twophase  postgresql.auto.conf  test_database_dump.sql
global	      pg_ident.conf  pg_replslot   pg_stat_tmp	PG_VERSION   postgresql.conf	   test_dump.sql
pg_commit_ts  pg_logical     pg_serial	   pg_subtrans	pg_wal	     postmaster.opts
pg_dynshmem   pg_multixact   pg_snapshots  pg_tblspc	pg_xact      postmaster.pid

# Для уникальности можно добавить индекс или первичный ключ.
test_database=# CREATE INDEX ON orders ((lower(title)));
CREATE INDEX

```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
