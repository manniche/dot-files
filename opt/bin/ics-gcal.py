#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- mode: python -*-

""" ics-gcal.py (c) 2008 Matthew Ernisse <mernisse@ub3rgeek.net>

Cobbled together with help from gdata API documentation:
http://code.google.com/apis/calendar/developers_guide_python.html

To Use:
        add the following to your .mailcap and then you can simply
exec the attachment and it will get added to your google calendar.

If the event has a reminder set it will set a reminder using your 
default method for 30 minutes prior to the event.

text/calendar;  ics-gcal.py -u <gcal un> -p <gcal pw> -f %s; \
                copiousoutput; needsterminal

Calendar name can be found on the calendar details page, or based
on your calendar's xml/ical links.  

If your XML link is:
http://www.google.com/calendar/feeds/yourname@gmail.com/public/basic

Then your calendar name is yourname@gmail.com

Requires:
        gdata python bindings
        atom python module
        vobject python module

        Google Calendar account

$Id: ics-gcal.py,v 1.6 2009/01/07 00:04:26 mernisse Exp $

stm:
120109: - added optionparser support
        - removed method Usage() (now supported by optionparser)
        - removed usage of module getopt (now supported by optionparser)
        - added support for configuration file
        - pep8 compliance wrt. indentation
    

"""
import time
import sys
import os
import vobject

from gdata.calendar.service import *
from gdata.calendar import CalendarEventEntry, Reminder, Recurrence, Where, When

#def Reply(ics, reply="tentative"):
#
#       if reply == "accept":
#               message = "Event Accepted"
#               subject = 
#                       
#       elif reply == "tentative":
#               message = "Event Tentativly Accepted"
#               subject = 
#
#       elif reply == "deny":
#               message = "Event Declined"
#               subject = 
#
#       else:
#               print "Invalid reply specified"
#               return None
#
#

def uploadToGoogle(ics, email, password, calendar="default", reminder=30, \
                   forceReminder=False):
        """ Upload to your Google Calendar.

        Arguments:
        ics - vobject vevent object.
        email - string, your gcal account name
        password - string, your gcal password
        calendar - string, which calendar to upload to.
        reminder - integer, number of minutes to set
                   reminder for.  Default 30
        forceReminder - boolean, If true, always set a
                        reminder.

        Returns:
                 True on success, None on failure

        """
        # sucks that gdata won't take a timetuple or a isoformat :(
        # it seems that sometimes vobject doesn't give me a
        # datetime object and instead gives me a unicode string.
        # it'd be nice to handle that.
        if type(u' ') == type(ics.vevent.dtstart.value):
                start = time.strptime(ics.vevent.dtstart.value, 
                                      "%Y%m%dT%H%M%S")
                start = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", 
                                      start)
        else:
                start = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", 
                                      ics.vevent.dtstart.value.utctimetuple())
                
        if type(u' ') == type(ics.vevent.dtend.value):
                end = time.strptime(ics.vevent.dtend.value, 
                                    "%Y%m%dT%H%M%S")
                end = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", 
                                    end)
        else:
                end = time.strftime("%Y-%m-%dT%H:%M:%S.000Z", 
                                    ics.vevent.dtend.value.utctimetuple())

        event = CalendarEventEntry()
        event.title = atom.Title(text=ics.vevent.summary.value)
        if getattr(ics.vevent, "description", None):
                event.content = atom.Content(text=ics.vevent.description.value)
        else:
                event.content = atom.Content(text="")

        if getattr(ics.vevent, "location", None):
                event.where.append(
                        Where(value_string=ics.vevent.location.value)
                )
        else:
                event.where.append(Where(value_string=""))

        event.when.append(When(start_time=start, end_time=end))

        # an alarm is set, so go ahead and set a reminder
        if 'valarm' in ics.vevent.contents:
                for when in event.when:
                        if len(when.reminder) > 0:
                                when.reminder[0].minutes = reminder
                        else:
                                when.reminder.append(Reminder(minutes=reminder))
        elif forceReminder:
                for when in event.when:
                        when.reminder.append(Reminder(minutes=reminder))

        if getattr(ics.vevent, "rrule", None):
                try:
                        event.recurrence = Recurrence(text=("%s\r\n%s\r\n%s\r\n") % (
                                "DTSTART;VALUE=DATE:%s" % (
                                        time.strftime("%Y%m%d",ics.vevent.dtstart.value.utctimetuple())
                                        ),
                                "DTEND;VALUE=DATE:%s" % (
                                        time.strftime("%Y%m%d",ics.vevent.dtend.value.utctimetuple())
                                        ),
                                "RRULE:%s" % (
                                        ics.vevent.rrule.value
                                        )
                                )
                        )
                except Exception, e:
                        print "could not add Recurrence to event, %s" % (str(e))
                        return None

        try:
                cal = CalendarService()
                cal.email = email
                cal.password = password
                cal.source = "ics-gcal.py_mernisse@ub3rgeek.net"
                cal.ProgrammaticLogin()
        except Exception, e:
                print "cannot login to Google Calendar: %s"  % ( str(e) )
                return None

        try:
                new_event = cal.InsertEvent(event, '/calendar/feeds/%s/private/full' % (calendar))
        except Exception, e:
                print "cannot upload event to Google Calendar: %s"  % ( str(e) )
                return None
    
        print 'New single event inserted: %s' % (new_event.id.text,)
        print '\tEvent edit URL: %s' % (new_event.GetEditLink().href,)
        print '\tEvent HTML URL: %s' % (new_event.GetHtmlLink().href,)

        return True

