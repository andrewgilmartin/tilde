#!/bin/bash

shopt -s nullglob

function log() {
	echo $(date +'%Y-%m-%d %H:%M:%S') $@
}

ROOT=$(cd $(dirname $0); pwd)

U=$(id -u -n)
if [ $U != "qs" -a $U != "crossref" -a $U != "tomcat" ]
then
	log WARN "script intended for use by system users"
	sleep 10
fi

BACKUP=$(mktemp -d /tmp/$(basename $0 .sh)-$(date +'%Y-%m-%d-%H-%M-%S')-XXXXXX)

function install() {
	if [ -e $2 ]
	then
		log INFO "move $2 to $BACKUP"
		mv $2 $BACKUP
	fi
	log INFO "copy $1 to $2"
	cp -p $1 $2
}

log INFO "installing dot files"
for F in $ROOT/dot-files/*
do
	install $F $HOME/.$(basename $F)
done

log INFO "installing script files"
mkdir -p $HOME/bin
for F in $ROOT/script-files/*
do
	install $F $HOME/bin/$(basename $F)
	chmod a+x $HOME/bin/$(basename $F)
done

log INFO "installing bin files"
mkdir -p $HOME/bin
for F in $ROOT/bin-$(uname -s)-files/*
do
	install $F $HOME/bin/$(basename $F)
	chmod a+x $HOME/bin/$(basename $F)
done

log INFO "done"

# END
