import urllib2

from settings import url

def build_uc_command(msisdn):
    """ Build usage counter command with `msisdn` """
    return "GET:AIRSUB:MSISDN,%s:MSISDNNAI,1:REQUESTEDOWNER,3;" % msisdn

def build_mul_command(old_command, value):
    """ Build mul command with `old_command` and `value` """
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
    """ Build a request with `command` """
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
    return request
