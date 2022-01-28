## Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | TypeError: unsupported operand type(s) for +: 'int' and 'str'. Никакого, так как мы пытаемся сложить 'строку' с числом.   |
| Как получить для переменной `c` значение 12?  |c = str(a) + b|
| Как получить для переменной `c` значение 3?  |c = a + int(b)|

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python

#!/usr/bin/env python3
import os
bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```
```

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os

path_git_dir = "~/netology/sysadm-homeworks"
bash_command = ["cd " +path_to_git_dir,"git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('modified:', '')
        print(path_git_dir+"/"+prepare_result.strip())        
```

### Вывод скрипта при запуске при тестировании:
```
~/netology/sysadm-homeworks/README.md
```

 ## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:

```python
#!/usr/bin/env python3
import os
import sys
path_git_dir = "~/netology/sysadm-homeworks"
if len(sys.argv)==2:
    if not os.path.exists(sys.argv[1]) or not os.path.isdir(sys.argv[1]):
        print(f'{sys.argv[1]} directory is not found')
        exit(1) 
    path_git_dir = sys.argv[1]
        
bash_command = ["cd "+path_git_dir, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('modified:', '')
        print(path_git_dir+"/"+prepare_result.strip())


# path_git_dir = sys.argv[1] - Присваиваем перемнной первый аргумент
# Функция len() - Возвращает длину строки.
# os.path.exists() - Этот метод возвращает True, если путь существует, в противном случае возвращает False.
# os.path.isdir(path) - Является ли путь директорией
```

### Вывод скрипта при запуске при тестировании:
```
/home/uboo2/netology/sysadm-homeworks/README.md
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os
import socket
import json
data_file = 'dns-ip.json'
if not os.path.exists(data_file) or os.path.isdir(data_file):
    data = {}
    data['servers'] = []
    server_dns_list = ['drive.google.com', 'mail.google.com', 'google.com']
    for server_dns in server_dns_list:
        data['servers'].append( {
        'dns': server_dns,
        'ip': socket.gethostbyname(server_dns)
        })
    with open(data_file, 'w') as outfile:
        json.dumps(data, outfile)
with open(data_file) as json_file:
    data = json.load(json_file)
write_new_data = False
for server in data['servers']:
    curr_ip = socket.gethostbyname(server['dns'])
    print(f'{server["dns"]} - {curr_ip}')
    if curr_ip != server['ip']:
        print(f'[ERROR] {server["dns"]} IP mismatch: old {server["ip"]} new {curr_ip}')
        write_new_data = True
        server['ip'] = curr_ip
if write_new_data:
    with open(data_file, 'w') as outfile:
        json.dumps(data, outfile)

#socket.gethostbyname_ex('google.com') - Получает IPv4-адрес по имени хоста
```

### Вывод скрипта при запуске при тестировании:
```
drive.google.com - 74.125.131.194
mail.google.com - 216.58.210.165
google.com - 216.58.210.142
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```
