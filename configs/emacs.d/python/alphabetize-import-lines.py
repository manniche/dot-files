#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- mode: python -*-
"""
Alphabetizes the import lines read from stdin and formats them before
printing them.

"""

def import_compare(x, y):
    "compare function for sorting import lists "
    if x[1] > y[1]:
        return 1
    elif x[1] == y[1]:
        return 0
    else: # x < y
        return -1
    
lines = []
newlines = []


import sys


from sets import Set

for line in sys.stdin:
    if line.strip()[0:6] == 'import':
        line_lst =  line.split()
        dom = line_lst[-1].split(".")[0]
        if len( line_lst ) == 3:
            lines.append( [ line_lst[0]+" "+line_lst[1], line_lst[2], dom ] )
        else:
            lines.append( [ line_lst[0], line_lst[1], dom ] )
        
lines.sort( import_compare );
    
print "\n"
last_line = lines[0]
print last_line[0]+" "+last_line[1]
for line in lines[1:]:
    if last_line != line:
        if line[-1] != last_line[-1]:
            print ""
        print line[0]+" "+line[1]
    last_line = line
print ""
