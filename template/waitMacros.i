; PC not usable :-)
; cmpx #4
; pshs d,y,x,pc,u,cc;16
; puls d,y,x,pc,u,cc; 16
; pshs y,x,pc,u,d;15
; puls y,x,pc,u,d; 15
; pshs y,x,pc,u,cc;14
; puls y,x,pc,u,cc; 14
; pshs a,x,pc,u,cc;13
; puls a,x,pc,u,cc;13
; pshs x,pc,u,cc;12
; puls x,pc,u,cc;12
; pshs pc,u,d;11
; puls pc,u,d;11
; pshs pc,u,cc;10
; puls pc,u,cc;10
; pshs u,d;9
; puls u,d;9
; pshs u,cc;8
; puls u,cc;8
; pshs u;7
; puls u;7
; pshs cc;6
; puls cc;6
; tfr a,a; 6
; brn 0; 3
; NOP ; 2
;the "massive" stack usage is forbidden -> since stack is rare and
;can overwrite data
;
WAIT2               macro    
                    nop                                   ; wait 2 cycles 
                    endm     
WAIT3               macro    
                    brn      0                            ; wait 3 cycles 
                    endm     
WAIT4               macro    
                    WAIT2    
                    WAIT2    
                    endm     
WAIT5               macro    
                    WAIT3    
                    WAIT2    
                    endm     
WAIT6               macro    
                    tfr      a,a                          ; wait 6 cycles 
                    endm     
WAIT7               macro    
                    WAIT5    
                    WAIT2    
                    endm     
WAIT8               macro    
                    WAIT6    
                    WAIT2    
                    endm     
WAIT9               macro    
                    WAIT6    
                    WAIT3    
                    endm     
WAIT10              macro    
                    WAIT6    
                    WAIT4    
                    endm     
WAIT11              macro    
                    WAIT8    
                    WAIT3    
                    endm     
WAIT12              macro    
                    pshs     cc                           ; wait 12 cycles 
                    puls     cc 
                    endm     
WAIT13              macro    
                    WAIT11   
                    WAIT2    
                    endm     
WAIT14              macro    
                    pshs     u                            ; wait 14 cycles 
                    puls     u 
                    endm     
WAIT15              macro    
                    WAIT12   
                    WAIT3    
                    endm     
WAIT16              macro    
                    pshs     u,cc                         ; wait 16 cycles 
                    puls     u,cc 
                    endm     
WAIT17              macro    
                    WAIT14   
                    WAIT3    
                    endm     
WAIT18              macro    
                    WAIT16                                ; wait 18 cycles 
                    WAIT2    
                    endm     
WAIT19              macro    
                    WAIT16   
                    WAIT3    
                    endm     
WAIT20              macro    
                    WAIT16                                ; wait 20 cycles 
                    WAIT4    
                    endm     
WAIT21              macro    
                    WAIT16   
                    WAIT5    
                    endm     
WAIT22              macro    
                    WAIT16                                ; wait 22 cycles 
                    WAIT6    
                    endm     
WAIT23              macro    
                    WAIT20   
                    WAIT3    
                    endm     
WAIT24              macro    
                    WAIT16                                ; wait 24 cycles 
                    WAIT6    
                    WAIT2    
                    endm     
WAIT25              macro    
                    WAIT22   
                    WAIT3    
                    endm     
WAIT26              macro    
                    WAIT20                                ; wait 26 cycles 
                    WAIT6    
                    endm     
WAIT27              macro    
                    WAIT24   
                    WAIT3    
                    endm     
WAIT28              macro    
                    WAIT22                                ; wait 28 cycles 
                    WAIT6    
                    endm     
WAIT29              macro    
                    WAIT26   
                    WAIT3    
                    endm     
WAIT30              macro    
                    WAIT28   
                    WAIT2    
                    endm     
WAIT31              macro    
                    WAIT28   
                    WAIT3    
                    endm     
WAIT32              macro    
                    WAIT16   
                    WAIT16   
                    endm     
WAIT33              macro    
                    WAIT30   
                    WAIT3    
                    endm     
