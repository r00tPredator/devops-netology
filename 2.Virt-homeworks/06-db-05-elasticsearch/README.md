# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1
<details><summary>Установка и конфигурирования elastcisearch в docker/summary>
В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.
</details>

### Ответ 1: 

```
docker build -t r00tpredator/centos7es:8.1.0 .
    Successfully tagged r00tpredator/centos7es:8.1.0

sudo docker images
    REPOSITORY               TAG       IMAGE ID       CREATED          SIZE
    r00tpredator/centos7es    8.1.0    6e7a0e7d0b4a   26 minutes ago   3.78GB

docker run --rm -d --name centos_es -p 9200:9200 r00tpredator/centos7es:8.1.0

# fix - ERROR: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
sudo sysctl -w vm.max_map_count=262144

# fix - max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
ulimit -n 65536

# проверка работоспособности
curl -X GET "localhost:9200"
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "_na_",
  "version" : {
    "number" : "8.1.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "3700f7679f7d95e36da0b43762189bab189bc53a",
    "build_date" : "2022-03-03T14:20:00.690422633Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}

root@uboo-pc:~# docker push r00tpredator/centos7es:8.1.0
            The push refers to repository [docker.io/r00tpredator/centos7es]

```
- [Dockerfile-манифест ElasticSearch 8.1.0](src/dockerfile_es8/Dockerfile)
- [Dockerfile-манифест ElasticSearch 7.16.0](Dockerfile)
- [ссылку на образ в репозитории dockerhub](https://hub.docker.com/repository/docker/r00tpredator/centos7es)
- [ответ `elasticsearch` на запрос пути `/` в json виде](src/localhost.png)


## Задача 2
<details><summary>Получите список индексов и их статусов, используя API</summary>
В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.
</details>

### Ответ 2:

```
Создание индексов:
curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}' 

Список индексов:
$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases zjAhWQM3T5CkVn2ET6Exxg   1   0         45            0     42.5mb         42.5mb
green  open   ind-1            _adYIzVJRiuldCnANkfJTg   1   0          0            0       226b           226b
yellow open   ind-3            kjmKuLBTTza-md6WWH1TJA   4   2          0            0       904b           904b
yellow open   ind-2            61j7bnPiQOqjbwZnVVSJRw   2   1          0            0       452b           452b

Статус индексов:
uboo@uboo-pc:~/$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}

uboo@uboo-pc:~/$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty' 
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
uboo@uboo-pc:~/$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty' 
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

Статус кластера:
$ curl -XGET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0

Удаление индексов:
$ curl -X DELETE 'http://localhost:9200/ind-1?pretty' 
{
  "acknowledged" : true
}
$ curl -X DELETE 'http://localhost:9200/ind-2?pretty' 
{
  "acknowledged" : true
}
$ curl -X DELETE 'http://localhost:9200/ind-3?pretty' 
{
  "acknowledged" : true
}
$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases zjAhWQM3T5CkVn2ET6Exxg   1   0         45            0     42.5mb         42.5mb

Почему статус Yellow?
В системе из одного сервера ES хранит на нём все “primary shards”, но создавать “replica shards” такой системе будет негде.
Поэтому статус в приведённом примере является жёлтым из-за ненулевого значения “unassigned_shards”, которое примерно равно “active_shards”.

```
## Задача 3
<details><summary>Бэкапы данных и восстановление</summary>

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`
</details>


### Ответ 3:

Добавил в elasticsearch.yml путь "path.repo: /var/lib/elasticsearch/config/snapshot"

`Создание директории`
```bash
$ curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/var/lib/elasticsearch/config/snapshot" }}'
```
`Вывод`

```bash
{
  "acknowledged" : true
}

```
`Проверяем`

```bash
$ curl http://localhost:9200/_snapshot/netology_backup?pretty
```

`Вывод`
```json
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/var/lib/elasticsearch/config/snapshot"
    }
  }
}
```

`Создание индекса test с 0 репликой и 1 шардом`
```bash
curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
```
`Вывод`
```json
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}1
```

`Поверка результата`
```
curl http://localhost:9200/test?pretty
```

`Ответ`

```json
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1646889848878",
        "number_of_replicas" : "0",
        "uuid" : "_OuNsVsgTSKF4BOtoAVKhg",
        "version" : {
          "created" : "7160099"
        }
      }
    }
  }
}
```

`Cписок файлов в директории со snapshotами`
```bash
$ docker exec centos-es ls -l /var/lib/elasticsearch/config/snapshot/
total 84
-rw-r--r-- 1 elasticsearch elasticsearch  1960 Mar 10 06:03 index-1
-rw-r--r-- 1 elasticsearch elasticsearch     8 Mar 10 06:03 index.latest
drwxr-xr-x 6 elasticsearch elasticsearch  4096 Mar 10 05:27 indices
-rw-r--r-- 1 elasticsearch elasticsearch 29198 Mar 10 05:27 meta-7v-f5vefQfi8enIhvkKihQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch 29198 Mar 10 06:03 meta-T7fkOQzARyevi1gflNJzIg.dat
-rw-r--r-- 1 elasticsearch elasticsearch   712 Mar 10 05:27 snap-7v-f5vefQfi8enIhvkKihQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch   709 Mar 10 06:03 snap-T7fkOQzARyevi1gflNJzIg.dat


Удалите индекс test и создание индекс test-2.
curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true


Добавление индекса test-2
curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}

Команда восстановления:
curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'


Статус индексов:
$ curl -X GET http://localhost:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases omX99HdSReOJnyYzaVPjGQ   1   0         45            0     42.5mb         42.5mb
green  open   test-2           h9tIyX7fRzeQt7Rq3DMiTg   1   0          0            0       226b           226b

```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
