const PI = atn(1)*4

enum TroopAction
    idle
    travel
    turn
end enum

type Troop
    as TroopAction action
    as single x,y,vel
    as single speed
    as single size
    as single angle,theta
    as single turnSpeed,moveSpeed
    as double timeSinceLastIdleMove
    as single targetAngle
    
    as ubyte team
    
    declare constructor()
    
    declare sub update()
    declare sub render()
    declare sub turnRight()
    declare sub turnLeft()
    declare sub moveForward()
    declare sub moveBackward()
    declare sub turnTo(angle as single)
    declare sub turnTo(x as single, y as single)
end type

constructor Troop()
    action = TroopAction.idle
    size = 50
    angle = 90
    theta = angle*PI/180
    turnSpeed = 0.2
    moveSpeed = 0.2
    
    timeSinceLastIdleMove = timer()
end constructor

sub Troop.update()
    with this
        select case .action
        case TroopAction.idle
        case TroopAction.travel
        case TroopAction.turn
            if(.angle > 360/2) then
                '.turnRight()
            else
                '.turnLeft()
            end if
        end select
    end with
end sub

sub Troop.render()
    with this
        circle(.x,.y),.size,rgb(100,100,200)
        line(.x,.y)-(.x+.size*cos(.theta),.y-.size*sin(.theta)),rgb(200,100,100)
    end with
end sub

sub Troop.turnRight()
    with this
        .angle-=.turnSpeed
        if(.angle<0) then .angle+=360
        .theta = .angle*pi/180
    end with
end sub

sub Troop.turnLeft()
    with this
        .angle+=.turnSpeed
        if(.angle>360) then .angle-=360
        .theta = .angle*pi/180
    end with
end sub

sub Troop.moveForward()
    with this
        .x+=.moveSpeed*cos(.theta)
        .y-=.moveSpeed*sin(.theta)
    end with
end sub

sub Troop.moveBackward()
'    x-=vel*cos(-theta)
'    y-=vel*sin(-theta)
end sub

sub Troop.turnTo(angle as single)
    with this
        .action = TroopAction.turn
        .targetAngle = angle
    end with
end sub

sub Troop.turnTo(x as single, y as single)
    with this
        .action = TroopAction.turn
        dim as single tempTargetAngle = -atan2(y-.y,x-.x)*180/pi
        if(tempTargetAngle < 0) then
            targetAngle = 360-tempTargetAngle
        else
            targetAngle = tempTargetAngle
        end if
    end with
end sub


