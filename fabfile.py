from fabric.api import *

env.roledefs = {
    'concierge': ['concierge@10.139.41.10', 'concierge@10.139.41.11', 'concierge@10.139.41.12', 'concierge@10.139.41.13'],
    'lnp': ['lnpapp@10.139.41.14', 'lnpapp@10.139.41.15'],
    'middleware': ['conbs@10.139.41.20', 'conbs@10.139.41.21'],
    'abillity': ['abillityapp@10.139.41.16', 'abillityapp@10.139.41.17']
}
env.shell = '/bin/bash -c'

# Cron map for report schedule
script_cron_map = {
    'agentwise_port_in': '00 12 01 * *',
    'registration_KPI': '00 12 01 * *',
    'daily_port_in': '00 07 * * *',
    'daily_activation': '30 07 * * *',
    'daily_provisioning_rejection': '00 08 * * *',
    'offer_addition': '10 06 * * *',
    'offer_cancel': '00 06 * * *',
    'rating_rejection': '55 08 * * *',
    'rating_rejection_rectification': '55 08 * * *',
    'failed_sim_registrations': '55 08 * * *',
    'order_rejections_for_executed_provisioning_commands': '55 08 * * *',
    'total_uploaded_files': '55 08 * * *',
    'provisioning_rejection': '00 06 * * *',
    'concierge_performance': '00 04 * * *',
    'data_offer_rental': '00 12 02 * *',
    'offer_rental': '00 12 02 * *',
    'package_rental': '00 12 02 * *',
    'invoice': '00 12 07 * *',
    'toll_free_invoice': '05 03 05 * *',
    'toll_free_calls': '05 03 05 * *',
    'sms_queue': '10 * * * *'
}

def archive():
    # 1. Archive app.
    local("mkdir -p build/fabrice")
    local("mkdir -p build/fabrice/reports build/fabrice/log_processing")

    local("cp reports/reporter.sh reports/mail.cfg.txt reports/reports.cfg.sh build/fabrice/reports/")
    local("cp log_processing/mail_ftp_logs.sh log_processing/*.txt build/fabrice/log_processing/")

    with lcd("build/fabrice/reports"):
	local("mkdir out logs sql")

    with lcd("build/fabrice/reports/out"):
	local("mkdir emails files results")

    with lcd("build/fabrice/log_processing"):
	local("mkdir out logs")

    local("cp reports/sql/*.sql build/fabrice/reports/sql/")
    get('/home/pm_client/fabrice/log_processing/hour_file.txt', 'build/fabrice/log_processing/hour_file.txt')

    with lcd("build/"):
	local("zip -r fabrice fabrice")

def build_grep_string(job_list):
    grep_string = " | grep -v "
    return grep_string + grep_string.join(job_list)

def schedule(jobs):
    # Backup crontab with the exception of the jobs to be deployed
    job_list = ["'" + job + "'" for job in jobs.keys()]
    grep_string = build_grep_string(job_list)
    run("crontab -l%s > tmpcrontab" % grep_string)

    # Append script's cron job to the crontab backup
    for key, value in script_cron_map.iteritems():
	run("echo '%s sh fabrice/reports/reporter.sh fabrice/reports/sql/%s.sql >> fabrice/reports/logs/%s.log 2>&1' >> tmpcrontab" % (value, key, key))

    # Replace current crontab with backup
    run("crontab -r")
    run("crontab tmpcrontab")

    # Delete backup
    run("rm tmpcrontab")

@task
def test():
    # Test-run scripts
    local("echo 'Testing scripts locally...'")
    for script in script_cron_map.iterkeys():
	local("sh reports/reporter.sh reports/sql/%s.sql" % script)

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
	    put("build/fabrice.zip", "fabrice.zip")

	    # 3. Unzip archive/Deploy app.
	    local("echo 'Deploying scripts...'")
	    run("rm -r fabrice")
	    run("unzip fabrice.zip")
	    run("rm fabrice.zip")

	    # 4. Schedule cron jobs
	    local("echo 'Scheduling cron jobs...'")
	    schedule(script_cron_map)
	finally:
	    local("echo 'Cleaning up litter...'")
	    local("rm -rf build/fabrice*")
	    local("rm -rf build")

@task
@roles('concierge', 'lnp', 'abillity', 'middleware')
def checkspace():
    with hide('running'):
	run("df -kh /*app")
