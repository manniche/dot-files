#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- mode: python -*-

import sys
import re
import datetime
import time
#import heapq
import bisect
import os.path
sys.path.append( os.path.join( os.getenv( 'HOME' ), 'local', 'lib', 'python' ) )
import finder
import sys
import logging
from ConfigParser import ConfigParser
from logging import *

# known bugs: the index for searching is never cleaned up

getLogger().setLevel( ERROR )
#getLogger().setLevel(WARNING)
#getLogger().setLevel(INFO)

class holder:
    def hold(self, stmt):
        self.var = stmt
        return self.var

def this_year():
    return 2008

def today_as_ordinal():
    """return this day as ordinal"""
    return datetime.date(*time.localtime()[0:3]).toordinal()

def base_ordinal():
    d = datetime.date(1970,1,1)
    return d.toordinal()

def sanity_check():
    past = 1236861140 # not long time ago
    future = past + 60*60*24*365*10 # ten years later
    now = time.time()
    if past > now or future < now:
        error("there is something wrong with the time, check the computers date settings")
    assert( past < now )
    assert( future > now )

# priorities

# there are 3 kinds of priorities

# 1) prio: user given priorities, these range from 0-9 (default is 9)

# 2) intermediate priorities: equal to the user given priority unless
# date is reached, the intermediate prio is then min(prio, 1 +
# prio/10) range is: 0-1.9

# 3) realprio, the prio used for sorting the tasks, it is calculated
# as 10^6 * intermediate prio + the date (converted to days since
# 1970-1-1) if the task is closed, multiply by 10.


# class configuration:
#     """simple container to set and hold configuration values"""
#     def __init__(self):
#         self.d = dict()
#         #        d["filter"] = undef
#     def __getitem__(self, key):
#         return self.d[key]
#     def __setitem__(self, key, value):
#         self.d[key] = value
#         return value

# config = configuration()
# config["show_tasks"] = "20"
# config["top_dir"] = os.path.join( os.getenv( 'HOME' ), "task-projekt" )
# config["task_dir"] = config["top_dir"] + "tasks/"
# config["trash_dir"] = config["top_dir"] + "thrash/"
# config["closed_dir"] = config["top_dir"] + "closed/"
# config["task_no_file"] = config["top_dir"] + "+taskno"
# config["editor"] = "semacs"

config = ConfigParser()
config.add_section( 'default' )
config.set( 'default', 'show_tasks', '20' )
config.set( 'default', 'top_dir', os.path.join( os.getenv("HOME"), "task-projekt" ) )
config.set( 'default', 'task_dir', os.path.join( config.get( 'default', 'top_dir' ), 'tasks' ) )
config.set( 'default', 'thrash_dir', os.path.join( config.get( 'default', 'top_dir' ), 'thrash' ) )
config.set( 'default', 'closed_dir', os.path.join( config.get( 'default', 'top_dir' ), 'closed' ) )
config.set( 'default', 'task_no_file', os.path.join( config.get( 'default', 'top_dir' ), '+taskno' ) )
config.set( 'default', 'editor', os.getenv( 'EDITOR' ) )

for directory in config.options( 'default' ):
    if directory.endswith( '_dir' ):
        if not os.path.exists( config.get( 'default', directory ) ):
            raise IOError, "%s does not exist, please create it before running task.py"%( config.get( 'default', directory ) )

    
class task:
    """task represents a task

    it can read in a task and construct data
    updates are done by editing the source and updating/recreating the object
    """
    def __init__(self, filename_):
        self.filename = filename_
        # defaults
#        self.date = datetime.date(this_year(), 1, 1) #default
        self.date = None
        self.prio = 9 # prio written in task (or 9 if omitted or invalid)
        self.realprio = 90; # sortprio
        self.subj = "[no subject]"
        self.open = True # True = open, False = close        
        self.rtime = self.mtime() # modification time of file when object created
        self.tags = dict()
        self.read_header()
        self.init_realprio()

    def __cmp__(self, other):
        return self.realprio.__cmp__(other.realprio)

    def __hash__(self):
        return hash( self.filename )

    def mtime(self):
        """get the files mtime"""
        return os.path.getmtime(self.filename)
        
# 6 /home/pink/task-projekt/tasks/02ad: [9] tegnekursus til efteråret -- check AOF etc.[2009-08-08]9014464 AOF foto -- tegnekursus til efteråret etc. check
    def string_debug(self):
        s = str()
        s+= self.filename + ": [" + str(self.prio) + "] " + self.subj + "[" + str(self.date) + "]" + str(self.realprio)
        return s

