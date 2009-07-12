#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- mode: python -*-
# from http://www.haller.ws/logs/view.cgi/UrlViewWithPython
import sys, re, email, email.Iterators, email.Parser, curses, os, traceback, base64, xml.sax.saxutils, time, sets
re_url  = re.compile( r'((?:f|ht)tps?://[^\t\n\'\"\<\> ]+)', re.I)

browser = ( '/usr/bin/conkeror', 'conkeror' )
browser_args = '' #'-new-tab'

controls = ({
	( ord("Q"), ord("q") ) : 'cleanup()',
	( ord("B"), ord("b"), 10, curses.KEY_ENTER ) : 'browse(urls[selected], True)',
	(curses.KEY_UP,   curses.KEY_LEFT, ord("k"))  : 'selected = (selected - 1) % len(urls)',
	(curses.KEY_DOWN, curses.KEY_RIGHT, ord("j")) : 'selected = (selected + 1) % len(urls)',
})

def cleanup(kill=True):
	curses.nocbreak(); stdscr.keypad(0); curses.echo(); curses.endwin()
	if kill: os._exit(0)

def browse(url, kill=False):
	os.execvp( browser[0], ( browser[1], browser_args, url ) )

re_youtube = re.compile('http://www.youtube.com/watch\?v=([a-zA-Z0-9]+)')
def present_better(url):
	# make youtube prettier
	for vid in re_youtube.finditer(url):
		return "http://www.youtube.com/v/" + vid.group(1)
	return url

# get msg and re-open stdin if needed
msg = email.Parser.Parser().parse(sys.stdin)
if not os.isatty(0):
	fd = os.open('/dev/tty', os.O_RDONLY)
	if fd < 0: raise ValueError("Unable to open /dev/tty. Exhausted file descriptors?")
	os.dup2(fd, 0); os.close(fd)

# extract urls, the iterator decodes for us
urls = []
for part in msg.walk():
	text = part.get_payload(decode=True)
	if text is None: #no text found in email, most likely wrong part
		continue
	for u in re_url.finditer(text):
		urls.append(u.group(1))

# reverse up any html encoding
for i,u in enumerate(urls):
	urls[i] = xml.sax.saxutils.unescape(urls[i])
	urls[i] = urls[i].rstrip()
	urls[i] = present_better(urls[i])

# sort and reduce in order
seen = []
for u in urls:
	if u not in seen:
		seen.append(u)
urls = seen

# only one url?
if len(urls) == 1:
	browse(urls[0])
	os._exit(0)

# display urls in ncurses
try:
	stdscr = curses.initscr()
	stdscr.clear(); curses.noecho(); curses.cbreak(); stdscr.keypad(1)
	curses.curs_set(0)

	selected = 0
	offset = 0
	while True:
		# jumped to beginning
		if selected == 0:
			stdscr.clear()
			offset = 0
		# jumped to end
		if selected > offset + curses.LINES:
			offset = selected - curses.LINES
		# scrolled down off screen
		if selected == offset + curses.LINES:
			stdscr.clear()
			offset += 1
		# scrolled up off screen
		if selected < offset:
			stdscr.clear()
			offset -= 1
		for i, u in enumerate(urls[offset:]): 
			color = curses.A_NORMAL
			if i + offset == selected: color = curses.A_REVERSE
			try:
				stdscr.addstr(i, 0, "%-2d %s" % (i+1,u), color)
			except:
				pass
		if len(urls) == 0:
			stdscr.addstr(selected, 0, "No URLs found!")
		c = stdscr.getch()
		for k in controls.keys():
			if c in k: exec(controls[k])
except:
	cleanup(0)
	traceback.print_exc()

# clean up curses
cleanup()
