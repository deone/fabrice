#!/bin/python
"""
1. Read line from commands.out.
2. Grab msisdn and old mul from line.
3. Construct UC xml request with MSISDN.
4. Send request to EMA URL and get response.
5. Grab usage counter from UC response.
6. Compute old mul - usage counter.
7. Set new mul to computed value.
8. Construct MUL xml request with new mul.
9. Send request to EMA URL.
10. Log request and response string.
"""

import os, urllib2, sys
from decimal import *
from bs4 import BeautifulSoup

url = "http://10.139.41.58:6004/EMA/EMA_PROXY"

# Create settings.py for these and extend for live environment django style. But how do we load settings_live.py?
commands = "/Users/deone/.virtualenvs/fabrice/fabrice/mul/out/commands.out"
log_file = "/Users/deone/.virtualenvs/fabrice/fabrice/mul/log/mul.log"

def build_uc_command(msisdn):
    return "GET:ACCOUNTINFORMATION:2:SubscriberNumber,%s;" % msisdn

def build_mul_command(old_command, value):
    parts = old_command.split(',')
    return "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" % (
	parts[0],
	parts[1],
	parts[2],
	parts[3],
	parts[4],
	parts[5],
	value,
	parts[7],
	parts[8],
	parts[9],
	parts[10],
	parts[11],
	parts[12],
	parts[13],
	parts[14],
	parts[15],
	parts[16],
	parts[17],
	parts[18][:-1]
    )

def build_request(command):
    xml = """
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
    """ % command
    request = urllib2.Request(url, xml)
    return request, command

def send_request(request):
    response = urllib2.urlopen(request)
    return BeautifulSoup(response).resultmessage.string

def main(cmd_file, deduct_counter=False):
    open_file = open(cmd_file, 'r')
    for line in open_file:
	msisdn, old_mul = get_msisdn_old_mul(line)
	
	if deduct_counter:
	    usage_counter = 0
	else:
	    usage_counter = get_usage_counter(msisdn)

	new_mul = compute_new_mul(old_mul, usage_counter)

	mul_command = build_mul_command(line, new_mul)

	request, request_command = build_request(mul_command)
	response = send_request(request)

	debug_info = (request_command, response)

	write_log(str(debug_info) + "\n")

def get_msisdn_old_mul(command):
    parts = command.split(',')
    msisdn = parts[1].split(':')[0]
    old_mul = parts[6]
    return [msisdn, old_mul]

def compute_new_mul(old_mul, usage_counter):
    getcontext().prec = 4
    new_mul = str(Decimal(old_mul) - Decimal(usage_counter))
    return new_mul

def get_usage_counter(msisdn):
    command = build_uc_command(msisdn)

    request, command = build_request(command)
    response = send_request(request)

    soup = BeautifulSoup(response)

    return soup.usagecountermonetaryvalue.string

def write_log(info):
    with open(log_file, 'a') as log:
	log.write(info)
    log.closed

if __name__ == "__main__":
    if len(sys.argv) == 1:
	main(commands)
    else:
	if sys.argv[1] == '--no-deduct':
	    main(commands, deduct_counter=True)
	else:
	    print('Unrecognized option. Please use --no-deduct')