# [s] =tag backup af cbo til koncept [6-3-2009]
    def string_old(self):
        s = str()
        s+= "[" + str(self.prio) + "] " + self.subj + " [" + str(self.date) + "]"
        return s

    def string(self):
        #        return "[%s] %s [%s]" % (self.prio, self.subj, self.date)
        subj = self.subj
        if not self.open:
            subj = '-' + subj
        # return "%-40s [%s]" % (subj, self.date)
        return "%-40s [%s, %s]" % (subj, self.date, self.realprio)
    
    def init_stat(self,s):
        stat_s = re.compile(r'^(c)')
        stat_s_m = stat_s.search(s)
        if (stat_s_m):
            self.open = False
            debug("stat: False")

    def init_date(self, s):
        # set date from string
        date_s = re.compile(r'^(\d{1,2})-(\d{1,2})-(\d{4})')
        date_s_m = date_s.search(s)
        if (date_s_m):
            (d, m, y) = [int(s) for s in date_s_m.groups()] 
            if y > (this_year() + 10): y = this_year
            m = min(m, 12)
            d = min(d, 31)
            try: self.date = datetime.date(y, m, d)
            except ValueError: pass
        debug(self.date)
        
    def init_subj(self, s):
        self.subj = s
        self.add_tags(s)

    def init_prio(self, s):
        # accept priorities from 0-9, everything else corresponds to 9
        prio_re = re.compile(r'^\s*(\d)')
        prio_m = prio_re.search(s)
        if (prio_m):
            self.prio = int(prio_m.group(0))
        else:
            warning( "not a valid prio: %s", s)
        debug("prio is %s", self.prio)
                
    def init_realprio(self):
        # set real priority for sorting
        base = self.prio
        day = 999999 # highest possible day
        if self.date:
            day = self.date.toordinal() - base_ordinal() # days since 1970-1-1
            if (self.date <= datetime.date.today()):
                info("date reached, change prio")
                reprio = 1 + self.prio / 10.0
                debug("reprio: %s", reprio)
                base = min(self.prio, reprio)
        debug("day: %s", day)
        debug("base:", base)
        self.realprio = int((1000000 * (base + 1) ) + day);
        if not self.open:
            self.realprio = self.realprio * 10
        debug("realprio: %s", self.realprio)

    def add_tags(self, s):
        """read s as string with tags sep. by space, add tags to tags dict"""
        for tag in s.split():
            self.tags[tag] = 1

    def tag_str(self):
        return " ".join(self.tags.keys())
            
    def read_header(self):
        if not os.path.isfile(self.filename):
            self.open = False
            warning("no-such-file: %s", self.filename)
            return            
        f = open(self.filename)
        empty_line = re.compile(r'^\s+$')
        header_line = re.compile(r'^(\w+):\s*(.*)\s*$')
        for line in f:
            debug("matching: %s", line)
            h = holder()
            if empty_line.search(line):
                debug("empty line, break")
                break
            elif h.hold(header_line.search(line)):
                # hvad hvis content er tomt??
                (name, content) = h.var.groups()
                debug("name: >%s< content: >%s<", name, content)
                if name == "date": self.init_date(content)
                elif name == "prio": self.init_prio(content)
                elif name == "stat": self.init_stat(content)
                elif name == "subj": self.init_subj(content)
                elif name == "tags": self.add_tags(content)
            else:
                warning("no match")
import bisect
class sorted_dict:
    """sorted collection with insert and remove

    exisitng entries are overwritten at insert.
    """
    def __init__( self ):
        self.list = list() # sorted list
        self.dict = dict() # key -> positions in list
    def insert( self, obj ):
#        info("sd:insert: " + obj )
#        info("sd:insert:hash %s" % hash(obj) )
        if self.dict.has_key( obj ):
            self.remove( obj )
        pos = bisect.bisect( self.list, obj )
        self.list.insert( pos, obj )
        self.dict[obj] = pos
    def remove( self, obj ):
 #       info("sd:remove: " + obj )
        pos = self.dict[obj]
        self.list.pop( pos )
        self.dict.pop( obj )


class sorted_dict2:
    """sorted collection with insert and remove

    simple: sort only when needed
    """
    def __init__( self ):
        self.dict = dict() # key -> prio
    def insert( self, obj, prio ):
        self.dict[obj] = prio
        #        t = type( self.dict[obj] )
        #        info("type is %s" % t)
    def sorted(self):
        # sorted(d.iteritems(), key=itemgetter(1), reverse=True)
        info("return sorted")
        return sorted(self.dict.keys(), key=self.dict.get)

