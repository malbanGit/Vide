; includes for ressources						
BANK_VOZLOGO        equ      1 
BANK_NCELOGO        equ      1 
BANK_PRESENTS       equ      1 
BANK_HAUPTDEMO      equ      1 
BANK_MARCH          equ      1 
BANK_BOUNCE         equ      1 
BANK_TEAPOT         equ      2 
BANK_TEAPOTB        equ      4 
BANK_TWISTER        equ      1 
BANK_DUDEL          equ      1 
BANK_DISCO          equ      0 
BANK_EKG            equ      1 
BANK_AUGE           equ      0 
BANK_BRUCE          equ      1 
BANK_WELT           equ      3 
BANK_GREETINGS      equ      2 
BANK_BATTLE         equ      2 
BANK_CREDITS        equ      2 
BANK_ROADRUNNER     equ      3 
                    if       BANK=BANK_ROADRUNNER 
                    		include  "gen\gfx_thatsall.asm"
                    		include  "resources\roadrunner.asm"
                    endif    
                    if       BANK=BANK_DUDEL 
                    		include  "gen\vid_dudel.asm"
                    endif    
                    if       BANK=BANK_GREETINGS 
                    		include  "resources\font.asm"
                    endif    
                    if       BANK=BANK=BANK_CREDITS 
                    		include  "resources\font.asm"
                    endif    
                    if       BANK=BANK_BATTLE 
                    		include  "gen\vid_batl.asm"
                    endif    
                    if       BANK=BANK_GREETINGS 
                    	        include "resources\greetings.asm"
                    endif    
                    if       BANK=BANK_CREDITS 
                    		include  "resources\credits.asm"
                    endif    
                    if       BANK=BANK_PRESENTS 
                    	        include "gen\vid_pres.asm"
                    endif    
                    if       BANK=BANK_AUGE 
                    		include  "gen\vid_auge.asm"
                    endif    
                    if       BANK=BANK_BRUCE 
                    		include  "gen\vid_bruce.asm"
                    endif    
                    if       BANK=BANK_WELT 
                    		include  "gen\vid_welt.asm"
                    endif    
                    if       BANK=BANK_EKG 
                    		include  "gen\vid_ekg.asm"
                    endif    
                    if       BANK=BANK_TEAPOT 
                    		include  "gen\vid_teapot.asm"
                    endif    
                    if       BANK=BANK_TEAPOTB 
                    		include  "gen\vid_teapotB.asm"
                    endif    
                    if       BANK=BANK_VOZLOGO 
                    		include  "gen\vid_vozlogo.asm"
                    endif    
                    if       BANK=BANK_NCELOGO 
                    		include  "gen\gfxlogo1.asm"
                    endif    
                    if       BANK=BANK_HAUPTDEMO 
                    		include  "gen\gfx_lineart.asm"
                    endif    
                    if       BANK=BANK_MARCH 
                    		include  "gen\vid_mar1.asm"
                    		include  "gen\vid_mar2.asm"
                    		include  "gen\vid_mar3.asm"
                    		include  "gen\vid_mar4.asm"
                    endif    
                    if       BANK=BANK_BOUNCE 
                    		include  "gen\vid_bnc1.asm"
                    		include  "gen\vid_bnc2.asm"
                    		include  "gen\vid_bnc3.asm"
                    endif    
                    if       BANK=BANK_DISCO 
                    		include  "gen\vid_disco.asm"
                    endif    
                                                          ;        snd-env 
                    	include  "music.asm"
                    	include  "snd.asm"       
