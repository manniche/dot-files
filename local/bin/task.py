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
from ConfigParser import ConfigParser

from logging import *
import logging
# known bugs: the index for searching is never cleaned up

getLogger().setLevel( ERROR )
#getLogger().setLevel(WARNING)
#getLogger().setLevel(INFO)
#getLogger().setLevel( DEBUG )

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

def setup( config ):
    """Tries to setup a working environment based on the configuration
    values, if environment does not seem to exist already"""

    #getting the basics first
    top_dir =  config.get( 'default', 'top_dir' )
    sane_env = _ask_create_dir( top_dir, 0744 )

    if sane_env:
        config.remove_option( 'default', 'top_dir' )
        for directory in config.options( 'default' ):
            if directory.endswith( '_dir' ):
                _ask_create_dir( config.get( 'default', directory ) )
    
def _ask_create_dir( name, mode=0740 ):
    """Runs an interactive session with the user for each folder that
    is passed in, trying to construct it, if it doesn't exist
    """

    if not os.path.exists( name ):
        try:
            inp = raw_input( "%s does not exist, should I create it? ( y/n )\n> "\
              % ( name ) )
            if( inp.lower() == 'y' ):
                os.mkdir( name )
                os.chmod( name, mode )
                return True
            else:
                print "as requested, I did nothing on %s"%( name )
                return False
        except IOError, ioe:
            "Could not create %s. Please create it manually before running task.py"\
            % ( name )
            return False
    

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
config.set( 'default', 'editor', os.getenv( 'TASKEDITOR', 'emacs -nw -q' ) )

setup( config )

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
        s += self.filename + ": [" + str(self.prio) + "] "\
             + self.subj + "[" + str(self.date) + "]" + str(self.realprio)
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
        debug("prio is %s"% self.prio)
                
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
        debug("day: %s"% day)
        debug("base: %s"% base)
        self.realprio = int((1000000 * (base + 1) ) + day);
        if not self.open:
            self.realprio = self.realprio * 10
        debug("realprio: %s"% self.realprio)

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
            debug("matching: %s"% line)
            h = holder()
            if empty_line.search(line):
                debug("empty line, break")
                break
            elif h.hold(header_line.search(line)):
                # hvad hvis content er tomt??
                (name, content) = h.var.groups()
                debug("name: >%s< content: >%s<"%( name, content ) )
                if name == "date": self.init_date(content)
                elif name == "prio": self.init_prio(content)
                elif name == "stat": self.init_stat(content)
                elif name == "subj": self.init_subj(content)
                elif name == "tags": self.add_tags(content)
            else:
                warning("no match")


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
                debug("using cache for: %s"% filename)
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


def create_new_task( path=None, task_args=None ):
    #TODO: If all values are given in args, an editor should not be opened

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
    task_list = [ 'subj', 'prio', 'stat', 'tags', 'body' ]
    #ok, this is a piss-poor shot at parsing unknown and probably
    #non-conforming textual input
    split_me_args = re.compile( r'(\w+) (\d+) (\w+) \"((?:\w+\s?)+)\" \"((?:\w+\s?)+)\"' )
    debug( "task_args=%s"%( task_args ) )
    re_args = None
    if isinstance( task_args, str ):
        re_args = split_me_args.search( task_args )
    if( re_args ):
        args = dict( zip( task_list, list( re_args.groups() ) ) )
    elif isinstance( task_args, list ) and len( task_args ) == 5:
        args = dict( zip( task_list, task_args ) )
    else:
        args = dict()
    taskfile.write("subj: %s\n"%( args.get( "subj", "" ) ) )
    taskfile.write("prio: %s\n"%( args.get( "prio", "" ) ) )
    taskfile.write('date: %d-%d-%d\n' % (day, month, year))
    taskfile.write("stat: %s\n"%( args.get( "stat", "" ) ) )
    taskfile.write("tags: %s\n"%( args.get( "tags", "" ) ) )
    taskfile.write("%s\n"%( args.get( "body", "" ) ) )
    return filename

def edit_task( filename ):
    cmd = config.get( 'default', 'editor' ) + " " + filename
    os.system(cmd)

    
