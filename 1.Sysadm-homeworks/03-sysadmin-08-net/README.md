# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32

Ответ:
````
route-views>show ip route 178.57.199.34
Routing entry for 178.57.199.0/24
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 2d02h ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 2d02h ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 6939
      MPLS label: none
````

````
route-views>show bgp 178.57.199.34  
BGP routing table entry for 178.57.199.0/24, version 1388607497
Paths: (23 available, best #21, table default)
  Not advertised to any peer
  Refresh Epoch 1
  4901 6079 3356 12389 43550
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE0CD309F40 RPKI State not found
      rx pathid: 0, tx pathid: 0
````

2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

Ответ:
````
echo "dummy" >> /etc/modules
echo "options dummy numdummies=2" > /etc/modprobe.d/dummy.conf
nano /etc/network/interfaces
source-directory /etc/network/interfaces.d

auto dummy0
iface dummy0 inet static
 address 10.2.2.2/32


auto dummy1
iface dummy1 inet static
 address 10.2.2.3/32


auto dummy2
iface dummy2 inet static
 address 10.2.2.4/32

sudo ip route add 10.2.2.2 via dummy0
sudo ip route add 10.2.2.3 via dummy1
sudo ip route add 10.2.2.4 via dummy2

#проверяем маршруты
routel
![image](https://user-images.githubusercontent.com/35838789/144337561-2ecc5320-cf89-448e-b072-6abd8f4ab6f1.png)

````


3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

Ответ:
````
# Команда ss используется для отображения информации о сети/сокете TCP/UDP.
ss --tcp
State  Recv-Q  Send-Q    Local Address:Port        Peer Address:Port   Process  
ESTAB  0       0             10.0.2.15:39910     35.227.207.240:https           
ESTAB  0       0             10.0.2.15:50644     34.117.237.239:https           
ESTAB  0       0             10.0.2.15:36716       52.35.82.120:https 
````

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

Ответ:
````
ss --udp
Recv-Q   Send-Q        Local Address:Port       Peer Address:Port     Process   
0        0          10.0.2.15%enp0s3:bootpc         10.0.2.2:bootps      

````

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

Ответ:<br />
![Home network](https://user-images.githubusercontent.com/35838789/144337849-8ee66d10-0d77-4dbc-ab04-96cb7f0a5d39.JPG)
