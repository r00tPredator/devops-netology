#!/urs/bin/env bash

# echo "Create local project in ../gitlab/wp-project"
git init ../gitlab/wp-project
echo "Setup the project"
git --git-dir=../gitlab/wp-project/.git --work-tree=../gitlab/wp-project remote add origin https://root:Net0logy@gitlab.dmitryzakharov.website/root/wp-project.git
echo "copy files and take git push"
cp -rT ../gitlab/resources/01-init ../gitlab/wp-project
git --git-dir=../gitlab/wp-project/.git --work-tree=../gitlab/wp-project add .
git --git-dir=../gitlab/wp-project/.git --work-tree=../gitlab/wp-project commit -m 'init'
export GIT_SSL_NO_VERIFY=1
git --git-dir=../gitlab/wp-project/.git --work-tree=../gitlab/wp-project push -u origin master
echo "All done. Wait 100 seconds before next CI/CD commit"
echo "You can visit the site now https://www.dmitryzakharov.website"
echo "Waiting commit 2"
sleep 100


# export GIT_SSL_NO_VERIFY=1
# cd gitlab
# git init ../gitlab/wp-project
# git --git-dir=wp-project/.git --work-tree=wp-project remote add origin https://root:Net0logy@gitlab.dmitryzakharov.website/root/wp-project.git
# git --git-dir=wp-project/.git --work-tree=wp-project add .
# git --git-dir=wp-project/.git --work-tree=wp-project commit -m 'init'
# $ git --git-dir=wp-project/.git --work-tree=wp-project push -u origin master
# Перечисление объектов: 14, готово.
# Подсчет объектов: 100% (14/14), готово.
# При сжатии изменений используется до 8 потоков
# Сжатие объектов: 100% (14/14), готово.
# Запись объектов: 100% (14/14), 2.41 КиБ | 412.00 КиБ/с, готово.
# Всего 14 (изменения 5), повторно использовано 0 (изменения 0)
# remote: 
# remote: 
# remote: The private project root/wp-project was successfully created.
# remote: 
# remote: To configure the remote, run:
# remote:   git remote add origin https://gitlab.dmitryzakharov.website/root/wp-project.git
# remote: 
# remote: To view the project, visit:
# remote:   https://gitlab.dmitryzakharov.website/root/wp-project
# remote: 
# remote: 
# remote: 
# To https://gitlab.dmitryzakharov.website/root/wp-project.git
#  * [new branch]      master -> master
# Ветка «master» отслеживает внешнюю ветку «master» из «origin».