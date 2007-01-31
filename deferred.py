#!/usr/bin/env python

# File: deferred.py
# Version: 0.3
# Description: a script for setting a XEP to Deferred
# Last Modified: 2006-11-01
# Author: Peter Saint-Andre (stpeter@jabber.org)
# License: public domain
# HowTo: ./deferred.py xepnum

# IMPORTS:
#
import glob
import os
from select import select
import smtplib
import socket
from string import split,strip,join,find
import sys
import time
from xml.dom.minidom import parse,parseString,Document

def getText(nodelist):
    thisText = ""
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            thisText = thisText + node.data
    return thisText

# get the seconds in the Unix era
now = int(time.time())

# READ IN ARGS: 
#
# 1. XEP number

xepnum = sys.argv[1];

xepfile = 'xep-' + xepnum + '.xml'

# PARSE XEP HEADERS:
#
# - title
# - abstract
# - version
# - date
# - initials
# - remark

thexep = parse(xepfile)
xepNode = (thexep.getElementsByTagName("xep")[0])
headerNode = (xepNode.getElementsByTagName("header")[0])
titleNode = (headerNode.getElementsByTagName("title")[0])
title = getText(titleNode.childNodes)
abstractNode = (headerNode.getElementsByTagName("abstract")[0])
abstract = getText(abstractNode.childNodes)
statusNode = (headerNode.getElementsByTagName("status")[0])
xepstatus = getText(statusNode.childNodes)
typeNode = (headerNode.getElementsByTagName("type")[0])
xeptype = getText(typeNode.childNodes)
revNode = (headerNode.getElementsByTagName("revision")[0])
versionNode = (revNode.getElementsByTagName("version")[0])
version = getText(versionNode.childNodes)
dateNode = (revNode.getElementsByTagName("date")[0])
date = getText(dateNode.childNodes)
initialsNode = (revNode.getElementsByTagName("initials")[0])
initials = getText(initialsNode.childNodes)
remarkNode = (revNode.getElementsByTagName("remark")[0])
remark = getText(remarkNode.childNodes)

# SEND MAIL:
#
# From: editor@xmpp.org
# To: standards@xmpp.org
# Subject: DEFERRED: XEP-$xepnum ($title)
# Body:
#    XEP-$xepnum ($title) has been Deferred because of inactivity.
#
#    Abstract: $abstract
#
#    URL: http://www.xmpp.org/extensions/xep-$xepnum.html
#
#    If and when a new revision of this XEP is published,
#    its status will be changed back to Experimental.
#

fromaddr = "editor@xmpp.org"
# for testing...
# toaddrs = "stpeter@jabber.org"
# for real...
toaddrs = "standards@xmpp.org"

thesubject = 'DEFERRED: XEP-' + xepnum + " (" + title + ")"
introline = 'XEP-' + xepnum + ' (' + title + ') has been Deferred because of inactivity.'
abstractline = 'Abstract: ' + abstract
urlline = 'URL: http://www.xmpp.org/extensions/xep-' + xepnum + '.html'
endline = 'If and when a new revision of this XEP is published, its status will be changed back to Experimental.'

#msg = "From: %s\r\n" % fromaddr
msg = "From: XMPP Extensions Editor <%s>\r\n" % fromaddr
msg = msg + "To: %s\r\n" % toaddrs
msg = msg + "Subject: %s\r\n" % thesubject
msg = msg + introline
msg = msg + "\r\n\n"
msg = msg + abstractline
msg = msg + "\r\n\n"
msg = msg + urlline
msg = msg + "\r\n\n"
msg = msg + endline
msg = msg + "\r\n"

#server = smtplib.SMTP('localhost')
#server.set_debuglevel(1)
#server.sendmail(fromaddr, toaddrs, msg)
#server.quit()

# END

