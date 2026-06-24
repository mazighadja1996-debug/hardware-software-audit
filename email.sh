#!/bin/bash

yellow='\033[1;32m'
red='\033[1;31m'
cyan='\033[1;36m'
yellow='\033[1;33m'

ssmtp_conf_fun(){
    read -p "the default security protocol is TLS if you are using SSL please enter 1" prt
    if [ "$prt" == "1" ]; then
           port="465"
           Usestarttls="NO"
    else
        port="587"
        Use_starttls="YES"
    fi
    echo "please enter your password"
    read -s password

  echo -e "root=$sender\nmailhub=ssmtp.gmail:$port\nAuthUser=$sender\nAuthPass=$password\nUserSTARTTLS=$use_starttls\nUseTLS=YES"  > /tmp/ssmtp.conf

    sudo mv /tmp/ssmtp.conf /etc/ssmtp/ssmtp.conf
}

write_email_fun(){
    read -p "${yellow}please select whihc report you wish to send" file
    if [ ! -f file ]; then
      echo "${red}the file does not exist"
      exit 1
    fi
  
    read -p "${cyan}please enter the receiver's gmail" receiver
    read -p "${cyan}please enter the sender's gmail" sender
    
    echo -e "\n${yellow}Important: Please use a Google 'App Password' instead of your regular password."
    read -n 1 -s -p -r "Press any key once you have configured your settings...  "
    
    ssmtp_conf_fun
    
    echo "Full Report of the device" | mailx /
    -r "$sender" /
    -s "report about the user's device" /
    -a "$file" /
    $receiver
    
    if [ $? -eq 0 ]; then
        echo "${green}Email sent successfully!"
    else
        echo "${red}Failed to send email. Please check your configuration."
    fi
}
