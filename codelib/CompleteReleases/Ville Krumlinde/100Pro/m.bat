rem 1=generate listing

if %1.==. (
 as09 -i thrust.asm
) else if %1.==1. (
 as09 -i -l -c -m -h0 thrust.asm
)