#!/bin/bash

. ~/.bash_profile


#Script directory
SCRIPT_DIR="/tmp"

#Templates for mail
TEMPLATES_DIR="${SCRIPT_DIR}/templates"
TEMPLATE_HEADER="${TEMPLATES_DIR}/header.html"
TEMPLATE_FOOTER="${TEMPLATES_DIR}/footer.html"
TEMPLATE_INFO_DIRECT="${TEMPLATES_DIR}/info_direct.html"

#Boundary for the mail
MIXED_BOUNDARY="MULTIPART-MIXED-BOUNDARY"
ALTERNATIVE_BOUNDARY="MULTIPART-ALTERNATIVE-BOUNDARY"

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

if [ $# -ne 10 ]
then
	echo "Usage: emailing.sh mail_addresses server_ip user_name user_password asm_home oracle_home asm_password db_password db_sid service_name"
	exit 1
fi


MAIL_RECIPIENT=${1// /,}
SERVER_IPADDRESS=$2
user=$3
password=$4
asm_home=$5
db_home=$6
asm_password=$7
db_password=$8
db_sid=$9
service_name=$10

LOGFILE="/tmp/$db_sid.mail.log"

log "Mail recipient             : $MAIL_RECIPIENT"
log "Server IPaddress           : $SERVER_IPADDRESS"
log "User to Connect            : $user"
log "User/Password              : $password"
log "ASM HOME Path              : $asm_home"
log "ASM Instance Password      : $asm_password"
log "Oracle Database Home       : $db_home"
log "Database SID	          : $db_sid"
log "Database Instance Password : $db_password"
log "Service Name : $service_name"

temp_template="/tmp/mail.$db_sid.$RANDOM.html"
temp_templated="/tmp/mail.$db_sid.applied.$RANDOM.html"
temp_mail="/tmp/mail.$db_sid.$RANDOM.mail"
log "Temp template is $temp_template"
log "Temp template with value applied is $temp_templated"
log "Temp mail file is $temp_mail"

log "Generate template"

log "	Add Header to template"
cat $TEMPLATE_HEADER > $temp_template

log "	Add Info Direct (no nat) to template"
cat $TEMPLATE_INFO_DIRECT >> $temp_template

log "	Add Footer to template"
cat $TEMPLATE_FOOTER >> $temp_template

log "Replace <PLACEHOLDER> by values in the template"
log "	Replace <SERVICE>"
sed "s|<SERVICE>|${service_name}|g" $temp_template > $temp_templated
log "	Replace <USER>"
sed -i "s|<USER>|${user}|g" $temp_templated
log "	Replace <USER_PASSWORD>"
sed -i "s|<USER_PASSWORD>|${password}|g" $temp_templated
log "	Replace <IPADDRESS>"
sed -i "s|<IPADDRESS>|${SERVER_IPADDRESS}|g" $temp_templated
log "	Replace <ASM_PATH>"
sed -i "s|<ASM_PATH>|${asm_home}|g" $temp_templated
log "	Replace <AASM_PASSWORD>"
sed -i "s|<ASM_PASSWORD>|${asm_password}|g" $temp_templated
log "	Replace <DB_PATH>"
sed -i "s|<DB_PATH>|${db_home}|g" $temp_templated
log "	Replace <DB_SID>"
sed -i "s|<DB_SID>|${db_sid}|g" $temp_templated
log "	Replace <DB_PASSWORD>"
sed -i "s|<DB_PASSWORD>|${db_password}|g" $temp_templated

## Prepare the mail
MAIL_FROM='IBM Oracle Center - IBM Client Center MONTPELLIER <no-reply@ioc.fr.ibm.com>'
MAIL_SUBJECT="Deployment of Oracle Database ${db_sid} is done"
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

	echo "--MULTIPART-MIXED-BOUNDARY--" >> $temp_mail

	cat $temp_mail | /usr/sbin/sendmail $recipient

done
