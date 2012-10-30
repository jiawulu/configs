#!/bin/bash

end_date=`date --date='+1 day' +%Y-%m-%d`
from_date=`date --date='-7 day' +%Y-%m-%d`

echo "svn updats between $from_date : $end_date"

echo "useage:"
echo "svn log http://svn.app.taobao.net/repos/wdetail/trunk/wdetail --revision {$from_date}:{$end_date} "

svn log http://svn.app.taobao.net/repos/wdetail/trunk/wdetail --revision {$from_date}:{$end_date} -q | awk '{print $3}' > svnlog

sort svnlog | uniq

rm -rf svnlog
