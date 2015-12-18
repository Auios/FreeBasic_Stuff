
#include once "mysql\mysql.bi"
#define NULL 0  
   
   dim conn as MYSQL ptr
   dim res as MYSQL_RES ptr
   dim row as MYSQL_ROW ptr
   
   dim server as zstring ptr
   dim user as zstring ptr
   dim password as zstring ptr
   dim database as zstring ptr
   
   *server = "IKE.db.6891333.hostedresource.com"
   *user = "IKE"
   *database = "IKETEST"
   *password = "IKE@2013"
   
   conn = mysql_init(NULL)

   'if( mysql_real_connect( conn, server, user, password, database, MYSQL_PORT, NULL, 0 ) = 0 ) then
   if( mysql_real_connect( conn, server, user, password, database, 0, NULL, 0 ) = 0 ) then
   
        print *mysql_error(conn)
        print "Can't connect to the mysql server on port"; MYSQL_PORT
        mysql_close(conn)
        sleep
        end 1
    end if
   
   if (mysql_query(conn, "show tables") = 0)  then
      print *mysql_error(conn)
      sleep
      end 1
   end if
   
   res = mysql_use_result(conn)
   
   print("MySQL Tables in mysql database:")
   while ((row = mysql_fetch_row(res)) <> NULL)
      print(row[0])
   wend
   
   mysql_free_result(res)
   mysql_close(conn)

 