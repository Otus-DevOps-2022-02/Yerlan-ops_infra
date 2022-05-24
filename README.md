Промежуточное задание:
# Yerlan-ops_infra
Yerlan-ops Infra repository
# Подключение к внутреннему хосту можно выполнить одной командой:
# ssh -J appuser@<Jump Host's Public IPv4 address> appuser@<Internal host's private IPv4 address>

#Чтобы подключиться к внутреннему узлу командой ssh someinternalhost,
#были произведены следующие изменения в ~/.ssh/config файле:

Host bastion
   HostName <Jump Host's Public IPv4 address>
   User appuser
   IdentityFile ~/.ssh/appuser

Host someinternalhost
   HostName <Internal host's private IPv4 address>
   User appuser
   ProxyJump appuser@<Jump Host's Public IPv4 address>

Основное задание:
В настройках сервера добавляем домен 51.250.72.1.sslip.io, тем самым устанавливается сертификат.
Сервис доступен по адресу:
https://51.250.72.1.sslip.io
Адреса:
bastion_IP = 51.250.72.1
someinternalhost_IP = 10.128.0.35

Итого сделано:
• Зарегистрирован YC аккаунт
• Запущены две виртуальные машины
• Настроен Jump host и форвардинг ключей
• Установлен и настроен VPN сервер pritunl
• Добавлен скрипт установки ПО VPN сервера
• Скачан и добавлен файл конфигурации VPN сервера
• Проверена доступность внутреннего узла через Jump host и через VPN
• Настроен Let’s Encrypt сертификат
Как проверить работоспособность:
• Например, перейти по ссылке https://51.250.72.1.sslip.io
