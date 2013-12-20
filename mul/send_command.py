#!/bin/python
"""
Read commands.out line by line.
Construct xml request with line.
Send request to EMA URL.
Write request and response string <resultmessage> to file.
"""

import os
import urllib2
from bs4 import BeautifulSoup

url = "http://10.139.41.58:6004/EMA/EMA_PROXY"
commands = "/Users/deone/.virtualenvs/fabrice/fabrice/trow/out/commands.out"

def build_request(cmd):
    data = {}
    request = """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ema="http://schema.concierge.com/ema">
	<soapenv:Header/>
	<soapenv:Body>
	    <ema:processRequest>
		<!--Optional:-->
		<ema:EMA>
		    <ema:EMARequest>
			<ema:Request>%s</ema:Request>
		    </ema:EMARequest>
		    <ema:EMAResponse>
			<!--Optional:-->
			<ema:resultcode>?</ema:resultcode>
			<!--Optional:-->
			<ema:resultmessage>?</ema:resultmessage>
		    </ema:EMAResponse>
		</ema:EMA>
	    </ema:processRequest>
	</soapenv:Body>
    </soapenv:Envelope>
    """ % cmd
    data.update(string=cmd, xml=request)
    return data

def send_command(cmd_file):
    open_file = open(cmd_file, 'r')
    for line in open_file:
	data = build_request(line)
	request = urllib2.Request(url, data['xml'])
	response = urllib2.urlopen(request)
	soup = BeautifulSoup(response)

	print data['string']
	print soup.resultcode.string
	print soup.resultmessage.string

if __name__ == "__main__":
    send_command(commands)
