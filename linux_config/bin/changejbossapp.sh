#!/bin/bash - 
#===============================================================================
#
#          FILE:  changejbossapp.sh
# 
#         USAGE:  ./changejbossapp.sh 
# 
#   DESCRIPTION:  修改jboss下的 jboss-service.xml 配置文件
#                 file:///home/wuzhong/workspace/kjava/galaxy/bundle/war/targe
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: YOUR NAME (), 
#       COMPANY: 
#       CREATED: 2011年01月19日 13时15分36秒 CST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

JBOSS_CONF=/home/admin/taobao_install/jboss-4.2.2.GA/server/default/conf/jboss-service.xml
echo $JBOSS_CONF
SEARCH_REG=file:\/\/\/home\/admin\/workspace.*\/bundle\/war\/target
#echo $SEARCH_REG
#echo $#
if [ $# -eq 0 ]
then
  echo "请输入应用的相对路径 如： wtm , kjava\\/wtm"
  exit 1
fi
#REPLACE_STR=file:\/\/\/home\/wuzhong\/workspace\/$1\/bundle\/war\/target
#echo $REPLACE_STR
#echo g/$SEARCH_REG/s/$SEARCH_REG/$REPLACE_STR/g
#
#grep $SEARCH_REG $JBOSS_CONF
ed -s $JBOSS_CONF << EOF
g/file:\/\/\/home\/admin\/workspace.*\/bundle\/war\/target/s/file:\/\/\/home\/admin\/workspace.*\/bundle\/war\/target/file:\/\/\/home\/admin\/workspace\/$1\/bundle\/war\/target/g
w
q
EOF

echo "current app is `grep $SEARCH_REG $JBOSS_CONF`"

