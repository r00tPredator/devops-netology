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


# 2.	Первый способ через сайт: https://github.com/<owner>/<project>/commit/<hash>

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







# 6.	Команда git log -S

C помощью опции -S попросить Git показывать только те коммиты, в которых была добавлена или удалена эта строка.

$ git log -S globalPluginDirs --oneline
35a058fb3 main: configure credentials from the CLI config file
c0b176109 prevent log output during init
8364383c3 Push plugin discovery down into command package



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

