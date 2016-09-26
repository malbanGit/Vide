CALL SetFrameRate(50)

textSize = {40, 5}
instructions = {{-50, 90, "PLAY YM"}}

ymCount = 1
call IntensitySprite(50)


call TextSizeSprite(textSize)
call TextListSprite(instructions)

ym_song_data = initYMData()

Dim regdata[14,2]

FOR reg = 1 TO 14
     regdata[reg,1] = reg-1
NEXT reg

while true
    controls = WaitForFrame(JoystickNone, JoystickNone, JoystickNone)
    FOR reg = 1 TO 14
         regdata[reg,2] = ym_song_data[ymCount,reg]
    NEXT reg
    
    ymCount = (ymCount+1) mod Ubound(ym_song_data,1)   
    if ymCount = 0 then
        ymCount = 1
    endif

    call Sound(regdata)
endwhile

