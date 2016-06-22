# Class: macdefaults
# ===========================
#
# Handle OS X Defaults from Puppet
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
# Robin Laurén <robin.lauren@st4.lan>
#
# Based on the works of
# * Will Farrington https://github.com/wfarr/puppet-osx_defaults
# * Graham Gilbert https://github.com/pebbleit/puppet-macdefaults
#
# Copyright
# ---------
#
# Copyright 2016 Robin Laurén / Reaktor
#

define macdefaults(
  $ensure = 'present',
  $domain = undef,
  $key    = undef,
  $value  = undef,
  $type   = "string",
) {

  case $operatingsystem {

    "Darwin": {
      $defaults_cmd = "/usr/bin/defaults"

      case $ensure {

        'present': {
          if ($domain != undef) and ($key != undef) and ($value != undef) {
            exec { "defaults write $domain $key -$type $value":
              command => "${defaults_cmd} write ${domain} ${key} -${type} ${value}",
              unless  => $type ? {
                'bool' => $value ? {
                  'True' => "${defaults_cmd} read ${domain} ${key} -${type} | grep -qx 1",
                  'False' => "${defaults_cmd} read ${domain} ${key} -${type} | grep -qx 0",
                },
                default => "${defaults_cmd} read ${domain} ${key} -${type} | grep -qx ${value}",
              }
            }
          } else {
            warn ("macdefaults cannot ensure present without domain, key and value attributes")
          }
        }

        'absent': {
          if ($domain != undef) and ($key != undef) {
            exec { "defaults delete $domain $key":
              command => "${defaults_cmd} delete ${domain} ${key}",
              onlyif  => "${defaults_cmd} read ${domain} | egrep '^${key}$''",
            }
          } else {
            warn ("macdefaults cannot ensure absent without domain and key attributes")
          }
        }

        default: {
          warn ("macdefaults ensure => [present | absent] domain key type value")
        }
      }
    }
    default: {
      warn ("macdefaults only work on OS X")
    }
  }
}





# Note that type can be one of:
# string, data, int, float, bool, data, array, array-add, dict, dict-add
define mac-defaults($domain, $key, $value = false, $type = "string", $action = "write") {
case $operatingsystem {
 Darwin:{
  case $action {
    "write": {
      exec {"defaults write $domain $key -$type '$value'":
        path => "/bin:/usr/bin",
          unless => $type ? {
            'bool' => $value ? {
              'TRUE' => "defaults read $domain $key | grep -qx 1",
              'FALSE' => "defaults read $domain $key | grep -qx 0"
            },
            default => "defaults read $domain $key | grep -qx $value | sed -e 's/ (.*)/\1/'"
        }
      }
    }
    "delete": {
      exec {"defaults delete $domain $key":
        path => "/bin:/usr/bin",
        logoutput => false,
        onlyif => "defaults read $domain | grep -q '$key'"
      }
    }
  }
 }
}


}

class macdefaults{

}
