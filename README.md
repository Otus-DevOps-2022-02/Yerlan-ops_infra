# Yerlan-ops_infra
Yerlan-ops Infra repository
# Подключение к внутреннему хосту можно выполнить одной командой:
# ssh -J appuser@<Jump Host's Public IPv4 address> appuser@<Internal host's private IPv4 address>

#Чтобы подключиться к внутреннему узлу командой ssh someinternalhost,
#были произведены следующие изменения в ~/.ssh/config файле:
GSSAPIAuthentication no
Host bastion
   HostName <Jump Host's Public IPv4 address>
   User appuser
   IdentityFile ~/.ssh/appuser

Host someinternalhost
   HostName <Internal host's private IPv4 address>
   User appuser
   ProxyJump appuser@<Jump Host's Public IPv4 address>
