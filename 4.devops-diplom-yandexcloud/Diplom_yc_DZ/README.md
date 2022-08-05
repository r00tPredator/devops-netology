# Дипломный практикум в YandexCloud. Дмитрий Захаров
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
      * [Регистрация доменного имени](#регистрация-доменного-имени)
      * [Создание инфраструктуры](#создание-инфраструктуры)
          * Установка Nginx и LetsEncrypt
          * Установка кластера MySQL
          * Установка WordPress
          * Установка Gitlab CE, Gitlab Runner и настройка CI/CD
          * Установка Prometheus, Alert Manager, Node Exporter и Grafana

---
## Цели:
1. Зарегистрировать доменное имя (любое на ваш выбор в любой доменной зоне).
2. Подготовить инфраструктуру с помощью Terraform на базе облачного провайдера YandexCloud.
3. Настроить внешний Reverse Proxy на основе Nginx и LetsEncrypt.
4. Настроить кластер MySQL.
5. Установить WordPress.
6. Развернуть Gitlab CE и Gitlab Runner.
7. Настроить CI/CD для автоматического развёртывания приложения.
8. Настроить мониторинг инфраструктуры с помощью стека: Prometheus, Alert Manager и Grafana.

Полное описание задания можно посомтреть здесь [README.md](../README.md)

---
## Этапы выполнения:
## Регистрация доменного имени

- Зарегистрирован домен `dmitryzakharov.website`
- Настроено хостинг DNS для домена в YandexCloud `ns1.yandexcloud.net` и `ns2.yandexcloud.net`
![](img/01_webhosting.png)

Создан S3 bucket YC аккаунте.
![](img/02_backet.png)

## Создание инфраструктуры
Структура файлов:
- `main.tf`      Настройки instance.
- `providers.tf` Содержит настройки для подклчюения к провайдеру.
- `variables.tf` Содержит переменные. acme_server - используемый для получения сертификатов LetsEncrypte. 
   Для тестов выставлен `letsencrypttest`, после окончания тестов выставляем `letsencrypt`
- `network.tf`   Содержит настройки сетей.
- `output.tf`    Выходное значение.
- `inventory.tf` Содержит описание подключение к хостам и записывает его в папку `ansible.
- `group_vars.tf`Описание переменных и запись в`/ansible/group_vars/all.yml`
- `backend.conf` Описывает подключние к backet yandex. Скрыт в `gitignore`.
```
endpoint   = "storage.yandexcloud.net"
bucket     = <your-bucket-name>
region     = "ru-central1"
key        = "terraform.tfstate"
access_key = <your-access-key>
secret_key = <your-secret-key>
skip_region_validation      = true
skip_credentials_validation = true
```
-  DNS записи прописаны в `dns.tf` и передаются в YandexCloud.

![](img/03_dns.png)

-  Подключение к облаку происходит через `service account` с ключем `service_account_key_file = "key.json"`. Ключ скрыт в `gitignore`. 

Развертывание инфраструктуры производится командой `terraform apply` из каталога `terraform` данного репозитория.

Запуск в среде stage:
```bash
$ cd terraform
$ terraform workspace new stage
$ terraform workspace select stage 
$ terraform init -backend-config=backend.conf
$ terraform plan
$ terraform apply
```
![](img/04_yc.png)

![](img/05_yc.png)

## Ход действия Ansible.

 Версия `ansible [core 2.13.1]`. Все необходимые роли находятся в каталоге `ansible\roles`. 
 - `ansible\inventory\stage.yml` находится inventory для playbook.
 - `ansible\site.yml` сам playbook
 
Все действие описано в `ansible.tf`, запускается вместе с `terraform apply`. Можно переименовать этот файл `ansible.bcp` и запускать отдельно для тестирования.
 
ansible-playbook -i ../ansible/inventory/stage.yml -t squid ../ansible/site.yml"

ansible-playbook -i ../ansible/inventory/stage.yml -t preconfigure ../ansible/site.yml"

ansible-playbook -i ../ansible/inventory/stage.yml -t nginx ../ansible/site.yml"

ansible-playbook -i ../ansible/inventory/stage.yml -t mysql ../ansible/site.yml"

![](img/mysql_01.png)

ansible-playbook -i ../ansible/inventory/stage.yml -t wordpress ../ansible/site.yml"

ansible-playbook -i ../ansible/inventory/stage.yml -t prometheus ../ansible/site.yml"

ansible-playbook -i ../ansible/inventory/stage.yml -t alertmanager ../ansible/site.yml"

ansible-playbook -i ../ansible/inventory/stage.yml -t grafana ../ansible/site.yml"

ansible-playbook -i ../ansible/inventory/stage.yml -t gitlab ../ansible/site.yml"

ansible-playbook -i ../ansible/inventory/stage.yml -t runner ../ansible/site.yml"

ansible-playbook -i ../ansible/inventory/stage.yml -t copy_ssh ../ansible/site.yml"

После завершения мы увидем страницу с установленным Wordpress `https://www.dmitryzakharov.website`

![](img/06_web.png)

## Gitlab и СICD

Имя пользоватля `root` пароль `gitlab_initial_root_password` можно посмотреть здесь `group_vars\cvs`

![](img/gitlab_01.png) 

В папке`gitlab\tf-scripts` есть два скрипта `gitlab_01.sh` и `gitlab_02.sh` Для запуска коммита и для обновление по tag. 

`gitlab_01.sh`
```
export GIT_SSL_NO_VERIFY=1
cd gitlab
git init ../gitlab/wp-project
git --git-dir=wp-project/.git --work-tree=wp-project remote add origin https://root:Net0logy@gitlab.dmitryzakharov.website/root/wp-project.git
git --git-dir=wp-project/.git --work-tree=wp-project add .
git --git-dir=wp-project/.git --work-tree=wp-project commit -m 'init'
$ git --git-dir=wp-project/.git --work-tree=wp-project push -u origin master
Перечисление объектов: 14, готово.
Подсчет объектов: 100% (14/14), готово.
При сжатии изменений используется до 8 потоков
Сжатие объектов: 100% (14/14), готово.
Запись объектов: 100% (14/14), 2.41 КиБ | 412.00 КиБ/с, готово.
Всего 14 (изменения 5), повторно использовано 0 (изменения 0)
remote: 
remote: 
remote: The private project root/wp-project was successfully created.
remote: 
remote: To configure the remote, run:
remote:   git remote add origin https://gitlab.dmitryzakharov.website/root/wp-project.git
remote: 
remote: To view the project, visit:
remote:   https://gitlab.dmitryzakharov.website/root/wp-project
remote: 
remote: 
remote: 
To https://gitlab.dmitryzakharov.website/root/wp-project.git
 * [new branch]      master -> master
Ветка «master» отслеживает внешнюю ветку «master» из «origin».
```

`gitlab_02.sh`
```
# Применим теперь tag
# Cкопируем файл изменениями в папку c проектом wp-project
cd gitlab
cp resources/02-update/* ../gitlab/wp-project/
git --git-dir=wp-project/.git --work-tree=wp-project add .
git --git-dir=wp-project/.git --work-tree=wp-project commit -m 'update wordpress'
git --git-dir=wp-project/.git --work-tree=wp-project tag -a v1.0 -m 'version 1.0'
git --git-dir=wp-project/.git --work-tree=wp-project push
git --git-dir=wp-project/.git --work-tree=wp-project push --tags
```
После применения коммита по tag мы увидем изменения на сайте.

![](img/cicd_01.png)
<br>

![](img/cicd_02_runner.png) 
<br>

![](img/cicd_03.png)

## Grafana
![](img/grafana_01.png)

## Prometheus
![](img/prometheus_01.png)<br>
![](img/prometheus_02.png)

## Alertmanager
![](img/alertmanager_01.png)
