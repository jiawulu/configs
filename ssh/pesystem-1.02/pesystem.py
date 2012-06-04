#!/usr/bin/python2
# -*- coding: utf-8 -*-

import sys
import os
import logging
import getopt
import urllib2

real_py = os.path.realpath(sys.argv[0])
work_dir = os.path.dirname(real_py)
sys.path.append(os.path.join(work_dir, 'lib'))

from BeautifulSoup import BeautifulSoup, Comment, NavigableString
from BeautifulSoup import SoupStrainer
from tornado import template


def usage():
    print """\
pesystem.py version 1.02
Usage: pesystem.py [OPTION]... 
get pesystem info.
    
Mandatory arguments to long options are mandatory for short options too.
    -h, --help                      print this help.
    -n, --name=appname              the app name.
    -s, --state=state               the app group state.
    -t, --template=template         the generate template filename.
"""


if __name__ == '__main__':

    if len(sys.argv) < 2:
        usage()
        sys.exit(2)

    try:
        (opts, args) = getopt.gnu_getopt(sys.argv[1:], 'n:s:t:h', ['help'
                , 'state=', 'name=','template='])
    except getopt.GetoptError, err:

  # print help information and exit:

        print str(err)  # will print something like "option -a not recognized"
        usage()
        sys.exit(2)

    istate = None
    tpl = None
    for (o, a) in opts:
        if o == '-v':
            verbose = True
        elif o in ('-h', '--help'):
            usage()
            sys.exit()
        elif o in ('-n', '--name'):
            name = a
        elif o in ('-s', '--state'):
            istate = a
        elif o in ('-t', '--template'):
            loader = template.Loader(os.path.join(work_dir, 'template'))
            tpl = a
        else:
            assert False, 'unhandled option'

    if None == istate:
        istate = 'working_online'

    f = urllib2.urlopen('http://pesystem.taobao.net:9999/app/' + name)
    htmlstr = f.read()
    f.close()
    strainer = SoupStrainer('div', {'class': 'ks-switchable-content'})
    soup = BeautifulSoup(htmlstr, parseOnlyThese=strainer,
                         fromEncoding='utf-8')
    if len(soup.contents) == 0:
        print '''
The app name is not found!
'''
        usage()
        exit(1)
    host_div = soup('div')[0]('div')[0]
    prepub_div = host_div.parent('div')[5]
    host_div.extract()
    prepub_div.extract()

    soup = None

    trs = host_div.findAll('tr')

    group = None
    hostcount = 0
    hosts=[]
    print '\n'
    for tr in trs[1:]:
        (host, ip, group, site, state) = tr.findAll('td')

        host = host.a.string.strip()
        ip = ip.string.strip()
        group = group.string.strip()
        state = state.string.strip()

        if state == istate or 'all' == istate:
            hostcount = hostcount + 1
            hosts.append(host)
            if tpl is None:
                print '%-20sGROUP=%-20sTYPE=%-20s' % (host, group, state)

    if tpl is None:
        print '\nApp "%s" match host count: %d' % (name,hostcount)
        
    if tpl is None and len(prepub_div('tr')) > 1:
        print '''
<<<<<<<<<<<<<<<<<<<<<<<< PrePuber & Packer >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'''
        print '%-20sGROUP=%-20sTYPE=prepub' % (prepub_div('tr')[3]('td'
                )[2].string, group)
        print '%-20sGROUP=%-20sTYPE=pack' % (prepub_div('tr')[1]('td'
                )[0].string, group)
        
    if tpl is not None:
        print loader.load(tpl).generate(appname=name,hosts=hosts)
