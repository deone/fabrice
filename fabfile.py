from fabric.api import *

env.roledefs = {
    'concierge': ['concierge@10.139.41.10', 'concierge@10.139.41.11', 'concierge@10.139.41.12', 'concierge@10.139.41.13'],
    'lnp': ['lnpapp@10.139.41.14', 'lnpapp@10.139.41.15'],
    'middleware': ['conbs@10.139.41.20', 'conbs@10.139.41.21']
}
env.shell = '/bin/bash -c'

@hosts('pm_client@10.139.41.18')
def deploy():
    # Local
    # =====
    local("mkdir -p fabrice/reports")
    local("cp reports/data_offer_rental.sh reports/reports.cfg.sh fabrice/reports/")

    with lcd("fabrice/reports"):
	local("mkdir include out logs")

    local("cp reports/include/queries.sh fabrice/reports/include/")

    with lcd("fabrice/reports/out"):
	local("mkdir emails files results")

    local("zip -r fabrice fabrice")

    # Remote
    # ======
    # Copy app archive to host, unzip and delete archive
    try:
	put("fabrice.zip", "fabrice.zip")
	run("unzip fabrice.zip")
	run("rm fabrice.zip")

	# Backup crontab with the exception of the job containing the script name
	run("crontab -l | grep -v 'data_offer_rental.sh' > tmpcrontab")

	# Append script's cron job to the crontab backup
	run("echo '00 12 02 * * sh fabrice/reports/data_offer_rental.sh >> fabrice/reports/logs/data_offer_rental.log 2>&1' >> tmpcrontab")

	# Replace current crontab with backup
	run("crontab -r")
	run("crontab tmpcrontab")

	# Delete backup
	run("rm tmpcrontab")
    finally:
	# Local
	# =====
	local("rm -rf fabrice*")

@roles('concierge', 'lnp', 'middleware')
def checkspace():
    with hide('running'):
	run("df -kh /*app")
