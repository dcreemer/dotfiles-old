#!/usr/bin/env python

import os
from subprocess import *

x = Popen( ['ps ax -o "ucomm,%cpu" | grep coreau | cut -d " " -f 10'], shell=True, stdout=PIPE).communicate()[0]
try:
    x=float(x.strip())
except ValueError:
    x = 0.0
if x > 1.0:
    p = Popen("/usr/local/bin/growlnotify -sd1 -m 'coreaudiod %%cpu=%0.2f' 'notice'" % x, shell=True)
    os.waitpid(p.pid, 0)[1]
