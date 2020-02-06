#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- mode: python -*-

import sys
import os
import re
from subprocess import Popen, PIPE
import optparse
parser = optparse.OptionParser("A simple automatic screen configurator (using xrandr)")
parser.add_option('-c', '--connect', action="store_true",
                  dest='connect',
                  default=False,
                  help="configure every connected screens")
parser.add_option('-d', '--disconnect', action="store_true",
                  dest='disconnect',
                  default=False,
                  help="unconfigure every connected screens other than LVDS (laptop screen)")
parser.add_option('', '--main-display',
                  dest='maindisplay',
                  default="LVDS",
                  help="main display identifier (typically, the laptop LCD screen; defaults to LVDS)")

options, args = parser.parse_args()

if int(options.connect) + int(options.disconnect) > 1:
    print("ERROR: only one option -c or -d at a time")
    parser.print_help()
    sys.exit(1)


xrandr = Popen("xrandr", shell=True, bufsize=0, stdout=PIPE).stdout.read().decode('utf-8')

connected = re.findall(r'([a-zA-Z0-9-]*) connected', xrandr)
connected = [c for c in connected if c != options.maindisplay]

cmd = "xrandr --output %s %s"

if options.connect or options.disconnect:
    for c in connected:
        if options.connect:
            action = "--auto"
        elif options.disconnect:
            action = "--off"

        print(cmd%(c, action))
        #p = Popen(cmd % (c, action), shell=True)
        #sts = os.waitpid(p.pid, 0)
