#!/usr/bin/env python

import urllib2
from bs4 import BeautifulSoup

from util import write_to_file

line_file = "data/failure.txt"
url = "http://10.139.41.58:7003/MTN_GHANA_PROXY"
numbers = "data/numbers.txt"

def build_request(line):
    """ Get line and return xml with values from line. """
    values = line.split('|')

    xml = """
        <REQUEST EXTERNAL_USER="%s" EXTERNAL_APPLICATION="%s" CLIENT_ID="MTNG" ENTITY_ID="%s" SERVICE_CODE="GSM" INFO_LEVEL="%s" EXTERNAL_SYSTEMS_LOG_REFERNCE="%s" API_CODE="7869" OPERATION_NAME="updateSubscriber"/>
        <REQUESTDETAILS FIRST_NAME="%s" LAST_NAME="%s" DATE_OF_BIRTH="%s" DOCUMENTID_TYPE="%s" DOCUMENTID_NUMBER="%s" SIM_NUMBER="" NATIONALITY="GHANA" AGENT_ID="%s" AGENT_NAME="%s"/>
        <ADDRESS>
        <PHYSICAL_ADDRESS ADDRESS_TYPE="%s" ADDRESS1="%s" ADDRESS2="%s" ADDRESS3="%s" ADDRESS4="%s" ADDRESS5="%s" STREET="%s" CITY="%s" DISTRICT="%s" POBOX="%s" COUNTRY="%s"/>
        </ADDRESS>
    """ % (values[0], values[0], values[1], values[11], values[7], values[8], values[9], values[4], values[6], values[5], values[3], values[2], values[17], values[12], values[13], values[14], values[15], values[16], values[22], values[18], values[20], values[21], values[19])

    return xml, values[1]

def send_command(tup):
    xml = """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:com="http://schema.concierge.com">
    <soapenv:Header/>
    <soapenv:Body>
    <com:clientRequest>
    <EaiEnvelope xmlns="http://schema.concierge.com/Envelope" xmlns:ser="http://schema.concierge.com/Services">
    <ApplicationName>MTNG</ApplicationName>
    <Domain>abl_portal</Domain>
    <Service>Services</Service>
    <Language>En</Language>
    <UserId>externalapp</UserId>
    <Sender>externalapp</Sender>
    <MessageId>abl_portal</MessageId>
    <Payload>
    <ser:Services>
    <ser:Request>
    <ser:Operation_Name>abillityReferenceApi</ser:Operation_Name>
    <ser:ChangeServicesRequest>
    <ser:request>
    <EVENT xmlns="">
    %s
    </EVENT>
    </ser:request>
    </ser:ChangeServicesRequest>
    </ser:Request>
    </ser:Services>
    </Payload>
    </EaiEnvelope>
    </com:clientRequest>
    </soapenv:Body>
    </soapenv:Envelope>
    """ % tup[0]
    request = urllib2.Request(url, xml)
    response = urllib2.urlopen(request)

    return tup[1]

if __name__ == "__main__":
    lines = open(line_file, 'r')
    for line in lines:
        tup = build_request(line)
        msisdn = send_command(tup)
        write_to_file(msisdn, numbers)
