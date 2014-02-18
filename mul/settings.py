import platform

url = "http://10.139.41.58:6004/EMA/EMA_PROXY"

if platform.system() == "Darwin":
    fabrice_mul_path = "/Users/deone/.virtualenvs/fabrice/fabrice/mul"
elif platform.system() == "Linux":
    fabrice_mul_path = "/home/pm_client/fabrice/mul"
elif platform.system() == "Windows":
    fabrice_mul_path = "C:/fabrice/mul"
    
commands = "%s/out/commands.out" % fabrice_mul_path
cl_file = "%s/out/cl.txt" % fabrice_mul_path
processed = "%s/out/processed.txt" % fabrice_mul_path
success = "%s/logs/success.log" % fabrice_mul_path
errors = "%s/logs/errors.log" % fabrice_mul_path

error_codes = {
    '17204': 'Temporary Blocked',
    '17105': 'Internal Server Error',
    '17103': 'Data out of bounds'
}
