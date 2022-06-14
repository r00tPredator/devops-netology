# Infrastructure As Code

> Для начала работы установите следующие env переменные, получить их можно при установке yandex cloud cli

- export TF_VAR_yc_token= - тот же токен что при установке cli
- export TF_VAR_yc_cloud_id= взять из ГУИ облака

Если возникли проблемы при работе приложения, нет доступа к новостному API то выполните следующие действия:

- Зарегистрируйтесь и получите API ключ [News API](https://newsapi.org/register)
- Полученный ключ укажите в переменной **news_app_api_key** в файле **ansible/inventory/demo/group_vars/news.yml**
- Разверните приложение заново используя **make reconfig**
### Для деплоя в облако:

```shell
make all
```

### Для удаления из облака:

```shell
make destroy && make clean
```