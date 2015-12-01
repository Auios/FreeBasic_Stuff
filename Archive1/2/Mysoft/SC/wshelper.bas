#include once "wshelper.bi"

'':::::
function hStart( byval verhigh as integer = 2, byval verlow as integer = 0 ) as integer
	dim wsaData as WSAData
	
	if( WSAStartup( MAKEWORD( verhigh, verlow ), @wsaData ) <> 0 ) then
		return FALSE
	end if
	
	if( wsaData.wVersion <> MAKEWORD( verhigh, verlow ) ) then
		WSACleanup( )	
		return FALSE
	end if
	
	function = TRUE

end function

'':::::
function hShutdown( ) as integer

	function = WSACleanup( )
	
end function
':::::

function hResolve( byval hostname as zstring ptr) as integer
	dim ia as in_addr
	dim hostentry as hostent ptr

	'' check if it's an ip address
	ia.S_addr = inet_addr( hostname )
	if ( ia.S_addr = INADDR_NONE ) then
		
		'' if not, assume it's a name, resolve it
		hostentry = gethostbyname( hostname )
		if ( hostentry = 0 ) then
			exit function
		end if
		
		function = *cptr( integer ptr, *hostentry->h_addr_list )
		
	else
	
		'' just return the address
		function = ia.S_addr
	
	end if
	
end function

'':::::
#define hOpenUDP() hOpen( IPPROTO_UDP )
function hOpen( byval proto as integer = IPPROTO_TCP ) as SOCKET
	dim ts as SOCKET    
  dim as integer SockType = SOCK_STREAM
  if proto <> IPPROTO_TCP then SockType = SOCK_DGRAM
  ts = OpenSocket( AF_INET, SockType, proto )
  if( ts = NULL ) then
		return NULL
	end if
	
	function = ts
	
end function

'':::::
function hConnect overload (s as SOCKET, ip as integer, port as integer ) as integer
	dim sa as sockaddr_in

	sa.sin_port			= htons( port )
	sa.sin_family		= AF_INET
	sa.sin_addr.S_addr	= ip
	
  var iNoDelay = true
  setsockopt(s,IPPROTO_TCP,TCP_NODELAY,cast(any ptr,@iNoDelay),sizeof(iNoDelay))
  function = connect( s, cptr( PSOCKADDR, @sa ), len( sa ) ) <> SOCKET_ERROR
  setsockopt(s,IPPROTO_TCP,TCP_NODELAY,cast(any ptr,@iNoDelay),sizeof(iNoDelay))
	
end function

function hConnect overload (s as SOCKET, ip as long, port as long, byref LocalIP as long,byref LocalPort as long) as integer
	dim sa as sockaddr_in

	sa.sin_port			= htons( port )
	sa.sin_family		= AF_INET
	sa.sin_addr.S_addr	= ip  
  
	function = connect( s, cptr( PSOCKADDR, @sa ), len( sa ) ) <> SOCKET_ERROR
  
  LocalIP = sa.sin_addr.S_addr
  LocalPort = htons(sa.sin_port)
	
end function

'':::::
#define hBindUDP hBind
function hBind( byval s as SOCKET, byval port as integer, iIP as integer = INADDR_ANY ) as integer
	dim sa as sockaddr_in

	sa.sin_port			= htons( port )
	sa.sin_family		= AF_INET
	sa.sin_addr.S_addr	= iIP
	
	function = bind( s, cptr( PSOCKADDR, @sa ), len( sa ) ) <> SOCKET_ERROR
	
end function

'':::::
function hListen( byval s as SOCKET, byval timeout as integer = SOMAXCONN ) as integer
	
	function = listen( s, timeout ) <> SOCKET_ERROR
	
end function

'':::::
function hAccept overload ( byval s as SOCKET, byval sa as sockaddr_in ptr ) as SOCKET
	dim salen as integer 
	
	salen = len( sockaddr_in )
	function = accept( s, cptr( PSOCKADDR, sa ), @salen )

end function	

'':::::
function hAccept( byval s as SOCKET, byref pIP as long, byref pPORT as long ) as SOCKET
  dim sa as sockaddr_in
	dim salen as integer = len( sockaddr_in )
	function = accept( s, cptr( PSOCKADDR, @sa ), @salen )
  pIP = sa.sin_addr.S_addr
  pPORT = htons(sa.sin_port)  

end function	


'':::::
#define hCloseUDP hClose
function hClose( byval s as SOCKET ) as integer

	shutdown( s, 2 )
	
	function = closesocket( s )
	
end function

'':::::
function hSend( byval s as SOCKET, byval buffer as zstring ptr, byval bytes as integer ) as integer

    function = send( s, buffer, bytes, 0 )
    
end function

'':::::
function hSendUDP( s as SOCKET, IP as ulong, Port as long, buffer as zstring ptr, bytes as long ) as integer  
  
  dim sa as sockaddr_in
	sa.sin_port			= htons(port)
	sa.sin_family		= AF_INET
	sa.sin_addr.S_addr	= IP
  
  return SendTo(s,buffer,bytes,null,cast(any ptr,@sa),len(sa))
end function

'':::::
function hReceive( byval s as SOCKET, byval buffer as zstring ptr, byval bytes as integer ) as integer

    function = recv( s, buffer, bytes, 0 )
    
end function

'':::::
function hReceiveUDP( s as SOCKET,  byref pIP as long, byref pPORT as long , buffer as zstring ptr, bytes as long ) as integer    
  dim sa as sockaddr_in
  dim as integer cliAddrLen=sizeof(sockaddr_in)
  function = RecvFrom(s,buffer,bytes,null,cast(any ptr,@sa),@cliAddrLen)
  pIP = sa.sin_addr.S_addr
  pPORT = htons(sa.sin_port)  
end function

'':::::
function hIPtoString( byval ip as integer ) as string
	dim ia as in_addr	
	ia.S_addr = ip	
	return  *inet_ntoa( ia )
end function

function hSelect( s as SOCKET, CheckForWrite as integer = 0 ) as integer
  dim as timeval tTimeOut = type(0,0)
  type fd_set2
    fd_count as uinteger
    fd_sock as socket
  end type
  if CheckForWrite then
    dim as fd_set2 WriteSock = type(1,s)
    return select_(null,null,cast(any ptr,@WriteSock),null,@tTimeout)
  else
    dim as fd_set2 ReadSock = type(1,s)
    return select_(null,cast(any ptr,@ReadSock),null,null,@tTimeout)
  end if
end function