def Main(argv = None):

        calendar = ""
        email = ""
        password = ""
        fd = None
        force = False
        reminder = 30

        from optparse import OptionParser
        from optparse import OptionGroup

        usage="""%prog:

        use %prog -h to see available options

        Take a vcalendar stream from a file and insert to it into a Google 
        calendar

        It is possible to specify the username and password on the
        command line directly or in a configuration file in
        $HOME/.ics-gcal
        When using this (the configuration file) option, please specify as:

        username = my-account@gmail.com
        password = myseekrit
        """

        parser = OptionParser( usage=usage )
        
        parser.add_option( "-v", "--verbose", dest="verbose", action="store_true", 
                           default=False, help="Turns on verbosity of the program" )

        parser.add_option( "-c", "--calendar", 
                           type="string", action="store", dest="calendar",
                           help="Which calendar to upload to, default = 'default'")

        parser.add_option( "-f", "--icsfile", 
                           type="string", action="store", dest="ics",
                           help="ics file for input")

        parser.add_option( "-p", "--password", 
                           type="string", action="store", dest="passwd",
                           help="Google Calendar password")

        parser.add_option( "-u", "--username", 
                           type="string", action="store", dest="user",
                           help="Google Calendar username")

        parser.add_option( "-r", "--minutes", 
                           type="int", action="store", dest="minutes",
                           help="Number of minutes for reminder length, default = 30")

        parser.add_option( "-R", "--reminder-force", 
                           action="store_true", dest="reminder", default=False,
                           help="Force adding a reminder even if the ics does not have an alarm set.")

        (options, args) = parser.parse_args()

        if options.ics is not None:
                try:
                        fd = open( options.ics )
                except IOError, e:
                        sys.exit( str( e ) )
        

        if options.calendar is None:
                calendar = "default"
        else:
                calendar = options.calendar

        if options.user is None or options.passwd is None:
                if not os.path.exists( os.environ.get( 'HOME' )+os.path.sep+'.ics-gcal' ):
                        sys.exit( parser.print_help() )
                else:
                        filename = ""
                        try:
                                from configobj import ConfigObj
                                config = ConfigObj()
                                filename = os.environ.get( 'HOME' )+os.path.sep+'.ics-gcal'
                                config = ConfigObj(filename)
                                email = config[ "user" ]
                                password = config[ "pass" ]
                        except ImportError:
                                sys.exit( "you need python-configobj for using this option" )
                        except IOError, e:
                                parser.error( "Could not open or read configurationfile:%s\n %s"%( filename, str(e) ) )

        if options.ics is None:
                parser.error( "You have to specify an ics file" )

        try:
                ics = vobject.readOne( fd )
                fd.close()
        except IOError, e:
                sys.exit( "cannot open or parse vcal input file: %s"  % ( str(e) ) )

        if not uploadToGoogle(ics, email, password, calendar, options.minutes, options.reminder):
                sys.exit( 1 )
        return sys.exit( 0 )

if __name__ == "__main__":
        sys.exit(Main(sys.argv[1:]))
