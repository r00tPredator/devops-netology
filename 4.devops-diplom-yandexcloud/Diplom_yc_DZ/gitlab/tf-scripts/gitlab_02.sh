#!/urs/bin/env bash
echo "Update local project in this directory ../gitlab/wp-project"
cp ../gitlab/resources/02-update/* ../gitlab/wp-project/
echo "Add, commit, tag and push"
git --git-dir=../gitlab/wp-project/.git --work-tree=../gitlab/wp-project add .
git --git-dir=../gitlab/wp-project/.git --work-tree=../gitlab/wp-project commit -m 'update wordpress'
export GIT_SSL_NO_VERIFY=1
git --git-dir=../gitlab/wp-project/.git --work-tree=../gitlab/wp-project tag -a v1.0 -m 'version 1.0'
git --git-dir=../gitlab/wp-project/.git --work-tree=../gitlab/wp-project push
git --git-dir=../gitlab/wp-project/.git --work-tree=../gitlab/wp-project push --tags
echo "Wait 20 seconds gitlab-runner working"
sleep 20
echo "All should be done. You can check now https://www.dmitryzakharov.website"


# Применим теперь tag
# Cкопируем файл изменениями в папку c проектом wp-project
# cd gitlab
# cp resources/02-update/* ../gitlab/wp-project/
# git --git-dir=wp-project/.git --work-tree=wp-project add .
# git --git-dir=wp-project/.git --work-tree=wp-project commit -m 'update wordpress'
# git --git-dir=wp-project/.git --work-tree=wp-project tag -a v1.0 -m 'version 1.0'
# git --git-dir=wp-project/.git --work-tree=wp-project push
# git --git-dir=wp-project/.git --work-tree=wp-project push --tags