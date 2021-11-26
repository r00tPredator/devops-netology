Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"
1. Работа c HTTP через телнет.
Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80
отправьте HTTP запрос
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
В ответе укажите полученный HTTP код, что он означает?

Ответ:
Код перенаправления " 301 Moved Permanently " протокола передачи гипертекста (HTTP) показывает, что запрошенный ресурс был окончательно перемещён в URL

HTTP/1.1 301 Moved Permanently
![image](https://user-images.githubusercontent.com/35838789/143571428-45e835ee-c5ab-4747-8470-ab8fe0041f4a.png)


2. Повторите задание 1 в браузере, используя консоль разработчика F12.
откройте вкладку Network
отправьте запрос http://stackoverflow.com
найдите первый ответ HTTP сервера, откройте вкладку Headers
укажите в ответе полученный HTTP код.
проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
приложите скриншот консоли браузера в ответ.

Ответ:
Status Code: 200
![image](https://user-images.githubusercontent.com/35838789/143567112-843a5680-6e79-4081-83d7-844c96d337e9.png)

3. Какой IP адрес у вас в интернете? <br />
Ответ: 188.113.170.62

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois <br />
Ответ: <br />
whois 188.113.170.62
Провайдер - org-name:       Sakhalin Cable Telesystems Ltd
автономной системе AS - origin:         AS51004

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute <br />
Ответ: <br />
sudo apt install traceroute
traceroute -An 8.8.8.8
![image](https://user-images.githubusercontent.com/35838789/143577590-3f94f4b8-e428-4102-97fe-0b02807b3755.png)
Через виртуальную машину не может найти адресов. Основная машина на Windows. <br />
Через Windows командой tracert
![image](https://user-images.githubusercontent.com/35838789/143579719-8bb0334f-a32b-4378-b902-8ebc8f0c1f15.png)

6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay? <br />
Ответ: <br />
mtr -zn 8.8.8.8
![image](https://user-images.githubusercontent.com/35838789/143578493-2368aaa9-8072-4d9a-ba4d-cd45e404f0d0.png)


7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig <br />
Ответ: <br />
dig dns.google
dns.google.		285	IN	A	8.8.4.4
dns.google.		285	IN	A	8.8.8.8
![image](https://user-images.githubusercontent.com/35838789/143577743-aee272ee-4c71-4d9c-a462-a17469c997d1.png)

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig <br />
Ответ: <br />
dig -x dns.google
google.dns.in-addr.arpa.	IN	PTR
![image](https://user-images.githubusercontent.com/35838789/143578121-63551ef4-7aeb-46e8-be5e-3d47980bec1e.png)

В качестве ответов на вопросы можно приложите лог выполнения команд в консоли или скриншот полученных результатов.

