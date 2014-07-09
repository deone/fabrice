#!/usr/bin/env python

from commandlib import *

# number_file = "/Users/deone/Downloads/ACS.txt"
command_file = "/Users/deone/Documents/Work/delete.txt"

def main(command_file):
  try:
    open_file = open(command_file, 'r')
  except Exception:
    sys.exit(str(sys.exc_info()[1]))
  else:
    for line in open_file:
      # msisdn = line[:-2]
      # command = build_simple_command(msisdn, "set_service")
      request = build_request(line[:-1])
      response = send_request(request)
      print response


if __name__ == "__main__":
  main(command_file)
