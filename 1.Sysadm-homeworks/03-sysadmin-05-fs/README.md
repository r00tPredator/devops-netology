# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.
    
    Ответ: файл, в котором последовательности нулевых байтов[1] заменены на информацию об этих последовательностях (список дыр).
    
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
    
    Ответ: Жесткая ссылка и файл, для которой она создавалась имеют одинаковые inode. Поэтому жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл.
3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

Ответ:

![image](https://user-images.githubusercontent.com/35838789/143229370-e8e0e5b6-7337-4658-832d-ab4cacf98196.png)

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
    
    Ответ:
```bash
sudo fdisk -l /dev/xvda  # выводит описание устройства
sudo fdisk /dev/sdb
Command: n
Command: p (primary)
Partition number: 1
First sector (2048-5242879, default 2048): Enter # оставляем по умолчанию
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G
Created a new partition 1 of type 'Linux' and of size 2 GiB.
# Создаем второй раздел на оставшееся место.
Command: n
Command: p (primary)
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):
Created a new partition 2 of type 'Extended' and of size 511 MiB.
Command: p # проверяем, что разделы созданы
Command: w (write – сохраняем изменения и выходим)
The partition table has been altered.
```
![image](https://user-images.githubusercontent.com/35838789/143229699-f2f79534-0635-4c1b-9bfd-f04de5850d52.png)

5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
  
  Ответ:
```bash
sudo -i
sfdisk -d /dev/sdb | sfdisk /dev/sdc
```
 ![image](https://user-images.githubusercontent.com/35838789/143229798-c635eb69-cefd-41d8-a333-b480f260434f.png)
```bash
 sudo fdisk -l
```
![image](https://user-images.githubusercontent.com/35838789/143229863-9508dfa0-a57c-4d68-a5cc-be236a42756b.png)

6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.
 
 Ответ:
 ```bash
lsblk  # просмотр иерархии данных
cat /proc/mdstat # посмотреть состояние RAID’а
mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b,c}1
# или
mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sdb1 /dev/sdc1
```

``` 
    где:
	/dev/md0 — устройство RAID, которое появится после сборки; 
	-l 1 — уровень RAID; 
	-n 2 — количество дисков, из которых собирается массив; 
	/dev/sd{b,c}1 — сборка выполняется из дисков sdb1 и sdc1.
	/dev/sdb1— первый диск
	/dev/sdc1 – второй диск
```
![image](https://user-images.githubusercontent.com/35838789/143230869-c57ea0e8-0aea-4673-8631-7772472fcb6f.png)

7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
    
    Ответ:
```
#Второй раз не хотел делать RAID0 на оставшихся дисках.
#После ввода команды 
mdadm --create --verbose /dev/md0 --level=0 --raid-devices 2 /dev/sdb2 /dev/sdc2
#Выдавал ошибку: 
mdadm: ddf: Cannot create this array on device /dev/sdb2 - a container is required.
mdadm: Cannot create this array on device /dev/sdb2
mdadm: device /dev/sdb2 not suitable for any style of array
```
Помогла перезагрузка. Дальше все прошло хорошо.

```
mdadm --create --verbose /dev/md1 --level=0 --raid-devices 2 /dev/sdb2 /dev/sdc2
```
![image](https://user-images.githubusercontent.com/35838789/143231290-e7dbc97a-b955-4714-b28a-e92f39282e8b.png)
p.s. после перезагрузки RAID md0 и md1 были автоматом переименованы в md126 и md127

8. Создайте 2 независимых PV на получившихся md-устройствах.
    
    Ответ:
```
sudo apt install lvm2
root@vagrant:~# sudo pvcreate /dev/md126 /dev/md127  
 Physical volume "/dev/md126" successfully created.
 Physical volume "/dev/md127" successfully created.
 pvs  # посмотреть информацию о Physical Volume
 pvscan # расширенная информация
 pvdisplay  # расширенная информация 
```
![image](https://user-images.githubusercontent.com/35838789/143231859-a1de6252-9c74-470c-943e-35f78a5e8c41.png)

9. Создайте общую volume-group на этих двух PV.

 Ответ:
 pvs – смотрим информацию о PVS
 ```bash
 root@vagrant:~# vgcreate vol_grp1 /dev/md126 /dev/md127
  Volume group "vol_grp1" successfully created
 ```
![image](https://user-images.githubusercontent.com/35838789/143231935-f5e44a31-024d-49ab-91cf-86330b94edff.png)

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

Ответ:
lvcreate - create a logical volume in an existing volume group

```bash
root@vagrant:~# sudo lvcreate -L 100M -n logical_vol1 vol_grp1
  Logical volume "logical_vol1" created.
# -n  это name. Указание имени
```
![image](https://user-images.githubusercontent.com/35838789/143231977-8abb01c9-8b6b-4131-891a-10506c465609.png)

11. Создайте `mkfs.ext4` ФС на получившемся LV.

Ответ: 
```bash
mkfs.ext4  # монтирование ext4
mkfs.ext4  # /dev/vol_grp1/logical_vol1
```
12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

Ответ:
Сделал в папку mnt
```bash
mount /dev/vol_grp1/logical_vol1 /mnt/
```
13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

Ответ:
wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /mnt/test.gz
![image](https://user-images.githubusercontent.com/35838789/143232310-521693c9-d45d-49ed-bebf-a201ccc07800.png)

14. Прикрепите вывод `lsblk`.

Ответ: 
![image](https://user-images.githubusercontent.com/35838789/143232474-142481fd-7b12-4874-b61a-80e7fc7b73cc.png)

15. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
    Ответ:
![image](https://user-images.githubusercontent.com/35838789/143232571-24586450-e96c-486a-b948-b07ecd61a853.png)

16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
    
    Ответ:

Перенос эстенты с одного физического тома на другой.

Перенос логического тома LV из одного физического тома (PV) в другой, внутри одной группы томов(VG)

Перенос логического тома lv001 с /dev/sda5 на /dev/sdb1
```bash
root@vagrant:~# pvmove -n logical_vol1 /dev/md126 /dev/md127
  /dev/md126: Moved: 32.00%
  /dev/md126: Moved: 100.00%
```
![image](https://user-images.githubusercontent.com/35838789/143232710-e31d05a6-3dc0-4567-91d5-09e3731a979e.png)

17. Сделайте `--fail` на устройство в вашем RAID1 md.
 
 Ответ:
 ```bash
mdadm /dev/md0 --fail /dev/sda1
root@vagrant:~# mdadm /dev/md127 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md127
  ```
![image](https://user-images.githubusercontent.com/35838789/143232761-b3f1f527-6875-4f4c-be9a-f2f5b0336afa.png)

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

Ответ:
![image](https://user-images.githubusercontent.com/35838789/143232814-5424069c-c9c9-4538-8d61-51c8fae06bd5.png)

19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
    Ответ:
![image](https://user-images.githubusercontent.com/35838789/143232910-b985eafb-925f-475f-88ff-a75656accf8f.png)

20. Погасите тестовый хост, `vagrant destroy`.

 
 ---

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Также вы можете выполнить задание в [Google Docs](https://docs.google.com/document/u/0/?tgif=d) и отправить в личном кабинете на проверку ссылку на ваш документ.
Название файла Google Docs должно содержать номер лекции и фамилию студента. Пример названия: "1.1. Введение в DevOps — Сусанна Алиева".

Если необходимо прикрепить дополнительные ссылки, просто добавьте их в свой Google Docs.

Перед тем как выслать ссылку, убедитесь, что ее содержимое не является приватным (открыто на комментирование всем, у кого есть ссылка), иначе преподаватель не сможет проверить работу. Чтобы это проверить, откройте ссылку в браузере в режиме инкогнито.

[Как предоставить доступ к файлам и папкам на Google Диске](https://support.google.com/docs/answer/2494822?hl=ru&co=GENIE.Platform%3DDesktop)

[Как запустить chrome в режиме инкогнито ](https://support.google.com/chrome/answer/95464?co=GENIE.Platform%3DDesktop&hl=ru)

[Как запустить  Safari в режиме инкогнито ](https://support.apple.com/ru-ru/guide/safari/ibrw1069/mac)

Любые вопросы по решению задач задавайте в чате Slack.

---