WAIT34              macro    
                    WAIT32   
                    WAIT2    
                    endm     
WAIT35              macro    
                    WAIT32   
                    WAIT3    
                    endm     
WAIT36              macro    
                    WAIT32   
                    WAIT4    
                    endm     
WAIT37              macro    
                    WAIT32   
                    WAIT5    
                    endm     
WAIT38              macro    
                    WAIT32   
                    WAIT6    
                    endm     
WAIT39              macro    
                    WAIT32   
                    WAIT7    
                    endm     
WAIT40              macro    
                    WAIT32   
                    WAIT8    
                    endm     
WAIT41              macro    
                    WAIT32   
                    WAIT9    
                    endm     
WAIT42              macro    
                    WAIT16   
                    WAIT16   
                    WAIT10   
                    endm     
WAIT43              macro    
                    WAIT32   
                    WAIT11   
                    endm     
WAIT44              macro    
                    WAIT32   
                    WAIT12   
                    endm     
WAIT45              macro    
                    WAIT32   
                    WAIT13   
                    endm     
WAIT46              macro    
                    WAIT32   
                    WAIT14   
                    endm     
WAIT47              macro    
                    WAIT32   
                    WAIT15   
                    endm     
WAIT48              macro    
                    WAIT32   
                    WAIT16   
                    endm     
WAIT49              macro    
                    WAIT32   
                    WAIT17   
                    endm     
WAIT50              macro    
                    WAIT32   
                    WAIT18   
                    endm     
WAIT51              macro    
                    WAIT32   
                    WAIT19   
                    endm     
WAIT52              macro    
                    WAIT32   
                    WAIT20   
                    endm     
WAIT53              macro    
                    WAIT32   
                    WAIT21   
                    endm     
WAIT54              macro    
                    WAIT32   
                    WAIT22   
                    endm     
WAIT55              macro    
                    WAIT32   
                    WAIT23   
                    endm     
WAIT56              macro    
                    WAIT32   
                    WAIT24   
                    endm     
WAIT57              macro    
                    WAIT32   
                    WAIT25   
                    endm     
WAIT58              macro    
                    WAIT32   
                    WAIT26   
                    endm     
WAIT59              macro    
                    WAIT32   
                    WAIT27   
                    endm     
WAIT60              macro    
                    WAIT32   
                    WAIT28   
                    endm     
WAIT61              macro    
                    WAIT32   
                    WAIT29   
                    endm     
WAIT62              macro    
                    WAIT32   
                    WAIT30   
                    endm     
WAIT63              macro    
                    WAIT32   
                    WAIT31   
                    endm     
WAIT64              macro    
                    WAIT32   
                    WAIT32   
                    endm     
WAIT65              macro    
                    WAIT32   
                    WAIT33   
                    endm     
WAIT66              macro    
                    WAIT32   
                    WAIT34   
                    endm     
WAIT67              macro    
                    WAIT32   
                    WAIT35   
                    endm     
WAIT68              macro    
                    WAIT32   
                    WAIT36   
                    endm     
WAIT69              macro    
                    WAIT32   
                    WAIT37   
                    endm     
WAIT70              macro    
                    WAIT32   
                    WAIT38   
                    endm     
WAIT71              macro    
                    WAIT32   
                    WAIT39   
                    endm     
WAIT72              macro    
                    WAIT32   
                    WAIT40   
                    endm     
WAIT73              macro    
                    WAIT32   
                    WAIT41   
                    endm     
WAIT74              macro    
                    WAIT32   
                    WAIT42   
                    endm     
WAIT75              macro    
                    WAIT32   
                    WAIT43   
                    endm     
WAIT76              macro    
                    WAIT32   
                    WAIT44   
                    endm     
WAIT77              macro    
                    WAIT32   
                    WAIT45   
                    endm     
WAIT78              macro    
                    WAIT32   
                    WAIT46   
                    endm     
WAIT79              macro    
                    WAIT32   
                    WAIT47   
                    endm     
WAIT80              macro    
                    WAIT32   
                    WAIT48   
                    endm     
