#!/bin/sh

# Script by Christopher Ottley

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -uo nounset

VER=1.0

## Changelog
# 1.0 Initial release

BANNER="Automatic Oracle Database Instance Session Checker v$VER"
SCOBANNER="For Oracle 12"
LIMIT=10
SMTPSERVER=
FROMADDRESS=
TOADDRESS=

function print_header() {
    echo
    echo "$*"
    echo "-------------------"
}

function send_message() {
  local message=$1
  if [[ ${SCOOPT_VERBOSE} ]]; then  
    echo $message | mailx -S smtp=$SMTPSERVER -r $FROMADDRESS -s "$message" -v $TOADDRESS
  else
    echo $message | mailx -S smtp=$SMTPSERVER -r $FROMADDRESS -s "$message" $TOADDRESS  
  fi
}

function do_check() {
  COUNTOFSESSIONS=`sqlplus -silent / as sysdba <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF  
select value from v\\$sysmetric where METRIC_ID=2143;
exit;
EOF`;
  if [ -z "$SMTPSERVER" ]; then
    usage
  else
    if [ -z "$FROMADDRESS" ]; then
	  usage
	else
	  if [ -z "$TOADDRESS" ]; then
	    usage
	  else
	    COUNTOFSESSIONS_NO_WHITESPACE="$(echo -e "${COUNTOFSESSIONS}" | tr -d '[:space:]')"
		echo $(date --iso-8601=seconds) Limit is: $LIMIT and No. Of Sessions is: $COUNTOFSESSIONS_NO_WHITESPACE >> /var/log/check_oracle_session.log
        if [ $COUNTOFSESSIONS -ge $LIMIT ]; then
          send_message "Warning! At or over limit of $LIMIT, there are $COUNTOFSESSIONS_NO_WHITESPACE active sessions."
        else
		  if [[ ${SCOOPT_VERBOSE} ]]; then 
	        send_message "All is fine. Limit is $LIMIT and there are $COUNTOFSESSIONS_NO_WHITESPACE active sessions."
		  fi
        fi
		
	  fi
	fi
  fi


}

function usage() {
    SCRIPTNAME=$(basename "${BASH_SOURCE[0]}")
    echo "$(tput bold)NAME:$(tput sgr0)"
    echo "  ${SCRIPTNAME} - ${BANNER}"
    echo
    echo "$(tput bold)SYNOPSIS:$(tput sgr0)"
    echo "  ${SCRIPTNAME} [options]"
	echo "  Run automated check for the number of sessions for a oracle database instance."
	echo "  The script will execute a notification once the number of sessions exceeds"
	echo "  a specified limit. "
    echo
    echo "$(tput bold)OPTIONS:$(tput sgr0)"
    echo "  -h, --help"
    echo "    Show this message"
	echo "  -l, --limit $(tput smul)integerlimit$(tput sgr0)"
	echo "    Specify the session limit you would like to use so that notifications go"
	echo "    out when the number of sessions meet or exceed this number. E.g. -l 100"
	echo "  -s, --smtpserver $(tput smul)smtpserver$(tput sgr0)"
	echo "    Specify the smtp server to use when sending notifications"
	echo "    E.g. -s mail.mycompany.com"
	echo "  -f, --from $(tput smul)fromemailaddress$(tput sgr0)"
	echo "    Specify the email address the email will appear to come from when there"
	echo "    are notifications as a result of the limit being met or exceeded"
	echo "    E.g. -f noreply@mycompany.com"
	echo "  -t, --to $(tput smul)toemailaddress$(tput sgr0)"
	echo "    Specify the email address to email when limit has been met or exeeded"
	echo "    E.g. -t me@mycompany.com"
	echo "  -v, --verbose"
	echo "    Verbose output. Note: This will send an email even if the limit has not"
	echo "    been met or exceeded"
    echo
    exit 1
}

export SCOOPT_USAGE=
export SCOOPT_LIMIT=
export SCOOPT_SMTPSERVER=
export SCOOPT_FROMADDRESS=
export SCOOPT_TOADDRESS=
export SCOOPT_VERBOSE=
if [[ $# -gt 0 ]]; then
    for param in "$@"
	do
	  if [[ ${SCOOPT_LIMIT} ]]; then
	     LIMIT=$param
		 export SCOOPT_LIMIT=
	  fi
	  if [[ ${SCOOPT_SMTPSERVER} ]]; then
	  	  SMTPSERVER=$param
		  export SCOOPT_SMTPSERVER=
	  fi
	  if [[ ${SCOOPT_FROMADDRESS} ]]; then
	  	  FROMADDRESS=$param
		  export SCOOPT_FROMADDRESS=
	  fi
	  if [[ ${SCOOPT_TOADDRESS} ]]; then
	  	  TOADDRESS=$param
		  export SCOOPT_TOADDRESS=
	  fi
      KEY=$param
      case ${KEY} in
        -h|--help)
            SCOOPT_USAGE=true
			break;
            ;;
        -l|--limit)
            SCOOPT_LIMIT=true
            ;;
        -s|--smtpserver)
            SCOOPT_SMTPSERVER=true
            ;;			
        -f|--from)
            SCOOPT_FROMADDRESS=true
            ;;
        -t|--to)
            SCOOPT_TOADDRESS=true
            ;;
        -v|--verbose)
            SCOOPT_VERBOSE=true
            ;;
		esac
	done
fi

if [[ ${SCOOPT_USAGE} ]]; then
    usage
else
  if [[ ${SCOOPT_VERBOSE} ]]; then 
    echo
    echo "${BANNER}"
    echo
	echo "${SCOBANNER}"
	echo
  fi
  
  do_check
  
  if [[ ${SCOOPT_VERBOSE} ]]; then 
    echo
  fi
  
fi
