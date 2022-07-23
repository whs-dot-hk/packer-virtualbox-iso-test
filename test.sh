#!/bin/sh

mkdir -p /target/home/whs/.ssh/
printf '%b' "$(echo $PACKER_AUTHORIZED_KEY | tr '+' ' ' | sed -e 's/%/\\x/g')" > /target/home/whs/.ssh/authorized_keys
