Дипломный проект по курсу DevOps
================================
--------------------------------

Состав проекта
==============

```
netology-diplom
|-ansible
|-gitlab
|  |-resources
|  |-tf-scripts
|-result
|-terraform

```

Назначение директорий
=====================
- ansible - директория с ansible playbook, выполняющим конфигурирование инфраструктуры
- gitlab - корневая директория для демонстрации CI/CD процесса в GitLab
  - resources - директория содержит ресурсы, необходимые для демонстрации CI/CD процесса в GitLab
  - tf-demo - директория содержит bash-скрипты, выполняемые terraform
- result - директория со скриншотами работающей инфраструктуры
- terraform - директория с terraform скриптами, выполняющими развертывание инфраструктуры в Yandex Cloud с последующим конфигурированием средствами ansible

Необходимые действия при тестировании
=====================================
$ cd terraform
$ terraform workspace new stage
$ terraform workspace select stage 
$ terraform init -backend-config=backend.conf
$ terraform plan
$ terraform apply

1) выполнить эекспорт переменных окружения:
```shell
export YC_TOKEN=xxxxxxxxxxxxxxxxxxxxxxx
export YC_CLOUD_ID=xxxxxxxxxxxxxxxxxxxxxxx
export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxx
```
  - YC_TOKEN - токен Yandex Cloud
  - YC_CLOUD_ID - id облака
  - AWS_ACCESS_KEY_ID - access_key бакета в Yandex Cloud
  - AWS_SECRET_ACCESS_KEY - secret_key бакета в Yandex Cloud

2) актуализировать переменные в terraform/vars.tf
  - folder_id - id директории в Yandex Cloud
  - core_fraction - процент гарантированного обеспечения CPU
  - preemptible - прерываемая ВМ? (bool)
  - acme_server - acme сервер, используемый для получения сертификатов. доступные значения:
  ```
  CA_NAMES="
  ZeroSSL.com,zerossl
  LetsEncrypt.org,letsencrypt
  LetsEncrypt.org_test,letsencrypt_test,letsencrypttest
  BuyPass.com,buypass
  BuyPass.com_test,buypass_test,buypasstest
  SSL.com,sslcom
  Google.com,google
  Google.com_test,googletest,google_test
  "
  ```
   *https://github.com/acmesh-official/acme.sh/blob/master/acme.sh#L41

  - в проекте по умолчанию используется 'letsencrypttest', для полноценного сертификата, заменить на 'letsencrypt'.

3) перейти в каталог terraform и последовательно выполнить:
  ```shell
  terraform init
  terraform plan
  terraform apply -auto-approve
  ```

4) 25-35 минут (справедливо для прерываемых машин с 20% гарантированного времени CPU) ожидать развертывания инфраструктуры с последующим автоматическим конфигурированием, и автоматической демострацией CI/CD процесса деплоя по тегам.

Скриншоты
=========

## wordpress
![](result/Screenshot%20from%202022-07-10%2015-20-01.png)
![](result/Screenshot%20from%202022-07-10%2015-31-06.png)

## gitlab
![](result/Screenshot%20from%202022-07-10%2015-22-10.png)
![](result/Screenshot%20from%202022-07-10%2015-22-33.png)
![](result/Screenshot%20from%202022-07-10%2015-23-20.png)

## prometheus
![](result/Screenshot%20from%202022-07-10%2015-23-32.png)

## alertmanager
![](result/Screenshot%20from%202022-07-10%2015-23-44.png)

## grafana
![](result/Screenshot%20from%202022-07-10%2015-24-01.png)

## certificate
![](result/Screenshot%20from%202022-07-10%2015-24-41.png)

## infrastructure
![](result/Screenshot%20from%202022-07-10%2015-28-37.png)