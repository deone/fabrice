def get_response_code(response):
    """ Extract and return response code from `response` """
    code = response.split(':')[2]
    return code

def is_valid(response):
    """ Return true if `response` is valid. Else return error code """
    code = get_response_code(response)
    if code.endswith(";"):
        code = code[:-1]
    if code == "0":
	return True
    return code

def strip_country_code(msisdn):
    """ Return msisdn without country code """
    return msisdn[3:]

def write_to_file(info, filename):
    """ Write `info` into file with given `filename` """
    with open(filename, 'a') as file_:
	file_.write(info + "\r\n")
    file_.closed
