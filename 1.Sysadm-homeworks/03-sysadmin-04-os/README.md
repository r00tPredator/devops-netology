# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

### 1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

Ответ: 
 
 ![142823643-dd98eb39-de62-42c7-a187-dec5c1301e13](https://user-images.githubusercontent.com/35838789/148174788-51931d91-e298-4e50-8743-880d45c9f132.png)
```
создаём юнит файл systemd для запуска: 
sudo systemctl edit --full --force node_exporter.service
uboo@uboo-VirtualBox:~$ cat /etc/systemd/system/node_exporter.service
![image](https://user-images.githubusercontent.com/35838789/142823643-dd98eb39-de62-42c7-a187-dec5c1301e13.png)
[Unit]
Description=Node Exporter
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.listen-address=:9500
[Install]
WantedBy=multi-user.target
Добавил порт --web.listen-address=:9500, потому что 9100 был занят.
systemctl start node_exporter - запускаем
systemctl status node_exporter – проверяем статус

Добавляем сервис в автозагрузку, запускаем его, проверяем статус
 sudo systemctl daemon-reload
 sudo systemctl enable --now node_exporter
 sudo systemctl status node_exporter
```
### 2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

Ответ:
```
metrics по-умолчанию:
uboo@uboo-VirtualBox:~$ curl http://localhost:9500/metrics
HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles. 
TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 2.9627e-05
go_gc_duration_seconds{quantile="0.25"} 2.9627e-05
go_gc_duration_seconds{quantile="0.5"} 4.7151e-05
go_gc_duration_seconds{quantile="0.75"} 5.1326e-05
go_gc_duration_seconds{quantile="1"} 5.1326e-05
go_gc_duration_seconds_sum 0.000128104

CPU:
curl http://localhost:9500/metrics | grep node_cpu_seconds_total

    node_cpu_seconds_total{cpu="0",mode="idle"} 2238.49
    node_cpu_seconds_total{cpu="0",mode="system"} 16.72
    node_cpu_seconds_total{cpu="0",mode="user"} 6.86
    process_cpu_seconds_total
    
Memory:
curl http://localhost:9500/metrics | grep node_memory_MemAvailable_bytes 

    node_memory_MemAvailable_bytes 
    node_memory_MemFree_bytes
    
Disk(для каждого):
curl http://localhost:9500/metrics | grep node_disk_io_time_seconds_total

    node_disk_io_time_seconds_total{device="sda"} 
    node_disk_read_bytes_total{device="sda"} 
    node_disk_read_time_seconds_total{device="sda"} 
    node_disk_write_time_seconds_total{device="sda"}
    
Network(каждый сетевой адаптер):
curl http://localhost:9500/metrics | grep node_network_receive_errs_total
    node_network_receive_errs_total{device="eth0"} 
    node_network_receive_bytes_total{device="eth0"} 
    node_network_transmit_bytes_total{device="eth0"}
    node_network_transmit_errs_total{device="eth0"}
 ```
### 3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). 
После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:
    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```
После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
    
Ответ: 
```
sudo nano /etc/netdata/netdata.conf
На виртуальной машине Linux
uboo@uboo-VirtualBox:~$ sudo lsof -i :19999
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
netdata  918 netdata    4u  IPv4  26407      0t0  TCP localhost:19999 (LISTEN)
netdata  918 netdata   31u  IPv4 124636      0t0  TCP localhost:19999->localhost:58604 (ESTABLISHED)
netdata  918 netdata   32u  IPv4 124637      0t0  TCP localhost:19999->localhost:58606 (ESTABLISHED)
netdata  918 netdata   33u  IPv4 144534      0t0  TCP localhost:19999->localhost:58720 (ESTABLISHED)
firefox 3031    uboo   85u  IPv4 124634      0t0  TCP localhost:58604->localhost:19999 (ESTABLISHED)
firefox 3031    uboo   87u  IPv4 124635      0t0  TCP localhost:58606->localhost:19999 (ESTABLISHED)
firefox 3031    uboo  171u  IPv4 144531      0t0  TCP localhost:58720->localhost:19999 (ESTABLISHED)
На виртуальной машине Linux Vagrant
vagrant@vagrant:~$ sudo lsof -i :19999
COMMAND PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
netdata 735 netdata    4u  IPv4  23552      0t0  TCP *:19999 (LISTEN)
netdata 735 netdata   23u  IPv4  29956      0t0  TCP vagrant:19999->_gateway:52784 (ESTABLISHED)
netdata 735 netdata   27u  IPv4  29957      0t0  TCP vagrant:19999->_gateway:52785 (ESTABLISHED)
netdata 735 netdata   29u  IPv4  29959      0t0  TCP vagrant:19999->_gateway:52786 (ESTABLISHED)
netdata 735 netdata   51u  IPv4  29019      0t0  TCP vagrant:19999->_gateway:52789 (ESTABLISHED)
netdata 735 netdata   52u  IPv4  29021      0t0  TCP vagrant:19999->_gateway:52792 (ESTABLISHED)
netdata 735 netdata   53u  IPv4  29024      0t0  TCP vagrant:19999->_gateway:52799 (ESTABLISHED)
```

![image](https://user-images.githubusercontent.com/35838789/142823756-7db92f5b-afba-4585-93d8-618ceaf93d73.png)

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

Ответ:
```
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.11.0-40
Где vmlinuz и есть первые две буквы vm (virtual machine)
[    0.000000] Hypervisor detected: KVM    # он сразу определил, что это виртуальная машина (Kernel-based Virtual Machine) программное решение, обеспечивающее виртуализацию в среде Linux.
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 4ae01001, primary cpu clock
[    0.000000] kvm-clock: using sched offset of 6690065169 cycles
dmesg (сокр. от англ. diagnostic message) — команда, используемая в UNIX‐подобных операционных системах для вывода буфера сообщений ядра в стандартный поток вывода (stdout)
```
5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

Ответ:
```
uboo@uboo-VirtualBox:~$ sysctl fs.nr_open 
fs.nr_open = 1048576
fs.nr_open  - это максимальное количество файлов(дескрипторов), открываемых пользователем

uboo@uboo-VirtualBox:~$ ulimit -Hn
1048576
-n	the maximum number of open file descriptors
-H	use the `hard' resource limit
```

### 6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

Ответ:
```
root@uboo-VirtualBox:/# ping 8.8.8.8 | sleep 5m 
root@uboo-VirtualBox:~# nsenter --target 3373 --pid --mount
root@uboo-VirtualBox:/# ps
    PID TTY          TIME CMD
   3368 pts/1    00:00:00 sudo
   3369 pts/1    00:00:00 bash
   3679 pts/1    00:00:00 nsenter
   3680 pts/1    00:00:00 bash
   3689 pts/1    00:00:00 ps
```
 ![image](https://user-images.githubusercontent.com/35838789/142823880-ee51de1f-1c92-454f-acac-a55a6985fd46.png)
```
ps aux показывает запущенный процесс nsenter
```
![image](https://user-images.githubusercontent.com/35838789/142823867-01ea998a-346d-4ef3-842b-18d7733665b8.png)

### 7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

Ответ:
```bash
Команда Bash :(){ :|:& };: породит процессы до kernel смерти
•	: снова вызывает эту функцию : .
•	| означает передачу выходных данных в команду.
•	: после | означает трубу(Pipe) к функции : .
•	& , в данном случае, означает выполнение предыдущего в фоновом режиме.
Затем есть ; , который известен как разделитель команд.
Наконец, : запускает эту "цепную реакцию", активируя бомбу fork .
Классический пример fork bomb это  Unix shell  :(){ :|:& };:, которая может быть лучше понять:
fork() {
    fork | fork &
}
fork
```

В нем определяется функция (fork()) вызывает себя (fork), затем piping (|) его результат к фоновой работе самого себя (&).
таким образом это функция, которая параллельно пускает два своих экземпляра. Каждый пускает ещё по два и т.д. 
При отсутствии лимита на число процессов машина быстро исчерпывает физическую память и уходит в swap(раздел подкачки, может быть как и файлом, так и разделом жесткого диска)
```
:(){ :|:& };:
```
Fork был отклонён /user.slice/user-1000.slice/session-1.scope
![image](https://user-images.githubusercontent.com/35838789/142823901-549e26d8-8720-4c7e-8059-8a422712a21c.png)

Максимальное количество процессов PIDs одновременно 5014
 ![image](https://user-images.githubusercontent.com/35838789/142823908-761fbd31-bef5-4d29-8364-651791ca1afd.png)


Что бы поменять на большее количество, пришлось перейти на привилегированный режим sudo и записать с помощью echo и перенаправить > в файл pids.max.
```
vagrant@vagrant:~$ sudo -i
root@vagrant:~#
root@vagrant:~# echo 10028 > /sys//fs/cgroup/pids/user.slice/user-1000.slice/pids.max
```
