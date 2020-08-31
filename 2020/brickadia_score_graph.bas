#include "mysql_database.bi"

sub plot(max_score as uinteger, max_count as uinteger, score as uinteger, count as uinteger)
    circle(200+score/max_score * 400, 450-count/max_count*200), 1,,,,, f
end sub

dim as mysql_database brdb

screenres(800, 600, 32, 1, 0)

print("Connecting to database...")
if(brdb.connect("auios.x10host.com", "auiosx10_Admin", "Aduioa", "auiosx10_brickadia_dev")) then
    print("Failed to connect to database!")
    brdb.close()
else
    print("Connected!")
end if

dim as uinteger max_score
dim as uinteger max_count

brdb.query("SELECT play_time_points max_score, COUNT(*) max_count FROM auiosx10_brickadia_dev.usernames GROUP BY max_score ORDER BY max_score DESC LIMIT 1")
brdb.get_row()
max_score = val(brdb.get_item(0))

brdb.query("SELECT play_time_points max_score, COUNT(*) max_count FROM auiosx10_brickadia_dev.usernames GROUP BY max_score ORDER BY max_count DESC LIMIT 1")
brdb.get_row()
max_count = val(brdb.get_item(1))

brdb.query("SELECT play_time_points, COUNT(*) FROM auiosx10_brickadia_dev.usernames GROUP BY play_time_points")
while(brdb.get_row())
    dim as uinteger score = val(brdb.get_item(0))
    dim as uinteger count = val(brdb.get_item(1))
    plot(max_score, max_count, score, count)
wend

sleep()

print("Disconnecting from database...")
brdb.close()
print("Disconnected!")