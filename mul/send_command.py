#!/usr/bin/env python

"""
1. Read line from commands.out.
2. Grab msisdn and old mul from line.
3. Construct UC xml request with MSISDN.
4. Send request to EMA URL and get response.
5. Grab usage counter from UC response.
6. Compute old mul - usage counter.
7. Set new mul to computed value.
8. Construct MUL xml request with new mul.
9. Write invalid MSISDNs (without MUL value) to file.
10. Send commands to EMA.
11. Log request and response strings.
"""

import os, sys
from decimal import *
from bs4 import BeautifulSoup

from settings import *
from commandlib import *
from util import *


def send_request(request):
  """ Send `request` to url (already a part of `request`) and get response """
  response = urllib2.urlopen(request)
  return BeautifulSoup(response).resultmessage.string

def get_msisdn_old_mul(command):
  """ If we can't find mul value in `command`, write msisdn to file and print message on console. Else, return msisdn and mul value """
  parts = command.split(',')
  msisdn = parts[1].split(':')[0]
  old_mul = parts[6]
  if old_mul:
    return [msisdn, old_mul]
  write_to_file("'" + strip_country_code(msisdn) + "',", cl_file)
  print "No MUL value for %s. MSISDN written to file." % strip_country_code(msisdn)

def compute_new_mul(old_mul, usage_counter):
  """ Deduct `usage_counter` from `old_mul`. Return 0 if result is negative """
  val = Decimal(old_mul) - Decimal(usage_counter)
  new_mul = val.quantize(Decimal('.01'), rounding=ROUND_UP)
  if new_mul < 0:
    new_mul = 0
  return str(new_mul)

def get_usage_details(msisdn):
  """ Get values of usage counter and usage threshold for `msisdn` """
  command = build_uc_command(msisdn)
  request = build_request(command)
  response = send_request(request)

  soup = BeautifulSoup(response)

  result_set = soup.find_all('usagecounterusagethresholdinfo')

  if not result_set:
    raise Exception(command, response)

  for r in result_set:
    if r.usagecounterid.string == '2':
      counter = r.usagecountermonetaryvalue.string

  result = {
    'counter': counter,
    'threshold': soup.usagethresholdmonetaryvalue.string
  }

  return result

def main(cmd_file, deduct_counter=False):
  try:
    open_file = open(cmd_file, 'r')
  except Exception:
    sys.exit("Exiting...Commands file not found")
  else:
    for line in open_file:
      try:
        try:
          msisdn, old_mul = get_msisdn_old_mul(line)
        except TypeError:
          continue

        if deduct_counter:
          usage_details = get_usage_details(msisdn)
          usage_counter = usage_details['counter']
          new_mul = compute_new_mul(old_mul, usage_counter)
          mul_command = build_mul_command(line, new_mul)
        else:
          mul_command = line[:-1]

        request = build_request(mul_command)
        response = send_request(request)

        debug_info = (mul_command, response)

        result = is_valid(response)

        if result is True:
          write_to_file(str(debug_info), success)

          record = "'" + strip_country_code(msisdn) + "',"
          write_to_file(record, processed)
        else:
          write_to_file(str(debug_info) + " " + error_codes[result], errors)

      except:
        write_to_file(str(sys.exc_info()[1]), errors)
        continue
    os.remove(cmd_file)


if __name__ == "__main__":
  if len(sys.argv) == 1:
    main(commands)
  else:
    if sys.argv[1] == '--deduct':
      main(commands, deduct_counter=True)
    else:
      print('Unrecognized option. Please use --deduct')
