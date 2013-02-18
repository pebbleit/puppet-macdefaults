OS X Defaults module for Puppet
==================

This module manages defaults on OS X. I didn't write 90% of this, but I can't for the life of me remember where I found it. I'm putting it on here for posterity.

#Usage

Possible valuse for ``type`` are:

* string
* data
* int
* float
* bool
* data
* array
* array-add
* dict
* dict-add

Example Puppet Code:

	include macdefaults
	
	mac-defaults { "set-a4":
          domain => '/Library/Preferences/com.apple.print.PrintingPrefs',
          key => 'DefaultPaperID',
          type => 'string',
          value => "iso-a4",
	}