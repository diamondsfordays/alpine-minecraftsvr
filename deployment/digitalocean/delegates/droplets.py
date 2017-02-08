#!/usr/bin/python
from util.config import Config

import json
import requests
import getopt
import os
import sys


class Droplets(object):

    def __init__(self,config):
        self.conf = config

    def getDroplets(self):
        url = self.conf.getURL()+"droplets"
        response = requests.get(url, headers=self.conf.getHeaders())
        return response.json()

    def getDropletByTag(self,tag):
        url = self.conf.getURL()+"droplets?tag_name="+tag
        response = requests.get(url, headers=self.conf.getHeaders())
        return response.json()

    def createDroplet(self,dropletRequest):
        #"https://api.digitalocean.com/v2/droplets"
        url = self.conf.getURL()+"droplets"
        response = requests.post(url, headers=self.conf.getHeaders())
        data = response.json()
