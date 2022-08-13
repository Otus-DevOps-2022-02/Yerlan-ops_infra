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

Задание №6.

Сервер, созданный при помощи автоматического скрипта:
testapp_IP = 62.84.118.240
testapp_port = 9292

Была произведена предварительная установка следующих пакетов: curl для тестирования подключения к удаленному серверу
При запуске новой сессии git bash (команда bash из оболочки powershell), необходимого для задействования скрипта startupserver.sh, постоянно сбрасывались настройки ssh введенные ранее в предыдущей сессии следующими командами, которые постоянно приходилось вводить вручную в каждой новой сессии:

eval `ssh-agent -s` > /dev/null
ssh-add ~/.ssh/appuser

Кроме того, ssh-agent по умолчанию не был запущен и выдавал ошибку: "Could not open a connection to your authentication agent".
Проблему решил правкой конфигурационного файла C:/Program Files/Git/etc/bash.bashrc, отвечающего за поддержку конфигурации в текущих сессиях?
введя начиная с линии №23 следующие строки:

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add ~/.ssh/appuser
fi

Таким образом проблема сброса настроек ssh была решена.

Собстенно, скрипт startupserver.sh, был сделан по предлагаемому образцу:

	#!bin/bash

	yc compute instance create \
	  --name reddit-app2 \
	  --hostname reddit-app2 \
	  --memory=4 \
	  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
	  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
	  --metadata serial-port-enable=1 \
	  --metadata-from-file user-data=./metadata.yaml

	sh connect_script.sh

команды скрипта deploy.sh были выполнены в формате sudo runuser -l yc-user -c 'some command' для того чтобы gem'ы и другие пакеты rail/puma не ставились с правами root, а с правами аккаунта yc-user на тот случай, если потребовался бы их перезапуск, чтобы было с ними удобнее обращаться без команды sudo, а также для безопасности запускаемых веб-приложений и скриптов.
Запуск всех трех (install_ruby.sh mongodb.sh и deploy.sh) скриптов было решено произвести одним объединяющим скриптом run_scripts: "sh ./install_ruby.sh && sh ./install_mongodb.sh && sh ./deploy.sh", чтобы обеспечить возможность контроля последовательности и мониторинг азавершения всех скриптов под одним Process ID, для дальнейшей передачи исполнения установки скрипту, тестирующему подключение. Этот скрипт под названием connect_script.sh (строка выше), при заранее заданном имени хоста reddit-app2 извлекал в локальную переменную публичный ip-адрес данного сервера, затем после ожидания длиной примерно в полторы минуты командой sleep (чтобы дождаться гарантированного завершения установки пакетов) с помощью удаленного выполнения команды "ps -aux | ..." извлекался номер порта с его присвоением другой локальной переменной, после чего само подключение тестировалось с помощью конструкции: "curl yc-user@$ipaddress:$portnumber". Также. чтобы найденный номер порта значением 9292 не был обнулен при выходе из подцикла, значение порта было автоматически вписано в файл foo.txt, откуда и было извлечено главным процессом скрипта connect_script
Дополнительный файл connect_script.sh приложен.

Файл metadata.yaml подхваченный скриптом startupserver.sh:
	#cloud-config
	disable_root: true
	timezone: Asia/Almaty
	repo_update: true
	repo_upgrade: true
	apt:
	  preserve_sources_list: true

	users:
	  - name: yc-user
		groups: sudo
		shell: /bin/bash
		sudo: ['ALL=(ALL) NOPASSWD:ALL']
		ssh-authorized-keys:
		  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDqZt4YB9y66fWf956T2+7g7ZuzVf/nSxa7pieoTMDOPt+MraABHNQwPPPqPGI+8uX6p0tLIEB+2Rq4vQNkpJx4m2gl/F+EfF+lM5rgCrQjFT9RsxhZqY7Jx5ECqHn356ASc19sdy0mNODaOcpefavB+JtynQQORZPTSEYCi97VgX2kBjVQZ6XrUc4jXwKJzWrcD2HJpygRiYzApWrsRCzoiBVbcNWGfbUZ8nEyQEvO45GaP71jqBmTfbGnoomsaJ8vqOJDgaTojDA/Z4GEJvNRp3CaldyVRPlMNUQSEI+BZAu5uxr0ZJFRpIVWFQqIe7MjXZPHz3wDYJJ8YcYrxtl9 appuser

	runcmd:
	  - cd /home/yc-user
	  - wget -q https://raw.githubusercontent.com/Otus-DevOps-2022-02/Yerlan-ops_infra/cloud-testapp/install_ruby.sh
	  - wget -q https://raw.githubusercontent.com/Otus-DevOps-2022-02/Yerlan-ops_infra/cloud-testapp/install_mongodb.sh
	  - wget -q https://raw.githubusercontent.com/Otus-DevOps-2022-02/Yerlan-ops_infra/cloud-testapp/deploy.sh
	  - wget -q https://raw.githubusercontent.com/Otus-DevOps-2022-02/Yerlan-ops_infra/cloud-testapp/run_scripts.sh
	  - sudo chmod +x install_ruby.sh
	  - sudo chmod +x install_mongodb.sh
	  - sudo chmod +x deploy.sh
	  - sudo chmod +x run_scripts.sh
	  - sh run_scripts.sh


Таким образом имеем следующую конфигурацию для тестирования на доступность:

Сервер, созданный при помощи автоматического скрипта:
Имя хоста: reddit-ip2
testapp_IP = 62.84.118.240
testapp_port = 9292
