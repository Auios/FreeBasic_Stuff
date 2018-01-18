type car
    as string model
    as integer kilometers
end type

#macro DeclareList(_T)
type _T##List
    as integer count
    as _T ptr n
end type
#endMacro

DeclareList(car)

dim as carList cars
cars.count = 5
cars.n = new car[cars.count]

print cars.count
sleep()

delete[] cars.n