class sorted_list:
    """sorted collection with insert

    exisitng entries are overwritten at insert.
    """
    def __init__( self ):
        self.list = list() # sorted list
    def cmp(self, a, b):
        return a.realprio.__cmp__(b.realprio)
    def insert( self, obj ):
        self.list.append( obj )
        self.list.sort(self.cmp)

class task_cache:
    """task_cache to hold already read tasks and a toc for searching

    this is a simple cache:

    * it will return in-memory task objects if they exists

    * it will create a new in-memory object if the file has been
      changed or is not in the cache

    * it contains a searchable index

    """
    # tag højde for at der skal genprioriteres når der er gået en dag
    def __init__(self):
        self.cache = dict()
        self.index = finder.rtrie() # search index
#        self.sorted_tasks = sorted_dict() # sorted list of all tasks (filenames)
        self.sorted_tasks = sorted_dict2() # sorted list of all tasks (filenames)
        self.toc = [] # list of short task number -> filename
        self.tasks_to_show = 19
        self.last_prio_day = today_as_ordinal() 
        self.filter = ''

    def reprio(self):
        """we need to generate new priorities on a new day"""
        today = today_as_ordinal()
        info("reprio: last update: %s today is: %s" % (self.last_prio_day, today))
        if self.last_prio_day < today:
            info("reprio: new day, reprio all tasks")
            self.last_prio_day = today
            # self.sorted_tasks.list = list()
            for task in self.cache.itervalues():
                task.init_realprio() # update realprio
                # self.sorted_tasks.insert(task.filename) # re-insert task
                self.sorted_tasks.insert( task.filename, task.realprio ) # re-insert task

    def insert(self, filename):
        info("insert:" + filename)
        t = task(filename)
        self.cache[filename] = t
        # put task into trie by tags
        for tag in t.tags.keys():
            self.index.insert_term(tag, filename)
        # put into sorted_tasks
        if t.open:
            # self.sorted_tasks.insert( t.filename )
            self.sorted_tasks.insert( t.filename, t.realprio )
        return t
    
##     def get(self, filename):
##         """ fetch task from cache, reread if necessary

##         TODO: what if the file has been removed?
##         """
##         debug("get: " + filename)
##         if filename in self.cache:
##             t = self.cache[filename]
##             if t.mtime() == t.rtime:
##                 debug("using cache for: %s", filename)
##                 return t
##         return self.insert(filename)

##     def find(self, tag):
##         """wrapper to find on index"""
##         return self.index.find_term(tag)

##     def update(self):
##         """update cache and sorted list

##         it will actually check all files in the taskdir
##         """
##         info("update cache")
##         task_dir = config["task_dir"]
##         for line in os.listdir( task_dir ):
##             tilde_re = re.compile(r'~$')
##             m = tilde_re.search(line)
##             if not m:
##                 filename = task_dir+line
##                 t = self.get(filename)
##         self.reprio()
            

    def get(self, filename):
        """ fetch task from cache, reread if necessary

        TODO: what if the file has been removed?
        """
        debug("get: " + filename)
        if filename in self.cache:
            t = self.cache[filename]
            if t.mtime() == t.rtime:
                debug("using cache for: %s", filename)
                return t
        return self.insert(filename)

    def find(self, tag):
        """wrapper to find on index"""
        return self.index.find_term(tag)

    def update(self):
        """update cache and sorted list

        it will actually check all files in the taskdir
        """
        info("update cache")
        task_dir = config.get( 'default', "task_dir" )
        for line in os.listdir( task_dir ):
            tilde_re = re.compile(r'~$')
            m = tilde_re.search(line)
            if not m:
                filename = os.path.join( task_dir, line )
                t = self.get(filename)
        self.reprio()

    def dshow(self):
        """default show"""
        self.update()
        if self.filter:
            matching_filenames = self.find( self.filter ) # filenames
            matching_tasks = [self.get(filename) for filename in matching_filenames]
            matching_tasks.sort()
            self.show( matching_tasks )
        else:
            self.show( [ self.get(filename) for filename in self.sorted_tasks.sorted() ] )
            # self.show( self.sorted_tasks.sorted() )


    def show(self, tasks ):
        """show the n first tasks in tasks"""
        self.toc = dict()
        for n,t in enumerate(tasks):
            #            print n,t.string() # , t.tag_str()
            nstr = "(%d)" % n
            print "%4s %s" % (nstr, t.string() )
            self.toc[n] = t.filename
#            print "index", n, t.filename
            if n >= self.tasks_to_show:
                break

#\todo: tag højde for at cachede ting ikke bliver ryddet op
        

## operations

# n : open_task() # new task
# / : set filter for listing
# c : close task
# "name": open task
# q: quit
# default: list tasks