class Taskmanager:

    def __init__( self, action="help" ):
        self.tasks = task_cache()
        self.tasks.update()
        self._action = action
        # TODO: der er noget redundans imellem _commands og _aliases
        self._commands = self._get_command_list()
        self._aliases = { re.compile( r'^n' ): [ 'new' ],
                          re.compile( r'^/(.*)' ): [ 'search' ],
                          re.compile( r'^\s*(\d+)' ): [ 'open' ],
                          re.compile( r'^(c)' ): [ 'close' ],
                          re.compile( r'^\s*u' ): [ 'update' ],
                          re.compile( r'^\s*\?' ): [ 'help' ],
                          re.compile( r'^\s*q' ): [ 'quit' ] }
        

    def handle_new( self, token ):
        """(or n) Adds a new task to the system
        use new with arguments to quickly create a new task:

        (new | n) {subject} {priority} {status} {tags} {body}
        """
        debug( "got input token=%s"%( token ) )
        filename = create_new_task( config.get( 'default', 'task_dir' ), token )
        edit_task( filename )


    def handle_open( self, token ):
        """(using open or 'taskname' ) Opens an existing task in the system"""
        self.tasks.dshow()
        if isinstance( token, list ) and len( token ) > 0:
            token = token[0]
        else:
            token = int( raw_input( 'Please enter no of task to open: ' ) )
        debug( "Trying to open task %s"%( token ) )
        debug( "From list=%s"%( self.tasks.toc ) )
        edit_task( self.tasks.toc[ int( token ) ])


    def handle_close( self, token ):
        """(using 'close' or 'close tasknumber' ) Closes an existing task in the system"""
        self.tasks.dshow()
        if isinstance( token, list ) and len( token ) > 0:
            token = token[0]
        else:
            token = int( raw_input( 'Please enter no of task to close: ' ) )
        debug( "Trying to close task %s"%( token ) )
        debug( "From list=%s"%( self.tasks.toc ) )
        filename = self.tasks.toc[ int( token ) ]
        debug( "closing task in %s"%( filename ) )
        f = open( filename )
        header_line = re.compile(r'^(stat):\s*(.*)\s*$')
        _output = list()
        for line in f:
            debug("matching: %s"% line)
            h = holder()
            if h.hold( header_line.search( line ) ):
                (name, content) = h.var.groups()
                debug("name: >%s< content: >%s<"%( name, content ) )
                if name == "stat":
                    line = "stat: closed"
            else:
                warning("no match")
            _output.append( line )
        f.close()
        f = open( filename, 'w' )
        f.writelines( _output )
        f.close()
        debug( 'closed task in file %s'%( filename ) )
        self.tasks.dshow()


    def handle_update(self, str):
        """Updates the cache of tasks in the system"""
        self.tasks.update()


    def handle_search( self, token ):
        """Searches tasks in the system"""
        #task_cache.filter only heeds the first item, so no use in
        #splitting the list here, sans avoiding TypeErrors from the re
        #module
        self.tasks.filter = ' '.join( token )
        self.tasks.dshow()
        

    def handle_present( self, token=None ):
        """Shows tasks in the system"""
        self.tasks.dshow()
        return True


    def handle_quit( self, token ):
        """(q) Quits the program"""
        sys.exit()


    def handle_help( self, token ):
        """Prints help text"""
        self._print_help()

        
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
        do_cli( show )


    def run_once( self, args ):
        '''If the arguments were given directly to the program, it is
        run in non-interactive mode and exits thereafter'''
        filename = create_new_task( config.get( 'default', 'task_dir' ), args )
        info( 'created task with filename \'%s\''%( filename ) )


    def do_cli( self, cmd, args ):

        try:
            cmd = int( cmd )
        except ValueError:
            debug( "%s is not a task number"%( cmd ) )

        if( isinstance( cmd, int ) ):
            method = getattr( Taskmanager(), 'handle_open' )
            args = list( str( cmd ) )
            debug( "calling %s( args=%s )"%( method, args ) )
            method( args )
            return
            
        elif( cmd.lower() in self._commands[0] and cmd.lower() == 'help' ):
            self._print_help( )
            
        elif( cmd in self._commands[ 0 ] ):
            
            method = getattr( Taskmanager(), 'handle_%s'%( cmd ), None )
            if method is None:
                raise ValueError( 'Command "%s" not found.' % cmd)
            debug( "calling %s( args=%s )"%( method, args ) )
            method( args )
            return

        for match in self._aliases.keys():
            here = match.search( cmd )
            if( here ):
                new_args = list()
                info( "groups="+str( here.groups() )+", args="+str( args ) )
                if( len( args ) > 0 ):
                    debug( "args: %s "%( args ) )
                    for i in args:
                        new_args.append( i )
                cmd = self._aliases.get( match )[0]
                info( "METHOD: %s( %s )"%( cmd, new_args ) )
                method = getattr( Taskmanager(), 'handle_%s'%( cmd ), None )
                if method is None:
                    raise ValueError( 'Command "%s" not found.' % cmd )
                if len( new_args ) == 0:
                    new_args = ''
                method( new_args )
                return
        self.handle_present()
        return


    def _get_command_list( self ):
        command_list = list()
        command_help = dict()
        
        for key in dir( Taskmanager ):
            if key.startswith( 'handle_' ):
                pname = key.split('_', 1)[-1]
                command_list.append( pname )
                command_help[ pname ] = getattr( Taskmanager, key ).__doc__

        return command_list, command_help

    def _print_help( self ):
        print "\nAvailable commands:\n(The command alias is shown in paratheses)\n"
        for command in self._commands[0]:
            print """%s:%s%s"""%( command, " "*( 10-len( command ) ), self._commands[1].get( command ) )


if __name__ == "__main__":
    sanity_check()
    
    from optparse import OptionParser
    usage_text = '''%prog [options] subject priority {open|closed} "tags" "description"

If all arguments are given, task.py simply creates a task and exits.
If more or less than the specified arguments are given, task.py exists
with an error code.

Currently, no checks are made on the order of the arguments, so if
priority are given as the argument in position one, and the number of
arguments is correct, a task will be created with "priority" as
subject.
    '''
    parser = OptionParser( usage=usage_text )
    
    parser.add_option( "-t", dest="test", 
                       action="store", help="Runs testsuite on task.py" )
    
    (options, args) = parser.parse_args()
    status = [ 'open', 'closed' ]
    tm = Taskmanager()

    if options.test:
        import doctest
        doctest.testmod()
    if len( args ) == 5 and args[2] in status:
        inp = args
        tm.run_once( args )
    elif len( args ) > 0 and args[2] not in status:
        sys.exit( 'status must be one of: %s'%( ', '.join( status ) ) )
    elif len( args ) > 0:
        print "length of arguments = %s"%( len( args ) )
        sys.exit( 'if any arguments are given, please specify all five' )

    tm.handle_present()
#     tc = taskcli()
#     tc.run()
    try:
        while True:
            inp  = raw_input( 'tcli% ' )
            cmd  = inp.split()[0]
            #args = ' '.join( inp.split()[1:] )
            args = inp.split()[1:]
            debug( "cmd=%s"%( cmd ) )
            debug( "args=%s"%( args ) )
            tm.do_cli( cmd, args )
    except KeyboardInterrupt:
        sys.exit()
