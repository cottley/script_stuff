This script will send an email if an oracle database instance session number has met or exceeded a prescribed limit.

Below are the options that the script accepts to execute.

<pre>
NAME:
  check_oracle_session.sh - Automatic Oracle Database Instance Session Checker v1.0

SYNOPSIS:
  check_oracle_session.sh [options]
  Run automated check for the number of sessions for a oracle database instance.
  The script will execute a notification once the number of sessions exceeds
  a specified limit.

OPTIONS:
  -h, --help
    Show this message
  -l, --limit integerlimit
    Specify the session limit you would like to use so that notifications go
    out when the number of sessions meet or exceed this number. E.g. -l 100
  -s, --smtpserver smtpserver
    Specify the smtp server to use when sending notifications
    E.g. -s mail.mycompany.com
  -f, --from fromemailaddress
    Specify the email address the email will appear to come from when there
    are notifications as a result of the limit being met or exceeded
    E.g. -f noreply@mycompany.com
  -t, --to toemailaddress
    Specify the email address to email when limit has been met or exeeded
    E.g. -t me@mycompany.com
  -v, --verbose
    Verbose output. Note: This will send an email even if the limit has not
    been met or exceeded
</pre>