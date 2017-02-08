#!/usr/bin/python
#from importlib import import_module
from util.config import Config
from delegates.volumes import Volumes
from delegates.droplets import Droplets
import getopt
import sys

# instantiate config
conf = Config("config.yml")

# instantiate delegates passing in config.  Perhaps a better way to do this?
vol = Volumes(conf)
drop = Droplets(conf)

def setup():
    print "Using DigitalOcean Token: %s" % conf.getToken()
    print "Using DigitalOcean URL: %s" % conf.getURL()
    print "Entire deployment config: %s" % conf.getConfig()

class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "h", ["help"])

        except getopt.error, msg:
             raise Usage(msg)
        # more code, unchanged
    except Usage, err:
        print >>sys.stderr, err.msg
        print >>sys.stderr, "for help use --help"
        return 2
if __name__ == "__main__":
# This is the main driver...
    setup()

    droplets = drop.getDroplets()
    print "Found droplets: "
    for d in droplets['droplets']:
        print "%s\t%s\t%s\t%s\t%s\t%s" % (d['id'], d['name'], d['image']['distribution'], d['status'], d['size_slug'], d['tags'])

    minecraftDroplets = drop.getDropletByTag("minecraft")
    print "Found minecraft droplets: "
    for d in minecraftDroplets['droplets']:
        print "%s\t%s\t%s\t%s\t%s\t%s" % (d['id'], d['name'], d['image']['distribution'], d['status'], d['size_slug'], d['tags'])


    vols = vol.getVolumes()
    #print "Found volumes: %s" % vols
    for v in vols['volumes']:
        volume = vol.getVolumeByName(v['name'])
        print "Volume info for %s: %s" % (v['name'],volume)

    # create a droplet from the deployment configFile
    #{"name":"example.com","region":"nyc3","size":"512mb","image":"ubuntu-14-04-x64","ssh_keys":null,"backups":false,"ipv6":true,"user_data":null,"private_networking":null,"volumes": null,"tags":["web"]}'



# Done.
    sys.exit(main())
