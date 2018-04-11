#include once "wshelper.bi"
#include once "aulib.bi"

enum clientStatus
    notConnected
    waitAuth
    active
end enum

type Client
    as uinteger ID
    as zstring*16 username
    as socket sock
    as clientStatus status
end type

