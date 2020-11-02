#include once "mysql\mysql.bi"
#include "crt.bi"

#define NULL 0

type AuSQL
    as MYSQL ptr cn
    as string db, host, uid, pw
    as string clientInfo, hostInfo, serverInfo
    as MYSQL_RES ptr result
    
    declare sub connect(db as string, host as string, uid as string, pw as string)
    declare sub close()
    declare sub query(sqlCmd as string)
end type

sub AuSQL.connect(db as string, host as string, uid as string, pw as string)
    with this
        .cn = mysql_init(0)
        .db = db
        .host = host
        .uid = uid
        .pw = pw
        
        if(mysql_real_connect(.cn,.host,.uid,.pw,0,MYSQL_PORT,0,0) = 0) then
            printf(!"Failed to connect to MySQL server!\n")
            .close()
            sleep()
            return
        end if
        
        if(mysql_select_db(.cn,.db)) then
            printf(!"Failed to select the " & .db & " database!\n")
            .close()
            sleep()
            return
        end if
        
        .clientInfo = *mysql_get_client_info()
        .hostInfo = *mysql_get_host_info(.cn)
        .serverInfo = *mysql_get_server_info(.cn)
    end with
end sub

sub AuSQL.close()
    mysql_close(this.db)
end sub

sub AuSQL.query(sqlCmd as string)
    
end sub