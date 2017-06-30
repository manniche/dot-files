#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -*- mode: python -*-
"""Python module for i3 status

Features:
- list pacman packages

To do:
- all the other stuff
"""

__author__ = 'Steen Manniche <manniche>'
__date__ = 'Mon Feb 22 14:43:53 2016'
__version__ = '$Revision:$'

class Pacman:
    """
    class for interacting with pacman package manager
    """
    
    def __init__( self ):
        """
        """
        pass
    def get_update_number( self ):
        """
        echo "n"|sudo pacman -Su 2> /dev/null | egrep "Packages \(" | cut -d' ' -f2
        """
    

