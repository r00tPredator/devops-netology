# Курсовая работа по итогам модуля "DevOps и системное администрирование"

Курсовая работа необходима для проверки практических навыков, полученных в ходе прохождения курса "DevOps и системное администрирование".

Мы создадим и настроим виртуальное рабочее место. Позже вы сможете использовать эту систему для выполнения домашних заданий по курсу

## Задание

### 1. Создайте виртуальную машину Linux.
### 2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.

Ответ:
```bash
$ sudo apt install ufw

$ sudo ufw enable

$ sudo ufw allow 22 #разрешаем трафик для порта 22
Rule added

$ sudo ufw allow 443 #разрешаем трафик для порта 442
Rule added

$ ip add #смотрим какие интерфейсы подключены. Нам нужен localhost.
1: lo: <LOOPBACK,UP,LOWER_UP> 
inet 127.0.0.1/8 scope host lo

$ sudo ufw allow in on lo #разрешить весь трафик для интерфейса localhost (lo)
Rule added

$ sudo ufw status verbose #Проверка состояния и правила ufw
Status: active
```
![2 ufw](https://user-images.githubusercontent.com/35838789/147909799-96f6ba3b-cbcf-459f-afce-da9c56ca0434.JPG)


### 3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).

Ответ:
```bash
#добавляем HashiCorp GPG ключ
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -   

#Добавляем официальный репозиторий HashiCorp Linux
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"  

#Обновление и установка.
sudo apt-get update && sudo apt-get install vault

#Проверяем
vault status
```
![3  Vault instalation_1](https://user-images.githubusercontent.com/35838789/147909821-87fa6f0a-a647-4b10-b148-5fcf6911f61b.JPG)


### 4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).

Ответ:
```bash
#Предварительно устанавливаем JSON. Среда Vault, чтобы следовать примерам, в которых используется этот инструмент.
sudo apt-get install jq

#Запускаем Vault
#В другом терминале запускаем сервер Vault в режиме разработчика с root в качестве корневого токена.
vault server -dev -dev-root-token-id root

#Сервер Vault в режиме разработчика по умолчанию работает на 127.0.0.1:8200. Сервер также инициализируется и распечатывается.
#Экспортируем переменную среды для vault CLI для адресации к серверу Vault.
$ export VAULT_ADDR=http://127.0.0.1:8200

#Экспортируем переменную среды для CLI хранилища для аутентификации на сервере Vault.
$ export VAULT_TOKEN=root

#Vault сервер готов к генерации сертификата.

#Включаем механизм секретов pki.
uboo@web2:~$ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/

#Настройка механизма секретов pki для выдачи сертификатов с максимальным временем жизни(TTL) в часах. В нашем случае один месяц это 730 часов.
uboo@web2:~$ vault secrets tune -max-lease-ttl=730h pki
Success! Tuned the secrets engine at: pki/

#Сгенерируем корневой сертификат и сохраним сертификат в CA_cert.crt.
uboo@web2:~$ vault write -field=certificate pki/root/generate/internal \
     common_name="example.com" \
     ttl=730h > CA_cert.crt

#Это создает новый самозаверяющий сертификат CA и закрытый ключ. Vault автоматически аннулирует сгенерированный кореневой в конце срока аренды (TTL); Cертификат CA будет подписывать свой собственный список отзыва сертификатов (CRL).

#Конфигурируем CA и CRL ссылки(URLs).
uboo@web2:~$ vault write pki/config/urls \
      issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
      crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls

#создаем роль
vault write pki_int/roles/example-dot-com \
     allowed_domains="example.com" \
     allow_subdomains=true \
     allow_bare_domains=true \
     max_ttl="730h"

#Заправшиваем сертификаты.
vault write pki_int/issue/example-dot-com common_name="test.example.com" ttl="24h"

Key                 Value
---                 -----
cha_chain        -----BEGIN CERTIFICATE-----
MIIDwzCCAqugAwIBAgIUTQABMCAsXjG6ExFTX8201xKVH4IwDQYJKoZIhvcNAQEL
BQAwGjEYMBYGA1UEAxMPd3d3LmV4YW1wbGUuY29tMB4XDTE4MDcyNDIxMTMxOVo
             ...
-----END CERTIFICATE-----

certificate         -----BEGIN CERTIFICATE-----
MIIDwzCCAqugAwIBAgIUTQABMCAsXjG6ExFTX8201xKVH4IwDQYJKoZIhvcNAQEL
BQAwGjEYMBYGA1UEAxMPd3d3LmV4YW1wbGUuY29tMB4XDTE4MDcyNDIxMTMxOVoX
             ...

-----END CERTIFICATE-----
issuing_ca          -----BEGIN CERTIFICATE-----
MIIDQTCCAimgAwIBAgIUbMYp39mdj7dKX033ZjK18rx05x8wDQYJKoZIhvcNAQEL
             ...

-----END CERTIFICATE-----
private_key         -----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAte1fqy2Ekj+EFqKV6N5QJlBgMo/U4IIxwLZI6a87yAC/rDhm
W58liadXrwjzRgWeqVOoCRr/B5JnRLbyIKBVp6MMFwZVkynEPzDmy0ynuomSfJkM
             ...
-----END RSA PRIVATE KEY-----
```
![4 root_CA](https://user-images.githubusercontent.com/35838789/147909863-b10d9420-5e0d-4360-8653-082ce37ed898.JPG)

### 5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.

Ответ:
```bash
#скопируем с сервера сертификат на хостовую машиную.
scp uboo@192.168.1.102:/home/uboo/CA_cert.crt /home/uboo2
#Копируем во временное 
sudo cp CA_cert.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

Браузеры такие как (Firefox, Chrome) хранят свои списки доверенных сертификатов в файлах cert9.db. Чтобы добавить свой сертификат в каждый из этих файлов можно использовать скрипт.
```bash
# нам понадобиться утилита certutil, что бы скрипт сработал.
sudo apt install libnss3-tools

nano newcert.sh
#------сам скрипт----------
#!/bin/bash
certfile="CA_cert.crt"
certname="My Root CA"
 
for certDB in $(find ~/ -name "cert9.db")
do
    certdir=$(dirname ${certDB});
    certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d sql:${certdir}
----------------------------
chmode +x newcert.ch
./newcert.sh
```

### 6. Установите nginx.

Ответ:
```bash
sudo apt update
sudo apt install nginx

#что бы на него попасть нужно разрешить трафик в firewall
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'

#проверяем работу службы.
systemctl status nginx 
   Active: active (running)

```

![6  Nginx](https://user-images.githubusercontent.com/35838789/147910049-c27a04ad-e6b7-4f36-b1e2-57d0b127207f.JPG)


### 7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
###  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
###  - можно использовать и другой html файл, сделанный вами;

Ответ:

![7 Site1](https://user-images.githubusercontent.com/35838789/147911109-ba795ebe-bfef-4f10-9c38-d71e38990b54.JPG)

Объединяем три сертификата (сам SSL-сертификат, корневой и промежуточный сертификаты) в один файл website.crt. Есть два способа, в ручную при помощи блокнота или скрипта(будет предоставлен далее). Поочередно копируем и вставляем в созданный документ каждый сертификат. После вставки всех сертификатов файл имеет вид:
```
-----BEGIN CERTIFICATE-----
##Ваш сертификат- сертификат сервера certificate, который мы запросили с помощью команды vault write pki_int/issue/example-dot-com
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
##Промежуточный сертификат intermediate.cert.pem(data.ca_chain)
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
##Корневой сертификат-CA_cert.crt(issuing_ca)
-----END CERTIFICATE-----
```
</details>
Один сертификат идёт следом за другим, без пустых строк.
Создаем файл website.key и скопируем в него содержимое приватного ключа сертификата private_key.<br />
Загружаем созданные файлы your_domain.crt и your_domain.key на сервер в директорию /etc/ssl/.<br />
копируем в директорию ssl получившийся сертификат из 3 (certificate + intermediate.cert.pem + CA_cert.crt)<br />
Ca_Chain - серт промежуточного, issued_ca - корневого, certificate - сертификат сервера, private - закрытый ключ<br />
</Details>
sudo mv CA_cert.crt /etc/ssl



```bash
#открываем конфигурационный файл Nginx
sudo nano /etc/nginx/sites-available/default
#добавляем в файл следующие строки:
server {

    listen 443 ssl;

    server_name your_domain.com;
    ssl_certificate /etc/ssl/your_domain.crt;
    ssl_certificate_key /etc/ssl/your_domain.key;
}
```

```bash
#основной файл конфигурации Nginx. Его можно изменить для внесения изменений в глобальную конфигурацию Nginx
/etc/nginx/nginx.conf

#Дополнительный файл конфигурации.
sudo nano /etc/nginx/sites-available/default

#стартовую страницу можно поменять здесь
nano /var/www/html/index.nginx-debian.html

#Проведим тестирование, чтобы убедиться в отсутствии ошибок синтаксиса в файлах Nginx
sudo nginx -t
# Должен выдать без ошибок:
 nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
 nginx: configuration file /etc/nginx/nginx.conf test is successful

#перезагружаем
systemctl restart nginx

#проверяем статус
systemctl status nginx

```

### 8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.

Ответ:

![8 Site](https://user-images.githubusercontent.com/35838789/147910582-09370737-aa46-4ba8-890f-f57ddb63e647.JPG)

![7 Site_linux](https://user-images.githubusercontent.com/35838789/147910187-a91d4f74-bfe8-49f1-a6a6-16df5efe49fa.JPG)

<details>
Что бы браузер не выдавал ошибку о не защищенном соединение, если нету настроенного dns сервера и прописанного имени в нем.<br /> 
Нужно добавить в локальное хранилище hosts следующую запись:<br />
192.168.1.102 test.example.com<br />
путь в Linux - sudo nano /etc/hosts<br />
путь в Windows - C:\Windows\System32\drivers\etc\hosts<br /> 
</Details>

### 9. Создайте скрипт, который будет генерировать новый сертификат в vault:
### - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
### - перезапускаем nginx для применения нового сертификата.

Ответ:

```bash

nano newcert
----------------------------------
#!/bin/bash

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

#creat role
vault write pki_int/roles/example-dot-com \
     allowed_domains="example.com" \
     allow_subdomains=true \
      max_ttl="730h"

#create certificate, 30 days
vault write -format=json pki_int/issue/example-dot-com common_name="test.example.com" ttl="730h" > /etc/ssl/website.crt

cat /etc/ssl/website.crt | jq -r .data.certificate > /etc/ssl/website.crt.pem
cat /etc/ssl/website.crt | jq -r .data.ca_chain[] >> /etc/ssl/website.crt.pem
cat /etc/ssl/website.crt | jq -r .data.private_key > /etc/ssl/website.key
#mv /home/uboo/website.crt.pem /etc/ssl/
#mv /home/uboo/website.key /etc/ssl/

nginx -t
if [[ $? -eq 0 ]]
then
    echo "Certificate was writed sussesfuly. Nginx will be restart"
sudo systemctl restart nginx
else
    echo "Error write cerificate"
fi
-----------------------------------------
chmod +x newcert

```

### 10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.

Ответ:

```bash
#перемещаем наш ранее созданный скрипт в директорию с сертификатами
sudo mv newcert /etc/ssl/

#редактируем файл автозапуска crontab с помощью прилегированного пользователя
sudo crontab -e
# делаем проверку работы с частотой срабатывания раз в месяц.
3 числа в 17:10 каждый месяц
10 17 3 * * /etc/ssl/newcert

#проверяем командой 
grep CRON /var/log/syslog

#скрипт сработал и заменил наши сертификаты.
```
![10 Cron](https://user-images.githubusercontent.com/35838789/147910386-39f2a03f-a205-442e-8f18-0b9722bc346f.JPG)

![8 Cert_5](https://user-images.githubusercontent.com/35838789/147913049-dce9c49f-4f80-48d6-9dde-dea3c6147fea.JPG)

## Результат


Результатом курсовой работы должны быть снимки экрана или текст:

- Процесс установки и настройки ufw
- Процесс установки и выпуска сертификата с помощью hashicorp vault
- Процесс установки и настройки сервера nginx
- Страница сервера nginx в браузере хоста не содержит предупреждений 
- Скрипт генерации нового сертификата работает (сертификат сервера ngnix должен быть "зеленым")
- Crontab работает (выберите число и время так, чтобы показать что crontab запускается и делает что надо)
