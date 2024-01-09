#!/bin/sh

usermod -G b,uucp,lock -a  b
chmod a+rw /dev/ttyACM0
