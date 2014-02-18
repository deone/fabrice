def get_response_code(response):
    """ Extract and return response code from `response` """
    code = response.split(':')[2][:-1]
    if code != '0':
	try:
	    code = code[4:]
	except:
	    raise("Unknown Error")
    return code

def is_valid(response):
    """ Return true if `response` is valid. Else return error code """
    code = get_response_code(response)
    if code == '0':
	return True
    return code

def strip_country_code(msisdn):
    """ Return msisdn without country code """
    return msisdn[3:]
