from fabric.api import run, cd, env, roles, hide, task

env.roledefs = {
    'concierge': ['concierge@10.139.41.10', 'concierge@10.139.41.11', 'concierge@10.139.41.12', 'concierge@10.139.41.13'],
    'lnp': ['lnpapp@10.139.41.14', 'lnpapp@10.139.41.15'],
    'middleware': ['conbs@10.139.41.20', 'conbs@10.139.41.21']
}
env.shell = '/bin/bash -c'

def deploy(directory="fab"):
    run("mkdir %s" % directory)
    with cd(directory):
	run("touch app.wsgi")

@roles('concierge', 'lnp', 'middleware')
def checkspace():
    with hide('running'):
	run("df -kh /*app")
