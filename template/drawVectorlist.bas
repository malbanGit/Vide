' draw one vectorlist

textSize = {40, 5}
instructions = {{-50, 90, "DISPLAY VECTORLIST"}}


call IntensitySprite(50)

// OK
call ScaleSprite(25)
vListSprite=LinesSprite(getVectorList())

call TextSizeSprite(textSize)
call TextListSprite(instructions)


while true
    controls = WaitForFrame(JoystickNone, JoystickNone, JoystickNone)
endwhile

