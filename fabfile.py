from fabric.api import *

env.roledefs = {
    'concierge': ['concierge@10.139.41.10', 'concierge@10.139.41.11', 'concierge@10.139.41.12', 'concierge@10.139.41.13'],
    'lnp': ['lnpapp@10.139.41.14', 'lnpapp@10.139.41.15'],
    'middleware': ['conbs@10.139.41.20', 'conbs@10.139.41.21']
}
env.shell = '/bin/bash -c'

test_recipients="osikoya.oladayo@tecnotree.com"
test_cc="alwaysdeone@gmail.com"

live_recipients="rjmalm@mtn.com.gh;dtenartey@mtn.com.gh;soakoto@mtn.com.gh;msali@mtn.com.gh;titani@mtn.com.gh;jkbam@mtn.com.gh;abfaisal@mtn.com.gh;dannan@mtn.com.gh;sannan@mtn.com.gh;doseiboateng@mtn.com.gh"
live_cc="jegadeesan.velusamy@tecnotree.com;osikoya.oladayo@tecnotree.com;adetimilehin.hammed@tecnotree.com;Chandra.Mohan@tecnotree.com"

@hosts('pm_client@10.139.41.18')
def deploy():
    # 1. Archive app.
    local("mkdir -p fabrice/reports")
    local("cp reports/data_offer_rental.sh reports/invoice.sh reports/reports.cfg.sh fabrice/reports/")

    with lcd("fabrice/reports"):
	local("mkdir out logs")

    with lcd("fabrice/reports/out"):
	local("mkdir emails files results")

    local("zip -r fabrice fabrice")

    try:
	# 2. Copy archive over to host.
	put("fabrice.zip", "fabrice.zip")

	# 3. Unzip archive/Deploy app.
	run("rm -r fabrice")
	run("unzip fabrice.zip")
	run("rm fabrice.zip")

	# Backup crontab with the exception of the jobs to be deployed
	run("crontab -l | grep -v 'data_offer_rental.sh' | grep -v 'invoice.sh' > tmpcrontab")

	# Append script's cron job to the crontab backup
	run("echo '00 12 02 * * sh fabrice/reports/data_offer_rental.sh >> fabrice/reports/logs/data_offer_rental.log 2>&1' >> tmpcrontab")
	run("echo '00 12 07 * * sh fabrice/reports/invoice.sh >> fabrice/reports/logs/invoice.log 2>&1' >> tmpcrontab")

	# Replace current crontab with backup
	run("crontab -r")
	run("crontab tmpcrontab")

	# Delete backup
	run("rm tmpcrontab")

	# 4. Test app - Write test recipients and cc to config and change to production recipients and cc if test passes.
	# Write test recipients and cc to config
	run("echo 'recipients=\"%s\"' >> fabrice/reports/reports.cfg.sh" % test_recipients)
	run("echo 'cc=\"%s\"' >> fabrice/reports/reports.cfg.sh" % test_cc)

	# Test-run scripts
	run("sh fabrice/reports/data_offer_rental.sh")
	run("sh fabrice/reports/invoice.sh")

	# Remove test recipients and cc from config
	run("grep -v '%s' fabrice/reports/reports.cfg.sh | grep -v '%s' >> reports.cfg.sh.backup" % (test_recipients, test_cc))
	run("cp reports.cfg.sh.backup fabrice/reports/reports.cfg.sh")
	run("rm reports.cfg.sh.backup")

	# Write live recipients and cc to config
	run("echo 'recipients=\"%s\"' >> fabrice/reports/reports.cfg.sh" % live_recipients)
	run("echo 'cc=\"%s\"' >> fabrice/reports/reports.cfg.sh" % live_cc)
    finally:
	local("rm -rf fabrice*")

@roles('concierge', 'lnp', 'middleware')
def checkspace():
    with hide('running'):
	run("df -kh /*app")
