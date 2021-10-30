# devops-netology
Исключает все Локальные каталоги .terraform
** /. terraform / *

Исключает файлы заканчивающиеся и содержащие .tfstate
* .tfstate
* .tfstate. *

Игнорирует Файлы журнала сбоев
crash.log

Исключяет все файлы .tfvars

* .tfvars

Игнорировать файлы:
override.tf
override.tf.json
* _override.tf
* _override.tf.json

Комментарий #. Не участвует в исключении.
#! example_override.tf

Включить файлы tfplan для игнорирования вывода плана команды: terraform plan -out = tfplan

Игнорировать файлы конфигурации CLI
.terraformrc
terraform.rc

new line
new line2
