import os 

url = "http://10.139.41.58:6004/EMA/EMA_PROXY"

fabrice_path = os.environ.get('FABRICE_PATH')

if fabrice_path:
    fabrice_mul_path = "%s/mul" % fabrice_path
else:
    raise Exception("FABRICE_PATH not set")

commands = "%s/out/commands.out" % fabrice_mul_path
cl_file = "%s/out/cl.txt" % fabrice_mul_path
processed = "%s/out/processed.txt" % fabrice_mul_path
success = "%s/logs/success.log" % fabrice_mul_path
errors = "%s/logs/errors.log" % fabrice_mul_path

error_codes = {
    '17204': 'Temporarily Blocked',
    '17105': 'Internal Server Error',
    '17103': 'Data out of bounds',
    '17232': 'Subscriber not found'
}
