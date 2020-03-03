#!/bin/sh

LATITUDE=0.0
LONGITUDE=0.0

source $HOME/.secrets/.geocoords

xflux -l $LATITUDE -g $LONGITUDE
