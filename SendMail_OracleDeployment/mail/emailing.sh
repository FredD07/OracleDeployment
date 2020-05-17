#!/bin/bash

. ~/.bash_profile


#Directory where the OVPN certificates are stored
VPNCERT_DIR="/openvpn/vpn"

#Script directory
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

#Templates for mail
TEMPLATES_DIR="${SCRIPT_DIR}/templates"
TEMPLATE_HEADER="${TEMPLATES_DIR}/header.html"
TEMPLATE_FOOTER="${TEMPLATES_DIR}/footer.html"
TEMPLATE_INFO_DIRECT="${TEMPLATES_DIR}/info_direct.html"
TEMPLATE_INFO_NAT="${TEMPLATES_DIR}/info_nat.html"
TEMPLATE_CONNECTION_NAT="${TEMPLATES_DIR}/connection_nat.html"
TEMPLATE_CONNECTION_OPENVPN="${TEMPLATES_DIR}/connection_openvpn.html"

#Mapping files
IP_NAT_MAPPINGS="${SCRIPT_DIR}/NAT_MAPPINGS"
DATABASE_LABELS="${SCRIPT_DIR}/DATABASE_LABELS"


#Boundary for the mail
MIXED_BOUNDARY="MULTIPART-MIXED-BOUNDARY"
ALTERNATIVE_BOUNDARY="MULTIPART-ALTERNATIVE-BOUNDARY"

#MAIL_HTML_OPENVPN_TEMPLATE="/home/GBS-Digital-Platform/email.openvpn.html"
#MAIL_HTML_NAT_TEMPLATE="/home/GBS-Digital-Platform/email.nat.html"

function log() {
	d=$(date  +"%Y-%m-%d %H:%M:%S")
	echo "$d : $@"
	echo "$d : $@" >> $LOGFILE
}

function addFile {
	# add an image to data.txt : 
	# $1 : file path
	# $2 : is inline (1 yes, 0 no)

	declare FILENAME=$(basename $1)
	declare FILE_B64ENCODED=$(cat $1 | base64)
	declare FILE_MIMETYPE=$(file -b --mime-type $1)
	
	echo "--$MIXED_BOUNDARY" >> $temp_mail
	echo "Content-Type: $FILE_MIMETYPE"  >> $temp_mail
	echo "Content-Transfer-Encoding: base64"  >> $temp_mail
	if [[ $2 == 1 ]]
	then
		echo "Content-Disposition: inline"  >> $temp_mail
		echo "Content-Id: <$FILENAME>"  >> $temp_mail
	else
		echo "Content-Disposition: attachment; filename=$FILENAME"  >> $temp_mail
	fi
	echo "$FILE_B64ENCODED

">> $temp_mail
}

if [ $# -ne 5 ]
then
	echo "Usage: emailing.sh mail_addresses server_ip service_name HANA_backup natted_or_not"
	exit 1
fi


MAIL_RECIPIENT=${1// /,}
SERVER_IPADDRESS=$2
service=$3
service=$(echo ${service%-01*})

VPNCERT_PROJECT_DIR=$VPNCERT_DIR/$service
NATTED=$5


hanabackup=$(cat $DATABASE_LABELS | grep ^$4 | cut -d: -f2)
if [[ $hanabackup == "" ]]
then
	hanabackup=$4
fi

NATIPaddress=$(cat $IP_NAT_MAPPINGS | grep $SERVER_IPADDRESS | cut -d: -f2)
if [[ $NATIPaddress == "" ]]
then
	NATIPaddress=$SERVER_IPADDRESS
fi

LOGFILE="/var/log/gdp/mail/$service.mail.log"

log "Mail recipient    : $MAIL_RECIPIENT"
log "Server IPaddress  : $SERVER_IPADDRESS"
log "NAT IPaddress     : $NATIPaddress"
log "Service           : $service"
log "HANA backup       : $hanabackup"
log "Natted            : $NATTED"

temp_template="/tmp/mail.$service.$RANDOM.html"
temp_templated="/tmp/mail.$service.applied.$RANDOM.html"
temp_mail="/tmp/mail.$service.$RANDOM.mail"
log "Temp template is $temp_template"
log "Temp template with value applied is $temp_templated"
log "Temp mail file is $temp_mail"

ADD_OPENVPN_CERT=1
if [ -d "$VPNCERT_PROJECT_DIR" ]
then
	log "Project has OpenVPN certificates"
	log "    VPN certificates directory : $VPNCERT_PROJECT_DIR"
else
	log "Project doesn't have OpenVPN certificates"
	log "    No VPN certificates found in $VPNCERT_PROJECT_DIR"
	ADD_OPENVPN_CERT=0
fi

log "Generate template"

log "	Add Header to template"
cat $TEMPLATE_HEADER > $temp_template

if [[ $NATTED == "yes" ]]
then
	log "	Add Info Nat to template"
	cat $TEMPLATE_INFO_NAT >> $temp_template
	
	log "	Add Connection Nat to template"
	cat $TEMPLATE_CONNECTION_NAT >> $temp_template
else
	log "	Add Info Direct (no nat) to template"
	cat $TEMPLATE_INFO_DIRECT >> $temp_template
fi

if [[ $ADD_OPENVPN_CERT == 1 ]]
then
	log "	Add Connection OpenVPN to template"
	cat $TEMPLATE_CONNECTION_OPENVPN >> $temp_template
fi



log "	Add Footer to template"
cat $TEMPLATE_FOOTER >> $temp_template

log "Replace <PLACEHOLDER> by values in the template"
log "	Replace <SERVICE>"
sed "s|<SERVICE>|${service}|g" $temp_template > $temp_templated
log "	Replace <HANABACKUP>"
sed -i "s|<HANABACKUP>|${hanabackup}|g" $temp_templated
log "	Replace <IPADDRESS>"
sed -i "s|<IPADDRESS>|${SERVER_IPADDRESS}|g" $temp_templated
log "	Replace <NATIPADDRESS>"
sed -i "s|<NATIPADDRESS>|${NATIPaddress}|g" $temp_templated


## Prepare the mail
MAIL_FROM='GBS-Digital-Platform <no-reply@gdppowervc.gbs.mop.fr>'
MAIL_SUBJECT="Deployment of Service ${service} is done"
#addFile oracle-rac.jpg 1
addFile $TEMPLATES_DIR/new_banner.png 1

for recipient in ${MAIL_RECIPIENT//,/ }
do
	log "Send to $recipient"
	TEMPLATE_BASE64=$(cat $temp_templated | base64)
	#echo $TEMPLATE_BASE64
	echo "From: $MAIL_FROM
To: $recipient
Subject: $MAIL_SUBJECT
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=\"MULTIPART-MIXED-BOUNDARY\"

--MULTIPART-MIXED-BOUNDARY
Content-Type: multipart/alternative; boundary=\"MULTIPART-ALTERNATIVE-BOUNDARY\"

--MULTIPART-ALTERNATIVE-BOUNDARY
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: base64
Content-Disposition: inline

$TEMPLATE_BASE64

--MULTIPART-ALTERNATIVE-BOUNDARY--" > $temp_mail
	addFile $TEMPLATES_DIR/new_banner.png 1
	#addFile oracle-rac.jpg 1
	#addFile oracle-rac.jpg 1
	if [[ $ADD_OPENVPN_CERT == 1 ]]
	then
		for i in $(ls $VPNCERT_PROJECT_DIR/*.zip)
		do
			addFile $i 0
		done
	fi

	echo "--MULTIPART-MIXED-BOUNDARY--" >> $temp_mail

	cat $temp_mail | /usr/sbin/sendmail $recipient

done
