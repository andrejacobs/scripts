#!/bin/bash
# Monitor CPU temperature and take action if needed
# André Jacobs 14/05/2014
# note: running on cron every minute, * * * * * /..../cputempmon.sh

EMAIL=user@somewhere.com
WARN_TEMP=70
CRIT_TEMP=90

warn_flag=false
crit_flag=false

for line in `sensors | grep -oP "Core\s+\d:\s+\+?(\K\d+)"`; do
    if [ ${line} -ge ${WARN_TEMP} ]; then
        warn_flag=true
    fi

    if [ ${line} -ge ${CRIT_TEMP} ]; then
        crit_flag=true
    fi
done

if [ "${crit_flag}" = true ]; then
    /bin/echo "CRITICAL: CPU temperature >= ${CRIT_TEMP}" | /usr/bin/mail -s "[Server] CRITICAL CPU Temperature!" ${EMAIL}
    sleep 10
    /sbin/shutdown -h now
    exit
fi

if [ "${warn_flag}" = true ]; then
    /bin/echo "WARNING: CPU temperature >= ${WARN_TEMP}" | /usr/bin/mail -s "[Server] WARNING CPU Temperature" ${EMAIL}
fi
