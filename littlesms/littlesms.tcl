package provide littlesms 0.1

package require sha1
package require md5
package require http
package require json

namespace eval ::littlesms {
    namespace export balance send status price
    
    variable BASE_URL http://littlesms.ru/api/
    
    proc balance {user key} {
        return [request $user $key user/balance]
    }
    
    proc send {user key message recipients {sender ""} {type 0}} {
        set params [dict create message $message recipients $recipients type $type]
        if {$sender != ""} {
            dict set params sender $sender
        }
        return [request $user $key message/send $params]
    }
    
    proc status {user key ids} {
        set params [dict create messages_id $ids]
        return [request $user $key message/status $params]
    }
    
    proc price {user key message recipients} {
        set params [dict create message $message recipients $recipients]
        return [request $user $key message/price $params]
    }
    
    proc request {user key path {params ""}} {
        variable BASE_URL
        
        set sign [sign $user $key $params]
        
        dict set params sign $sign
        dict set params user $user
        set qs [::http::formatQuery {*}$params]
        
        # Windows /r/n -> /n
        set qs [regsub -all %0D $qs ""]
        set url {}
        append url $BASE_URL $path ? $qs
        
        set token [::http::geturl $url]
        set data [::http::data $token]
        set json [::json::json2dict $data]
        
        if {[dict exists $json error]} {
            set code [dict get $json error]
            set message [dict get $json message]
            error $message $data $code
        }
        return $json
    }
    
    proc sign {user key params} {    
        set tosign $user
        foreach param [lsort [dict keys $params]] {
            append tosign [dict get $params $param]
        }
        append tosign $key
        return [string tolower [::md5::md5 -hex [::sha1::sha1 -hex [encoding convertto utf-8 $tosign]]]]
    }
}




