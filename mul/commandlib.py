import urllib2
from bs4 import BeautifulSoup

from settings import url

def send_request(request):
  """ Send `request` to url (already a part of `request`) and get response """
  proxy = urllib2.ProxyHandler({'http': 'http://oosikoya:@@bind025%@10.135.15.176:8080'})
  auth = urllib2.HTTPBasicAuthHandler()
  opener = urllib2.build_opener(proxy, auth, urllib2.HTTPHandler)
  urllib2.install_opener(opener)

  response = urllib2.urlopen(request)
  return BeautifulSoup(response).resultmessage.string

def build_simple_command(msisdn, cmd_type):
  """ Build usage counter command with `msisdn` """
  if cmd_type == "mul":
    return "GET:AIRSUB:MSISDN,%s:MSISDNNAI,1:REQUESTEDOWNER,3;" % msisdn
  else:
    return "SET:GSMSUB:MSISDN,233%s:SERVICECLASS,71;" % msisdn

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
