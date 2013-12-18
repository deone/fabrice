from fabric.api import *

env.roledefs = {
    'concierge': ['concierge@10.139.41.10', 'concierge@10.139.41.11', 'concierge@10.139.41.12', 'concierge@10.139.41.13'],
    'lnp': ['lnpapp@10.139.41.14', 'lnpapp@10.139.41.15'],
    'middleware': ['conbs@10.139.41.20', 'conbs@10.139.41.21']
}
env.shell = '/bin/bash -c'

scripts = [
    'data_offer_rental.sh',
    'invoice.sh',
    'offer_rental.sh',
    'package_rental.sh',
    'toll_free_invoice.sh'
]

def archive():
    # 1. Archive app.
    local("mkdir -p fabrice/reports")
    local("cp reports/*.sh fabrice/reports/")

    with lcd("fabrice/reports"):
	local("mkdir out logs")

    with lcd("fabrice/reports/out"):
	local("mkdir emails files results")

    local("zip -r fabrice fabrice")

def build_grep_string(job_list):
    grep_string = " | grep -v "
    return grep_string + grep_string.join(job_list)

def schedule(job_list):
    # Backup crontab with the exception of the jobs to be deployed
    job_list = ["'" + job + "'" for job in job_list]
    grep_string = build_grep_string(job_list)
    run("crontab -l%s > tmpcrontab" % grep_string)

    # Map script to schedule time
    cron_map = {
	'data_offer_rental': '00 12 02 * *',
	'offer_rental': '00 12 02 * *',
	'package_rental': '00 12 02 * *',
	'invoice': '00 12 07 * *',
	'toll_free_invoice': '05 03 05 * *'
    }

    # Append script's cron job to the crontab backup
    for key, value in cron_map.iteritems():
	run("echo '%s sh fabrice/reports/%s.sh >> fabrice/reports/logs/%s.log 2>&1' >> tmpcrontab" % (value, key, key))

    # Replace current crontab with backup
    run("crontab -r")
    run("crontab tmpcrontab")

    # Delete backup
    run("rm tmpcrontab")

@task
def test():
    # Test-run scripts
    for script in scripts:
	local("sh reports/%s" % script)

@task
@hosts('pm_client@10.139.41.18')
def deploy():
    with hide('running'):
	# 1. Archive
	local("echo 'Packaging...'")
	archive()
	try:
	    # 2. Copy archive over to host.
	    local("echo 'Copying script archive to host...'")
	    put("fabrice.zip", "fabrice.zip")

	    # 3. Unzip archive/Deploy app.
	    local("echo 'Deploying scripts...'")
	    run("rm -r fabrice")
	    run("unzip fabrice.zip")
	    run("rm fabrice.zip")

	    # 4. Schedule cron jobs
	    local("echo 'Scheduling cron jobs...'")
	    schedule(scripts)
	finally:
	    local("echo 'Cleaning up litter...'")
	    local("rm -rf fabrice*")

@task
@roles('concierge', 'lnp', 'middleware')
def checkspace():
    with hide('running'):
	run("df -kh /*app")
