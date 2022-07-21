#!/usr/bin/env bash
cd /var/www/wordpress
/usr/local/bin/wp post create --post_title='Этот пост пришел из GitLab' \
--post_content='GitLab Runner хорошо справился со своей задачей, поэтому мы видим этот пост!' --post_status=publish
