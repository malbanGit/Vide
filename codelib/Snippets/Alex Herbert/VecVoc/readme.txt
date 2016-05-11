=================================
=                               =
= VecVox Driver                 =
=                               =
= by Alex Herbert (c) 2002/2004 =
=                               =
=================================



Files included in this Zip:
--------------------------

README.TXT - This file!

VECVOX.I - VecVox driver include file

SER_JI.I - Serial port driver include file (used by VECVOX.I)

VOX_DEMO.S - Simple demo/example source

VOX_DEMO.BIN - Demo binary


The above source/include files are compatible with AS09.




Using the VecVox driver in your own programs:
--------------------------------------------

Include "VECVOX.I".

Call vox_init once at the start of your code.

Call vox_speak in the main loop.  For best results call vox_speak immediately
after reading the joystick buttons with INPUT or read_switches2 (depending
on which naming convention you use).

Speech is then initiated by setting the speech pointer variable (vox_addr)
to the address of your speech string.

For example:

        ldd     #address_of_speech_string
        std     vox_addr

Speech strings should be terminated with VOX_TERM ($ff).

See source/include files for more detail.




Contact:
-------

Alex Herbert (author of the driver)
        email: herbs64@yahoo.co.uk
        web: www.herbs64.com

Richard Hutchinson (creator of the VecVox hardware/firmware)
        email: richard.hutchinson@dsl.pipex.com
        web: www.vectrex.biz



