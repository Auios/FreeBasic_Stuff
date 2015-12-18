sub renderMap()
    with mp
        if .rdy = 1 then
            for x as integer = lbound(mp.ID,1) to ubound(mp.ID,1)
                for y as integer = lbound(mp.ID,2) to ubound(mp.ID,2)
                    select case .ID(x,y)
                    case 0
                        locate(y,x):print " "
                    case 1
                        locate(y,x):print "."
                    case 2
                        locate(y,x):print chr(178)
                    case 3
                        locate(y,x):print chr(2)
                    end select
                next y
            next x
        else
            
            print "Need to download map first"
        end if
    end with
end sub