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

An example invocation that is checking if the session limit has met or exceeded 50 sessions, using the SMTP server mail.mycompany.com, with the email coming from noreply@mycompany.com and the email being sent to me@mycompany.com:
<pre>
./check_oracle_session.sh -l 50 -s mail.mycompany.com -f noreply@mycompany.com -t me@mycompany.com
</pre>

This script assumes that the oracle environment has been setup so that you can use sqlplus at a command prompt and connect as the system DBA.

In my environment, I also have a seperate oracle.bash file that I source to set the ORACLE_SID, the TNS_ADMIN home etc. You may or may not have a similar configuration, however whatever steps you need to get sqlplus working at a command prompt, that's what you need to do to test sqlplus.

<pre>
[oracle@mydatabase ~]$ sqlplus / as sysdba

SQL*Plus: Release 12.1.0.2.0 Production on Tue Oct 2 10:52:36 2018

Copyright (c) 1982, 2014, Oracle.  All rights reserved.


Connected to:
Oracle Database 12c Enterprise Edition Release 12.1.0.2.0 - 64bit Production
With the Partitioning, OLAP, Advanced Analytics and Real Application Testing options

SQL>
</pre>