import random
import string

def random_new_filename( length = 6 ):
    #alphabet = '1234567890qwertyuiopasdfghjklzxcvbnm'
    alphabet = string.digits+string.ascii_lowercase
    filename_list = [ random.choice( alphabet ) for n in range( length ) ]
    filename = "".join(filename_list)
    return filename

seconds_on_day = 60*60*24
seconds_on_29_days = seconds_on_day * 29
def create_new_task( path ):
    filename = str()
    while 1:
        filename = path + "/" + random_new_filename()
        if not os.path.exists( filename ):
            break
    taskfile = open( filename, 'w')
    lt = time.localtime( time.time() + seconds_on_29_days )
    year = lt[0]
    month = lt[1]
    day = lt[2]
    taskfile.write("subj: \n")
    taskfile.write("prio: \n")
    taskfile.write('date: %d-%d-%d\n' % (day, month, year))
    taskfile.write("stat: \n")
    taskfile.write("tags: \n")
    taskfile.write("\n")
    return filename

def edit_task( filename ):
    cmd = config.get( 'default', 'editor' ) + " " + filename
    os.system(cmd)
    
class taskmanager:

    def __init__(self):
        self.tasks = task_cache()
        self.tasks.update()


    def handle_new(self, str):
        """Adds a new task to the system"""
        fun_re = re.compile(r'^n')
        fun_m = fun_re.search(str)
        if ( fun_m ):
            filename = create_new_task( config.get( 'default', 'task_dir' ) )
            edit_task( filename )
            return True
        else:
            return False


    def handle_open(self, str):
        """Opens an existing task in the system"""
        fun_re = re.compile(r'^\s*(\d+)')
        fun_m = fun_re.search(str)
        if ( fun_m ):
            edit_task( self.tasks.toc[ int( fun_m.group(1) ) ])
            return True
        else:
            return False


    def handle_update(self, str):
        """Updates the cache of tasks in the system"""
        fun_re = re.compile(r'^\s*u')
        fun_m = fun_re.search(str)
        if ( fun_m ):
            self.tasks.update()
            return True
        else:
            return False


    def handle_search(self, str):
        """Searches tasks in the system"""
        fun_re = re.compile(r'^/(.*)')
        fun_m = fun_re.search(str)
        if ( fun_m ):
            self.tasks.filter = fun_m.group(1)
            self.tasks.dshow()
            return True
        else:
            return False

    def handle_present( self ):
        """Shows tasks in the system"""
        self.tasks.dshow()
        return True
        
    def execute(self, token):
        show = False # did we issue a show?
        if self.handle_open( token ):
            pass
        elif self.handle_new( token ):
            pass
        elif self.handle_search( token ):
            show = True
        elif self.handle_update( token ):
            pass
        else: # default case
            pass
        if not show:
            self.handle_present()


class taskcli( object ):
    """ Class representing the task command line interface
    """

    def __init__( self, action='help' ):
        """ 
        
        Arguments:
        - `action`:
        """
        self._action = action
        self._commands = self._get_command_list()

    def _do_cli( self ):
        inp = raw_input( 'tcli% ' )
        cmd = inp.split()[0]
        if( inp.strip().lower() == 'h' ):
            self._print_help( )
            
        elif( inp.strip().lower() == 'q' ):
            return 'q'

        elif( cmd in self._commands[0] ):
            #transitional wrapping of the taskmanager
            method = getattr( taskmanager(), 'handle_%s'%( cmd ), None )
            if method is None:
                raise ValueError( 'Command "%s" not found.' % cmd)
            return method()
        
        else:
            print 'Error: %s not in command list'%( cmd )
            self._print_help()

        return

    def run( self ):
        try:
            while True:
                resp = self._do_cli()
                if resp == 'q':
                    break
        except KeyboardInterrupt:
            sys.exit()


    def _get_command_list( self ):
        command_list = list()
        command_help = dict()
        
        for key in dir( taskmanager ):
            if key.startswith( 'handle' ):
                pname = key.split('_', 1)[-1]
                command_list.append( pname )
                command_help[ pname ] = getattr( taskmanager, key ).__doc__

        return command_list, command_help

    def _print_help( self ):
        print "\nAvailable commands:\n"
        for command in self._commands[0]:
            print """%s:%s%s"""%( command, " "*( 10-len( command ) ), self._commands[1].get( command ) )
        return


if __name__ == "__main__":
    sanity_check()
    

    tm = taskmanager()
    tm.handle_present()
    tc = taskcli()
    tc.run()
#     while 1:
#         data = raw_input("> ")
#         tm.execute( data )


