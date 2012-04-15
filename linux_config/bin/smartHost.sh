#!/bin/bash

curl   "https://smarthosts.googlecode.com/svn/trunk/hosts" | tr -d '\r' | awk '{if($2 != "google.com" && $2 != "" && $1 !~ "#" && $2 !~ "dropbox") print "address=/"$2"/"$1}'
