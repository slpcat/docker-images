#!/bin/sh

export PATH=$PATH:/usr/local/rvm/rubies/ruby-1.9.3-p551/bin

# Prepare Database if it doesn't exist
export MYSQL_PWD=$DB_PASS
STATUS=`mysqlshow -u $DB_USER -h $DB_ADDRESS snorby`
if [[ $STATUS != "snorby" ]]; then
    mysql -u $DB_USER -h $DB_ADDRESS -e "CREATE DATABASE snorby"
    mysql -u $DB_USER -h $DB_ADDRESS -e "GRANT ALL ON snorby.* TO $DB_USER@'%' IDENTIFIED BY '$DB_PASS'"
    mysql -u $DB_USER -h $DB_ADDRESS -e "flush privileges"
    cd /usr/local/src/snorby
    bundle install
    sed -i 's/$DB_ADDRESS/'$DB_ADDRESS'/g' /usr/local/src/snorby/config/database.yml
    sed -i 's/$DB_USER/'$DB_USER'/g' /usr/local/src/snorby/config/database.yml
    sed -i 's/$DB_PASS/'$DB_PASS'/g' /usr/local/src/snorby/config/database.yml
    bundle exec rake snorby:setup
fi

# Download latest rules when provided with valid Oinkcode from snort.org
if [ $OINKCODE != "community" ]; then
    wget -O /tmp/rules.tar.gz https://www.snort.org/rules/snortrules-snapshot-29110.tar.gz?oinkcode=$OINKCODE
    rm -rf /etc/snort/rules
    mkdir -p /etc/snort/rules
    tar zxvf /tmp/rules.tar.gz -C /etc/snort/rules --strip-components=1
    rm -f /tmp/rules.tar.gz
fi

# User params
SNORBY_USER_PARAMS=$@
if [ -z "$SNORBY_USER_PARAMS" ]; then
    SNORBY_USER_PARAMS=" -e production"
fi

SNORBY_CONFIG=${SNORBY_CONFIG:="/usr/local/src/snorby/config/snorby_config.yml"}

# Internal params
SNORBY_CMD="bundle exec rails server ${SNORBY_USER_PARAMS}"

#######################################
# Echo/log function
# Arguments:
#   String: value to log
#######################################
log() {
  if [[ "$@" ]]; then echo "[`date +'%Y-%m-%d %T'`] $@";
  else echo; fi
}

# Launch Snorby
log $SNORBY_CMD
cd /usr/local/src/snorby && $SNORBY_CMD
# Exit immidiately in case of any errors or when we have interactive terminal
if [[ $? != 0 ]] || test -t 0; then exit $?; fi
log "Snorby started with $SNORBY_CONFIG config" && log
