# macOS Defaults module for Puppet

## Note of potential disaster

This module has not been tested. It was rolled straight into production and
let to its own devices. It will probably blow up your whole server park unless
you are careful. If it does, i'd appreciate a patch, so that it won't blow up
any other server park.

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with macdefaults](#setup)
    * [What macdefaults affects](#what-macdefaults-affects)
    * [Setup requirements](#setup-requirements)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Set or remove your macOS `defaults` with macdefaults.

This module is a re-write of the two modules i found floating around the
interwebs for just this, namely:

* https://github.com/wfarr/puppet-osx_defaults by Will Farrington, and
* https://github.com/pebbleit/puppet-macdefaults by Graham Gilbert

Neither of these have been updated for years, and one of the files contained
some kind of incompatibility with Puppet 4. So here's my mash-up of these two
modules.

The module includes some rudimentary error checking for missing and ill-formed
values.

## Setup

Clone or download this module to live nicely among your other puppet modules.
Cross your fingers. Breathe normally.

### What macdefaults affects

You can set or remove any macOS `defaults` with this module, but you need to
know the correct domain. For many fun and useful things to muck around with,
have a look at https://github.com/boxen/puppet-osx.

### Setup Requirements

Requires `puppetlabs-stdlib` version 4.0.0 or higher, and a Mac to run the
module on.

## Usage

In a manifest dealing with a macOS node (you know, a Mac), include something
along the lines of

```
macdefaults { "AppleUpdatesThroughMunki":
   ensure  => present,
   domain  => "/Library/Preferences/ManagedInstalls",
   key     => "InstallAppleSoftwareUpdates",
   type    => 'bool',
   value   => True,
}
```
The example code above would ensure that Macs use Munki for Apple system udates.

Possible values for `type` are those of OS X Defaults; ie. `string`, `data`,
`int` (or `integer`), `float`, `bool` (or `boolean`), `array`, `array-add`,
`dict` and `dict-add`. That said, i've never tested any other values than `int`;
i just copied this from Graham's macdefaults README.md, so don't take my word
for it. Read the source. Understand what you do. And send me a patch if you find
a bug.

The code includes some checking for idempotency. It used to be wicked clever,
but rather opaque, so i expanded the code for readability. You can still find
the original and quote ingenious checking code for boolean values in Gilbert's
and Farrington's code.

I removed the quotes inside some of the code, which might break stuff up.
Please use quotes around any strange string values.

Yet untested, but according to the puppet [language reference on case matching
](https://docs.puppet.com/puppet/latest/reference/lang_conditional.html#case-matching-1),
the values for the `bool` type _should_ be case-insensitive.

## Reference

* `man defaults` on your Mac
* https://github.com/wfarr/puppet-osx_defaults by Will Farrington, and
* https://github.com/pebbleit/puppet-macdefaults by Graham Gilbert
* https://github.com/boxen/puppet-osx by Boxen

## Limitations

Me, mostly.

## Development

Merge/pull requests welcome.

## Release Notes/Contributors/Etc.

Second major rewrite. Works on my machine. Only tested with the `Int` type. Your
mileage will most certainly vary. Handle with care and have mercy.

If you think there are a lot of comments in the manifest file, it's just because
that's how Puppet does it when you create a new module with `puppet module
generate macdefaults`.

## Bug warning

This module was originally called osx_defaults (from Will Farrington's code) but
i chose to go with the name macdefaults, as OS X is now known as macOS rather
than OS X. I hope i managed to find-replace all relevant instances of the old
name in the code!
