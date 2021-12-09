# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.<br />
Ответ:<br />
![3 9_Biwarden](https://user-images.githubusercontent.com/35838789/145347158-a62b2a39-1679-4aa3-9326-159421272b09.JPG)

2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.<br />
Ответ:
![3 9_GoogleMFA](https://user-images.githubusercontent.com/35838789/145347922-d25d4754-fd2b-4aac-80d8-43ce093d700e.JPG)

3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.<br />
Ответ:
````
#Устанавливаем apache2
sudo apt-get update
sudo apt install apache2

# включаем mod_ssl с помощью команды a2enmod:
sudo a2enmod ssl #включаем mod_ssl

# Перезапуcкаем Apache, чтобы активировать модуль:
sudo systemctl restart apache2

# Мы можем создать файлы ключей и сертификатов SSL с помощью команды openssl:
# «\» само по себе в конце строки является средством объединения строк вместе.
sudo openssl req -x509 -nodes -days 36500 -newkey rsa:2048 \
-keyout /etc/ssl/private/apache-selfsigned.key \
-out /etc/ssl/certs/apache-selfsigned.crt \
-subj "/C=RU/ST=Russia/L=Sakhalin/O=NetologyHW/OU=Org/CN=www.netologyHW.ru"

# генерировать конфиг файл можно на сайте https://ssl-config.mozilla.org
sudo nano /etc/apache2/sites-available/web1.conf
<VirtualHost *:443>
 ServerName web1
 DocumentRoot /var/www/web1
 SSLEngine on
 SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
 SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
sudo mkdir /var/www/web1
sudo nano /var/www/web1/index.html #создаем, что будет отображатся на странице.
<h1>My site on Apache2 working! By Dmitry Zakharov</h1>
#Затем нам нужно включить файл конфигурации с помощью инструмента a2ensite:
sudo a2ensite web1.conf 
#проверяем. Если Syntex:OK. Значит все впорядке
sudo apache2ctl configtest  
sudo systemctl reload apache2

# гайд https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-20-04
````

4. Проверьте на TLS уязвимости произвольный сайт в интернете.<br />
Ответ:
````
git clone --depth 1 https://github.com/drwetter/testssl.sh.git
cd testssl.sh
# быстрый тест
./testssl.sh -e --fast --parallel https://https://netology.ru/
# проверить сайт на уязвимости
./testssl.sh -U --sneaky https://netology.ru/
Testing vulnerabilities 

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested
````
![3 9_testssl](https://user-images.githubusercontent.com/35838789/145347872-83181f15-ff57-4c1c-80e2-7dde989a47af.JPG)

5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.<br />
Ответ:
````
# установка sshd сервера
sudo apt install openssh-server
sudo ufw allow ssh
systemctl start sshd.service
systemctl enable sshd.service

# генерим ключи, /home/<username>/.ssh/id_rsa - приватный ключ
# id_rsa.pub - публичный ключ
ssh-keygen
uboo@web1:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/uboo/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/uboo/.ssh/id_rsa
Your public key has been saved in /home/uboo/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:######################## uboo@web1


# копируем публичный ключ на удаленный сервер
ssh-copy-id my_user@192.168.1.102

# или копируем вручную в файл authorized_keys
echo public_key_string >> ~/.ssh/authorized_keys

# подключаемся по стандартному ключу
ssh uboo@192.168.1.102

# или подключаемся по нестандартному ключу
ssh -i ~/.ssh/web1.key uboo@192.168.1.102

# проверка SSH шифров
sudo apt install -y ssh-audit

ssh-audit localhost
uboo@web2:~$ ssh-audit localhost
# general
(gen) banner: SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.3
(gen) software: OpenSSH 8.2p1
(gen) compatibility: OpenSSH 7.3+, Dropbear SSH 2016.73+
(gen) compression: enabled (zlib@openssh.com)
````
Screen. Подключение к удаленному серверу.
![3 9_ssh2](https://user-images.githubusercontent.com/35838789/145347512-ef3b0ce7-df0e-44bc-ad5c-e7fd9f071062.JPG)


6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.<br />
Ответ:<br />
![3 9_ssh_mv](https://user-images.githubusercontent.com/35838789/145347771-cfcc8a9b-150e-4d7f-99eb-c39b028d453c.JPG)

````
# переименоуваем
uboo@web1:~/.ssh$ ls
id_rsa  id_rsa.pub  known_hosts
uboo@web1:~/.ssh$ mv -i id_rsa web1
uboo@web1:~/.ssh$ mv -i id_rsa.pub web1.pub
uboo@web1:~/.ssh$ ls
known_hosts  web1  web1.pub

# mkdir -p или --parents. Создать все директории, которые указаны внутри пути. Если какая-либо директория существует, то предупреждение об этом не выводится.
# chmod 700(-rwx------) команда для изменения прав доступа к файлам и каталогам. Только владелец файла, может читать/записывать и запускать на исполнение.
# chmod 600(-rw-------)	только владелец файла может читать/записывать
# «&&» используется для объединения команд таким образом, что следующая команда запускается тогда и только тогда, когда предыдущая команда завершилась без ошибок (или, точнее, выйдет с кодом возврата 0)

mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/config && chmod 600 ~/.ssh/config  #создаем директорию config
nano ~/.ssh/config    #редактируем файл
------------прописываем внутри файла:
Host web2  #имя второго хоста
 HostName 192.168.1.102 #IP второго хоста
 IdentityFile ~/.ssh/web1.pub
 User Uboo
-------------------
#Где: Host — это alias (псевдоним) для нашего SSH-соединения, HostName — IP адрес VPS (или имя хоста, если включен DNS), Port — номер порта, User — имя пользователя.

#Если хотим автоматическое принятие ключа для новых хостов, ставим строчку снизу
#StrictHostKeyChecking no  
````

7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.<br />
Ответ:
````
sudo tcpdump -c 100 -w 100.pcap -i enp0s8
tcpdump: listening on enp0s8, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
125 packets received by filter
0 packets dropped by kernel

sudo apt install wireshark
sudo wireshark
````
Открываем <br />
![3 9_wireshark](https://user-images.githubusercontent.com/35838789/145347415-22d3737d-7fef-4231-b9df-528d4fd389fd.JPG)

````
# Описание команд:

apt install tcpdump
# Дамп интерфейса
tcpdump -i eth0

# список доступных интерфейсов
tcpdump -D

# Дамп с кол-во пакетов 100
tcpdump -c 100 -i enp0s8

# запись в файл
tcpdump -w 0001.pcap -i enp0s8

# чтение из файла
tcpdump -r 100.pcap

# фильтр только TCP port 22
tcpdump -i eth0 port 22

# фильтр Source или Destination IP адрес
tcpdump -i eth0 src 192.168.1.1
tcpdump -i eth0 dst 192.168.1.1
````
