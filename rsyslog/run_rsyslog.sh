#!/bin/sh

echo "Running ulimit setter at $(date '+%d/%m/%Y %H:%M:%S')"
ulimit -n 4096
echo "Ulimit is now $(ulimit -n)"
echo "Completed ulimit setting $(date '+%d/%m/%Y %H:%M:%S')."
# Also need to create directories in the persistent volume
mkdir -p /persist/log /persist/position
# Fix ownership of /persist subdirs for compatibility with old sensors
if [ -e /persist/__persistent__ ]; then
    chown `stat -c '%u:%g' /persist/__persistent__` /persist/log /persist/position
fi
# Also, disable port 6514 if no certs are set up
rm -f /run/rsyslog-tls.conf
if grep '^-----BEGIN RSA PRIVATE KEY-----' /extras/key.pem >/dev/null 2>&1; then
    ln -s /etc/rsyslog-tls.conf /run/rsyslog-tls.conf
fi
# Exec hack
exec rsyslogd -n 
