#!/bin/bash

# Usage: execute.sh [WildFly mode] [configuration file]
#
# The default mode is 'standalone' and default configuration is based on the
# mode. It can be 'standalone.xml' or 'domain.xml'.

JBOSS_CLI=$JBOSS_HOME/bin/jboss-cli.sh
BATCH_FILE=$1
JBOSS_MODE=${2:-"domain"}
JBOSS_CONFIG=${3:-"$JBOSS_MODE.xml"}

if [ "$JBOSS_MODE" = "domain" ]; then
    MASTER_HOST=`grep 'host name="MASTER_HOST_NAME"' $JBOSS_HOME/domain/configuration/host.xml`
    if [ "x$MASTER_HOST" = "x" ]; then
	export MASTER=$MASTER_HOST_NAME
    else
        export MASTER="MASTER_HOST_NAME"
    fi
fi

if [ "x$BATCH_FILE" = "x" ]; then
    echo "You need to inform the batch file to execute"
    exit 1
fi

function wait_for_server() {
    if [ "$JBOSS_MODE" = "standalone" ]; then
            until `$JBOSS_CLI -c "ls /deployment" &> /dev/null`; do
                    sleep 1
            done
    else
            until `$JBOSS_CLI -c "/host=$MASTER:read-attribute(name=host-state)" 2> /dev/null | grep -q running`; do
                    sleep 1
            done
    fi
}

echo "=> Starting JBOSS server with $JBOSS_CONFIG"
$JBOSS_HOME/bin/$JBOSS_MODE.sh -c $JBOSS_CONFIG > /dev/null &

echo "=> Waiting for the server to boot"
wait_for_server

echo "=> Executing the commands"
$JBOSS_CLI -c --file=$BATCH_FILE

echo "=> Shutting down JBOSS"
if [ "$JBOSS_MODE" = "standalone" ]; then
    $JBOSS_CLI -c ":shutdown"
else
    $JBOSS_CLI -c "/host=$MASTER:shutdown"
fi
