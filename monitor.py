import urllib2
import subprocess

from bs4 import BeautifulSoup

from commandlib import *

def ping():
    command = "GET:HLRSUB:MSISDN,233542751610"
    request = build_request(command)
    response = send_request(request)

    return response

def notify():
    response = ping()
    if not response.startswith("Enter command: RESP:0"):
        subprocess.call('mutt -s "EMA Status: DOWN" -- alwaysdeone@gmail.com < message.txt', shell=True)

def send_request(request):
    """ Send `request` to url (already a part of `request`) and get response """
    auth()
    response = urllib2.urlopen(request)

    return BeautifulSoup(response).resultmessage.string

if __name__ == "__main__":
    notify()
