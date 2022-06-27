# Самоконтроль выполнения задания

1. Где расположен файл с `some_fact` из второго пункта задания?<br>
   Ответ: [playbook/group_vars/all](./group_vars/all/examp.yml)
   
2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?<br>
   Ответ: `ansible-playbook -i inventory/test.yml site.yml`
   
3. Какой командой можно зашифровать файл?<br>
   Ответ: `ansible-vault encrypt examp.yml`
   
4. Какой командой можно расшифровать файл?<br>
   Ответ: `ansible-vault decrypt examp.yml`
   
5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?<br>
   Ответ: `ansible-vault view examp.yml`
   
6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?<br>
   Ответ: `ansible-playbook -i inventory/prod.yml site.yml  --ask-vault-pass`
   
7. Как называется модуль подключения к host на windows?<br>
   Ответ: `winrm - Run tasks over Microsoft's WinRM` `psrp - Run tasks over Microsoft PowerShell Remoting Protocol`
   
8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh<br>
   Ответ: `ansible-doc --type connection ssh`
   
9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?<br>
   Ответ:  `-remote_user`
  <details> 
              
  ```
        User name with which to login to the remote server, normally set by the remote_user keyword.
        If no user is supplied, Ansible will let the SSH client binary choose the user as it normally.
        [Default: (null)]
        set_via:
          cli:
          - name: user
            option: --user
          env:
          - name: ANSIBLE_REMOTE_USER
          ini:
          - key: remote_user
            section: defaults
          keyword:
          - name: remote_user
          vars:
          - name: ansible_user
          - name: ansible_ssh_user
 ```
 </details>
