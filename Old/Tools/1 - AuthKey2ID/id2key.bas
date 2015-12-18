function intToStr(n as integer) as string
    //psudo code
    int index = 0
    string nstr = (string)n
    string result
    for(int i = 0; i < nstr.length(); i++)
        index = (int)floor(n/((nstr.length()-(i+1))^32) % 32
        result = result + //Function to get char from ascii number <index>
    next i
    return result
end function