# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

1.	Установите средство виртуализации Oracle VirtualBox.
Решение:
выполнено
sudo apt install virtualbox
2.	Установите средство автоматизации Hashicorp Vagrant.
Решение:
выполнено
sudo apt-get install vagrant
3.	В вашем основном окружении подготовьте удобный для дальнейшей работы терминал.
Решение:
выполнено
В приглашении добавлено текущее время и число фоновых процессов:
PS1='${debian_chroot:+($debian_chroot)}\t \[\033[01;32m\]\u@\h(\j)\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
4.	С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:
Решение:
выполнено    
5.	Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
Решение:
выполнено:
RAM:1024mb
CPU:1 cpu
HDD:64gb
video:8mb
6.	Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
Решение:
добавлением комманд в VagrantFile:
короткие линки
  v.memory = 1024
  v.cpus = 2
или командами ВМ
   config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
     vb.cpu = "2"
   end
  
7.	Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.
Решение:
выполнено    
8.	Ознакомиться с разделами man bash, почитать о настройках самого bash:
Решение: какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?

 HISTFILESIZE - максимальное число строк в файле истории для сохранения, 
строка 1171
    HISTSIZE - число команд для сохранения, 
строка 1194
что делает директива ignoreboth в bash?

ignoreboth является сокращением для ignorespace и ignoredups    
    ignorespace - не сохранять команды, начинающиеся с пробела, 
    ignoredups - не сохранять команду, если такая уже имеется в истории
9.	каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
Решение:
{} - зарезервированные слова, список, в т.ч. список команд в отличии от "(...)" исполнятся в текущем инстансе, 
используется в различных условных циклах, условных операторах, или ограничивает тело функции, 
В командах выполняет подстановку элементов из списка, если упрощенно, то цикличное выполнение команд с подстановкой 
например mkdir ./DIR_{A..Z} - создаст каталоги с именами DIR_A, DIR_B и т.д. до DIR_Z
строка 345

Помещение списка команд между фигурными скобками приводит к тому, что список будет выполняться в текущем контексте оболочки. Подоболочка не создается

10.	Основываясь на предыдущем вопросе, как создать однократным вызовом touch 100000 файлов? А получилось ли создать 300000?
Решение:
Touch команда Unix, предназначенная для установки времени последнего изменения файла или доступа в текущее время. Также используется для создания пустых файлов.
touch {000001..100000}.txt - создаст в текущей директории соответствующее число фалов

300000 - создать не удастся, это слишком длинный список аргументов, максимальное число получил экспериментально - 110188
11.	В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]
Решение:
проверяет условие у -d /tmp и возвращает ее статус (0 или 1), наличие каталога /tmp

12.	Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:
Решение:
$ mkdir /tmp/new_path_dir/
$ cp /bin/bash /tmp/new_path_dir/
$ type -a bash
bash is /usr/bin/bash
bash is /bin/bash
$ PATH=/tmp/new_path_dir/:$PATH
$ type -a bash
bash is /tmp/new_path_dir/bash
bash is /usr/bin/bash
bash is /bin/bash
    
13.	Чем отличается планирование команд с помощью batch и at?
Решение:
at - используется для назначения одноразового задания на заданное время
batch -  для назначения одноразовых задач, которые должны выполняться, когда загрузка системы становится меньше 0,8.

14.	Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
Решение:
vagrant hints

------------------------------------------------------------------------------------------------------------------------------------------------

# Домашнее задание к занятию «2.4. Инструменты Git»
Для выполнения заданий в этом разделе давайте склонируем репозиторий с исходным кодом терраформа https://github.com/hashicorp/terraform
В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены.
1.	Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
2.	Какому тегу соответствует коммит 85024d3?
3.	Сколько родителей у коммита b8d720? Напишите их хеши.
4.	Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
5.	Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
6.	Найдите все коммиты в которых была изменена функция globalPluginDirs.
7.	Кто автор функции synchronizedWriters?

Ответы:

# 1.	Командой git show или git log -p -1

$ git show aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md


# 2.	Первый способ через сайт: "https://github.com/<owner>/<project>/commit/<hash>]

https://github.com/hashicorp/terraform/commit/85024d3
tag v0.12.23 

Второй способ через терминал:
Команда git show 
$ git show 85024d3
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
Author: tf-release-bot <terraform@hashicorp.com>
Date:   Thu Mar 5 20:56:10 2020 +0000

    v0.12.23



# 3.	Первый способ через сайт: https://github.com/hashicorp/terraform/commit/b8d720
Справа в центре увидим: 2 parents 56cd785 + 9ea88f2

Второй способ через терминал: команда git show, где merge родительские коммиты с которыми было слияние.

$ git show b8d720
commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
Merge: 56cd7859e 9ea88f22f
Author: Chris Griggs <cgriggs@hashicorp.com>
Date:   Tue Jan 21 17:45:48 2020 -0800

Или так

$ git log --pretty=%P -n 1 "b8d720"
56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b



# 4.	Первый способ через сайт: https://github.com/hashicorp/terraform/compare/v0.12.23...v0.12.24

Второй способ через терминал:
Команда git log и две точки .. (известный как range ). Без квадратных скобок набирать.
git log [first tag]..[second tag ] --pretty=oneline
или
git log [first commit]..[second commit ] --pretty=oneline

git log v0.12.23..v0.12.24 --pretty=oneline

$ git log v0.12.23..v0.12.24 --pretty=oneline
33ff1c03bb960b332be3af2e333462dde88b279e (tag: v0.12.24) v0.12.24
b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release


# 5.	Имя коммита 5af1e6234ab6da412fb8637393c5a17a1b293663 где находится func providerSource.
С помощью команды git grep -p находим где находится функция func providerSource(…)

$ git grep -p "func providerSource[(].*[)]"
Output:
provider_source.go=import (
provider_source.go:func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {

Дальше запускаем git log с параметром -L, и он покажет нам историю изменения функции или строки кода в нашей кодовой базе.

$ git log -L :providerSource:provider_source.go  # Эта команда определит границы функции, выполнит поиск по истории и покажет все изменения, которые были сделаны с функцией, в виде набора патчей в обратном порядке до момента создания функции.

Output:
commit 5af1e6234ab6da412fb8637393c5a17a1b293663
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Tue Apr 21 16:28:59 2020 -0700







# 6.	Команда git log -L

C помощью опции -L попросить Git показывать только те коммиты, в которых была добавлена или удалена эта строка.
git grep "globalPluginDirs"
git log -L :globalPluginDirs:plugins.go


# 7.	Автор synchronizedWriters  - Martin Atkins, кто создал функцию и James Bardin вносил изменение.
Команда Git log -S развернуто
$ git log -S synchronizedWriters

Или кратко

$ git log -S synchronizedWriters --pretty=format:'%an %ad'
James Bardin Mon Nov 30 18:02:04 2020 -0500
James Bardin Wed Oct 21 13:06:23 2020 -0400
Martin Atkins Wed May 3 16:25:41 2017 -0700

%an - author name

%ad   - author date (format respects --date= option)






  
  

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

