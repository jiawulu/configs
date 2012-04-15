#!/bin/bash

ifconfig| grep "255.255.255.0" | awk '{print $2 }' | awk -F: '{print $2}'

