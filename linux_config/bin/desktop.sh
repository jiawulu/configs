#!/bin/bash
if [ -f /tmp/wn_status ]
then
   wnckprop --show-desktop;
   rm -rf /tmp/wn_status;
else
   wnckprop --unshow-desktop;
   touch /tmp/wn_status;
fi

