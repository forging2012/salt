#!/usr/bin/python
import commands
def diskusage():
  grains={}
  grains['diskusage'] = commands.getoutput('df -hT')
  return grains
