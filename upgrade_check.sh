#!/bin/bash
#v0.5
# Script que verifica se ha atualizoes disponiveis para Ubuntu.
# Manda e-mail se houver.

export LC_ALL=en_US
export LANG=en_US

MAILTO=felypesantos@gmail.com
HOSTNAME=$(hostname -f)
SUBJECT="Atualizacao disponivel em $HOSTNAME"
MAILSERVER=mailserver.uninove.br

function manda_email {
(
echo "helo $HOSTNAME"
echo "Mail from:root@$HOSTNAME"
echo "rcpt to:$2"
echo "Data"
echo "Subject: $SUBJECT"
sleep 1
echo ""
sleep 1
echo "$1"
echo "."
echo "quit"
) | telnet $MAILSERVER 25
}


if [[ `/usr/bin/apt-get update 2>&1 | grep Get` ]]; then
	if [[ `/usr/bin/apt-get --simulate upgrade 2>&1 | grep Inst` ]]; then
		echo "Subject: $SUBJECT" >> /tmp/upgrade_check.tmp.$$
		/usr/bin/apt-get --simulate upgrade >> /tmp/upgrade_check.tmp.$$
		if [ -e /usr/sbin/sendmail ]; then
			/usr/sbin/sendmail -t felypesantos@gmail.com < /tmp/upgrade_check.tmp.$$
			/usr/sbin/sendmail -t email02@gmail.com < /tmp/upgrade_check.tmp.$$
		else
			MSG=$(cat /tmp/upgrade_check.tmp.$$)
			manda_email "${MSG}" "felypesantos@gmail.com"
			manda_email "${MSG}" "email02@gmail.com"
		fi
		rm -f /tmp/upgrade_check.tmp.$$
	fi
fi


