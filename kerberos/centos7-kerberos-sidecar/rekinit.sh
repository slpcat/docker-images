#!/bin/sh
#allow the period to be configurable, the default is 1 hour
[[ "$PERIOD_SECONDS" == "" ]] && PERIOD_SECONDS=3600
#allow for specific kinit options to be provided, but if not these are inferred based on provided keytab files
if [[ "$OPTIONS" == "" ]]; then

[[ -e /krb5/krb5.keytab ]] && OPTIONS="-k" && echo "*** using host keytab"
[[ -e /krb5/client.keytab ]] && OPTIONS="-k -i" && echo "*** using client keytab"

fi
#Warn if no default keytab is found
if [[ -z "$(ls -A /krb5)" ]]; then
echo "*** Warning default keytab (/krb5/krb5.keytab) or default client keytab (/krb5/client.keytab) not found"
fi
#The refresh logic
while true
do
# report to stdout the time the kinit was being run
echo "*** kinit at "+$(date -I)

# run kinit with passed options, note APPEND_OPTIONS allows for
# additional parameters to be configured. The verbose option is always set
kinit -V $OPTIONS $APPEND_OPTIONS

# report the valid tokens
klist -c /dev/shm/ccache

# sleep for the defined period, then repeat
echo "*** Waiting for $PERIOD_SECONDS seconds"
sleep $PERIOD_SECONDS
done

