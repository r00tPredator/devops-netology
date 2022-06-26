# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

```ansible 
ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] ***************************************************************

TASK [Gathering Facts] **************************************************************
ok: [localhost]

TASK [Print OS] *********************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *******************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP **************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

```
ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ********************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print all fact] **************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

```
#Centos images with pre-installed python for testing 
docker pull pycontribs/centos:7
docker run --name centos7 -d pycontribs/centos:7 sleep 60000000

#Ubuntu images with pre-installed python for testing 
docker pull pycontribs/ubuntu:latest
docker run --name ubuntu -d ubuntu:22.04 sleep 60000000
```


4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

```
ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print all fact] **************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "deb"
}
ok: [centos7] => {
    "msg": "el"
}

PLAY RECAP *************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

[deb default fact](./playbook/group_vars/deb/examp.yml)<br>
[el default fact](./playbook/group_vars/el/examp.yml)

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

```
ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print all fact] **************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP *************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```
uboo@uboo-pc:~/devops/devops-netology/3.Mnt-homeworks/08-ansible-01-base/playbook/group_vars/deb$ ansible-vault encrypt examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful

uboo@uboo-pc:~/devops/devops-netology/3.Mnt-homeworks/08-ansible-01-base/playbook/group_vars/deb$ cd ..

uboo@uboo-pc:~/devops/devops-netology/3.Mnt-homeworks/08-ansible-01-base/playbook/group_vars$ cd el

uboo@uboo-pc:~/devops/devops-netology/3.Mnt-homeworks/08-ansible-01-base/playbook/group_vars/el$ ansible-vault encrypt examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

```
# На первый запуск выдает ошибку, если сделать запрос без дополнительного ключа

ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] **************************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
```

```
# c ключем --ask-vault-pass
ansible-playbook -i inventory/prod.yml site.yml  --ask-vault-pass
Vault password: 

PLAY [Print os facts] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print all fact] **************************************************************************************************************************
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}

PLAY RECAP *************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0  
skipped=0    rescued=0    ignored=0
```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

```
ansible-doc --type connection --list
# ansible-doc -t connection -l  (сокращенный вариант)

...
...
local    execute on controller
...
...

```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

[prod.yml](./playbook/inventory/prod.yml)

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

```
ansible-playbook -i inventory/prod.yml site.yml  --ask-vault-pass
Vault password: 

PLAY [Print os facts] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [ubuntu]
ok: [localhost]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print all fact] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.


## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

```
/08-ansible-01-base/playbook$ ansible-vault decrypt group_vars/deb/examp.yml
Vault password: 
Decryption successful

ansible-vault decrypt group_vars/el/examp.yml
Vault password: 
Decryption successful
```
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

[examp.yml](./playbook/group_vars/all/examp.yml)

```
# создаем файл с паролем
echo netology > ~/.ansible_pass.txt

# шифруем строку. Вывод копируем в файл group_vars/all/examp.yml
ansible-vault encrypt_string "PaSSw0rd" --name "some_fact" --vault-password-file ~/.ansible_pass.txt
Encryption successful

some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          66626436343039633034663862613033613735616266633139663935306232666635666437626432
          6665626636346135303931633230326333613031313538640a363263323038386364333361323661
          61343431383466633662353137366430376462323062373832366338303930636361373830353631
          3364383736386637620a306435626439303463663630326634623638663930666330663631396161
```

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

```
# Первый запуск без ключа с паролем
ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print all fact] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
fatal: [localhost]: FAILED! => {"msg": "Attempting to decrypt but no vault secrets found"}

PLAY RECAP *************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

```
# Второй запуск с паролем
ansible-playbook -i inventory/prod.yml site.yml  --ask-vault-pass
Vault password: 

PLAY [Print os facts] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [ubuntu]
ok: [localhost]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print all fact] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP *************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

```
# загрузка и запуск образа
docker pull pycontribs/fedora
docker run --name fedora -d pycontribs/fedora sleep 60000000

# запуск с новыми параметрами
ansible-playbook -i inventory/prod.yml site.yml  --ask-vault-pass
Vault password: 

PLAY [Print os facts] **************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [fedora]
ok: [centos7]

TASK [Print OS] ********************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print all fact] **************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "fed default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP *************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

```
#!/bin/bash 
images_list_base=( "fedora:latest" "ubuntu:latest" "centos:7" )

for image in ${images_list_base[@]}
    do
        if [[ "$(docker images -q $image 2> /dev/null)" == "" ]]; then
            docker pull $image
        fi
    done
if [[ "$(docker images -q my_ubuntu:latest 2> /dev/null)" == "" ]]; then
           docker build . --tag my_ubuntu
        fi

containers_list=( fedora ubuntu centos7 )
images_list_local=( fedora:latest my_ubuntu:latest centos:7 )

for (( i = 0; i < ${#images_list_local[@]}; i++ ))
do
    docker run --name ${containers_list[$i]} -d ${images_list_local[$i]} sleep 60000000
done

sleep 10
ansible-playbook -i inventory/prod.yml site.yml --vault-pass-file credentials 

for container in ${containers_list[@]}
    do
        docker stop $container && docker rm $container
    done
```

6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.


---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
