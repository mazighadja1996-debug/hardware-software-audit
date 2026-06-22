#!/bin/bash

ssmtp_conf_fun(){
	echo "please enter your email"
	read email_sender
	echo " the default security protocl is TLS if you are using SSL plese enter 1"
	read prt
	if [ "$prt" == "1" ]; then
	       port="465"
	       lline="userSTARTSSL=yes"
        else
		port="587"
		lline="userSTARTTLS=yes"
	fi
	echo "please enter your passeword"
	read -s password


	echo -e "root=$email_sender\nmailhub=smtp.gmail.com:$port\nAuthUser=$email_sender\nAuthPass=$password\n$lline">/etc/ssmtp/ssmtp.conf
}

write_email_fun(){
	if [ -f ~/full_report.pdf ]; then
		file=full_report.pdf
	else
		file=partial_report.pdf
	fi

	echo "please enter the receiver's gmail"
	read receiver
	echo "please enter the sender's gmail"
	read sender
	echo -e "To:$receiver\nFrom:$sender\nCc:$receiver\nSubject:the report\n$(cat $file)" > email.sh

echo -e "before sending the email please turn on the option of letting less secure apps contact you so that you' ll be able to receive the email\nplease press any key once you have done the settings"
while [ true ]
do
read answer -t 3 -n 1
if [ #? != 0 ]; then 
	ssmpt_conf_fun()
	write_email_fun()
else
	echo "please configure the settings"
fi
