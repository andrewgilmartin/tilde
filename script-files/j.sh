#!/bin/bash

JAVA=java
JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true"
WEBAPP_DIR=web
VERBOSE=false

if [ ! -z "$CLASSPATH" ]
then
    echo "WARNING: overriding existing CLASSPATH so as to enforce a consistent execution environment."
fi
CLASSPATH="."

LOOP=true
while $LOOP ; do
    if [ -z "$1" -o "$1" == "--help" ] ; then
        echo "usage: $(basename $0) [--verbose] [--debug port] [--memory value] [--webapp path] [--classpath jar|directory|glob] [java-options] class-name [class-options]"
        exit 1
    elif [ "$1" == "--verbose" ] ; then
        VERBOSE=true
        shift 1
    elif [ "$1" == "--webapp" ] ; then
        WEBAPP_DIR=$2
        shift 2
    elif [ "$1" == "--memory" ] ; then
        JAVA_OPTS="$JAVA_OPTS -Xmx$2"
        shift 2
    elif [ "$1" == "--classpath" ] ; then
        if [ -d "$2" ]
        then
            CLASSPATH="$CLASSPATH:$2"
            for CP in $(find "$2" -name \*.jar -type f)
            do
                CLASSPATH="$CLASSPATH:$CP"
            done
        else
            for CP in $(echo "$2")
            do
                CLASSPATH="$CLASSPATH:$CP"
            done
        fi
        shift 2
    elif [ "$1" == "--java" ] ; then
        JAVA=$2
        shift 2
    elif [ "$1" == "--debug" ] ; then
        JAVA_OPTS="$JAVA_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,address=$2,server=y,suspend=y"
        shift 2
    else
        LOOP=false
    fi
done

if [ ! -d $WEBAPP_DIR ]
then
    echo "error: webapp directory \"$WEBAPP_DIR\" does not exist"
    exit 1
fi

CLASSPATH="${CLASSPATH}${CLASSPATH:+:}$WEBAPP_DIR/WEB-INF/deployments:$WEBAPP_DIR/WEB-INF/classes:$WEBAPP_DIR/WEB-INF/contexts:$(echo $WEBAPP_DIR/WEB-INF/lib/*.jar|tr ' ' ':'):$WEBAPP_DIR"

if $VERBOSE ; then
    set -x
    java -version
fi

$JAVA $JAVA_OPTS -classpath "$CLASSPATH" "$@"

# END
