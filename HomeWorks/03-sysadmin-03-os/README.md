# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

### 1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`.

Ответ:
```
cd также доступная как chdir (англ. change directory — изменить каталог) 
chdir("/tmp")  
# пятая строчка снизу в man
```
### 2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
### Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

Ответ:<br /> 
```
uboo@uboo-VirtualBox:~$ file /tmp/
/tmp/: sticky, directory
uboo@uboo-VirtualBox:~$ file /dev/
/dev/: directory
uboo@uboo-VirtualBox:~$ file /dev/pts/0
/dev/pts/0: character special (136/0)

Доработка:
Нашел магическую базу данных magic!
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
База данных в файле magic.mgc.
Вырезка из man:
The database of these “magic patterns” is usually located in a binary file in/usr/local/share/misc/magic.mgc or a directory of source text magic pattern fragment files in /usr/local/share/misc/magic.
 ```  
### 3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

Ответ:<br />
 ![image](https://user-images.githubusercontent.com/35838789/142710588-5fdcca9d-cf33-490c-8431-d3230cc52c51.png)
```
Нашел с помощью команды все удаленные файлы
uboo@uboo-VirtualBox:~$  lsof -nP | grep '(deleted)'

Нашел удаленный log файл 
gnome-she 1331 uboo   31r      REG                8,5    32768    417 /home/uboo/.local/share/gvfs-metadata/root-d02ebdf2.log (deleted)
Где 1331 номер PID 
31 – номер дескриптора

С помощью команды /proc/<PID>/fd/*дескриптор*  записал его в /tmp/ и назвал root.log
uboo@uboo-VirtualBox:~$ cat /proc/1331/fd/31 > /tmp/root.log
uboo@uboo-VirtualBox:~$ cat /tmp/root.log

Вручную можно «освободить» эти файлы так:
 : > /proc/$PROC/fd/$FD
Где $PROC — номер процесса, а $FD — номер файлового дескриптора
Или так:
 > /proc/$PROC/fd/$FD

Чтобы пройтись по всем таким файлам разом, выполняем эту команду :
find /proc/*/fd -ls 2> /dev/null | awk '/deleted/ {print $11}' | xargs -p -n 1 truncate -s 0
```

### 4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

Ответ: 
Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.

### 5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
 На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
    
Ответ:
```
uboo@uboo-VirtualBox:~$ dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc   # потребовало привилегий, указал sudo
uboo@uboo-VirtualBox:~$ sudo /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
1522   gsd-color          15   0 /etc/localtime
1522   gsd-color          15   0 /etc/localtime
547    NetworkManager     24   0 /var/lib/NetworkManager/timestamps.VB97C1
1      systemd            25   0 /proc/64578/cgroup
1      systemd            25   0 /proc/6290/cgroup
1331   gnome-shell        32   0 /proc/self/stat
```

### 6.	Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

Ответ:
```
системный вызов uname()
uboo@uboo-VirtualBox:~$ uname -a
Linux uboo-VirtualBox 5.11.0-40-generic #44~20.04.2-Ubuntu SMP Tue Oct 26 18:07:44 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

Цитата из man:
     Part of the utsname information is also accessible  via  /proc/sys/ker‐
       nel/{ostype, hostname, osrelease, version, domainname}.
``` 

### 7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
Есть ли смысл использовать в bash `&&`, если применить `set -e`?

Ответ:<br />
&& -  условный оператор,<br /> 
а ;  - разделитель последовательных команд<br /> 
С параметром -e оболочка завершится только при ненулевом коде возврата команды. Если ошибочно завершится одна из команд, разделённых &&, то выхода из шелла не произойдёт. Так что, смысл есть.

### 8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

Ответ:<br />
-e прерывает выполнение исполнения при ошибке любой команды кроме последней в последовательности.<br /> 
-x вывод трейса простых команд.<br /> 
-u неустановленные/не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки и выполнит завершение неинтерактивного вызова<br />
-o pipefail возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для успешного выполнения команд.<br />

### 9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

Ответ:<br /> 
S*(S,S+,Ss,Ssl,Ss+) - Процессы ожидающие завершения (спящие с прерыванием "сна")<br /> 
I*(I,I<) - фоновые(бездействующие) процессы ядра<br /> 

дополнительные символы — это дополнительные характеристики, например приоритет.<br /> 
