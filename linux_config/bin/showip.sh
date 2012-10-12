#!/bin/bash

ifconfig| grep "255.255.255." | awk '{print $2 }'

