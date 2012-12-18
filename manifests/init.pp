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
            bool => $value ? {
              TRUE => "defaults read $domain $key | grep -qx 1",
              FALSE => "defaults read $domain $key | grep -qx 0"
              },
          default => "defaults read $domain $key | grep -qx $value"
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