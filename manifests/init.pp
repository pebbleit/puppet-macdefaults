# Class: macdefaults
# ===========================
#
# Handle macOS `defaults` from Puppet
#
# Parameters
# ----------
#
# * `ensure` - present or absent
# * `domain`
# * `key`
# * `type`
# * `value`
#
# Examples
# --------
#
# @example
#   macdefaults { "AppleUpdatesThroughMunki":
#     ensure  => present,
#     domain  => "/Library/Preferences/ManagedInstalls",
#     key     => "InstallAppleSoftwareUpdates",
#     type    => 'bool',
#     value   => True,
#   }
#
# Authors
# -------
#
# @author Robin Laurén <robin.lauren@reaktor.com>
#
# Based on the works of
# * Will Farrington https://github.com/wfarr/puppet-osx_defaults
# * Graham Gilbert https://github.com/pebbleit/puppet-macdefaults
#
# Copyright
# ---------
#
# Copyright (c) Robin Laurén / Reaktor (c) 2017, All rights reserved.
# License: BSD 2-Clause License (see LICENSE)

class macdefaults (
  String $ensure = 'present',
  String $domain = undef,
  String $key    = undef,
  $value         = undef,
  String $type   = 'string',
) {

  assert_type(Enum['present', 'absent'], $ensure)
  assert_type(Enum['string', 'data', 'int', 'integer', 'float', 'bool', 'boolean', 'date', 'array', 'array-add', 'dict', 'dict-add'], $type)
  assert_type(String, $domain)
  assert_type(String, $key)

  if ($facts['operatingsystem'] != 'Darwin') {
    fail('macdefaults only works on macOS')
  }

  $defaults_cmd = '/usr/bin/defaults'

  case $ensure {

    'present': {
      if ($value == undef) {
        fail ('`value` is missing')
      }

      if ($type =~ /^bool(ean)?$/) {
        $bvalue = assert_type(Boolean, $value)
        $nvalue = bool2num($bvalue)
        $value  = bool2str($bvalue)
        $check  = "${defaults_cmd} read ${domain} ${key} -${type} ${value} | grep -qx ${nvalue}"
      } else {
        $check = "${defaults_cmd} read ${domain} ${key} -${type} | grep -qx ${value}"
      }

      exec { "${defaults_cmd} write ${domain} ${key} -${type} ${value}":
        unless  => $check,
      }
    }

    'absent': {
      exec { "${defaults_cmd} delete ${domain} ${key}":
        onlyif => "${defaults_cmd} read ${domain} | egrep '^${key}$''",
      }
    }

    default: {
      fail ('macdefaults ensure => [present | absent] domain key type value')
    }
  }
}
