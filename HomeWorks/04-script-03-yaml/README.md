### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip": "71.78.22.43"
            }
        ]
    }

#Ответ: добавил ковычки "ip": "71.78.22.43"
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис 

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
import socket
import json
import yaml

data_json_file = 'dns-ip.json'
data_yaml_file = 'dns-ip.yaml'

if not os.path.exists(data_json_file) or not os.path.exists(data_yaml_file):
    data = {}
    data['servers'] = []
    server_dns_list = ['drive.google.com', 'mail.google.com', 'google.com']
    for server_dns in server_dns_list:
        data['servers'].append( {
        server_dns: socket.gethostbyname(server_dns)
        })
    with open(data_json_file, 'w') as outfile:
        json.dump(data, outfile)
    with open(data_yaml_file, 'w') as file:
        yaml.dump(data, file)

with open(data_json_file) as json_file:
    data = json.load(json_file)

write_new_data = False
for server in data['servers']:
    for data_dns in server:
        data_ip = server[data_dns]
        curr_ip = socket.gethostbyname(data_dns)
        print(f'{data_dns} - {curr_ip}')
        if curr_ip != data_ip:
            print(f'[ERROR] {data_dns} IP mismatch: old {data_ip} new {curr_ip}')
            write_new_data = True
            server[data_dns] = curr_ip

if write_new_data:
    with open(data_json_file, 'w') as outfile:
        json.dump(data, outfile)
    with open(data_yaml_file, 'w') as file:
        yaml.dump(data, file)
```

### Вывод скрипта при запуске при тестировании:
```
drive.google.com - 74.125.131.194
mail.google.com - 216.58.210.165
google.com - 216.58.210.142

```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"servers": [{"drive.google.com": "74.125.131.194"}, {"mail.google.com": "216.58.210.165"}, {"google.com": "216.58.210.142"}]}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
servers:
- drive.google.com: 74.125.131.194
- mail.google.com: 216.58.210.165
- google.com: 216.58.210.142
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???
