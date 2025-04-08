; new list object to U
; leaves with flags set to result
; (positive = not successfull) ROM
; negative = successfull RAM
; destroys d, u 
newObject                                                 ;#isfunction  
                    ldu      objectlist_empty_head 
                    cmpu     #OBJECT_LIST_COMPARE_ADDRESS 
                    bls      cs_done_newObject 
                                                          ; set the new empty head 
                    ldd      NEXT_OBJECT,u          ; the next in out empty list will be the new 
                    std      objectlist_empty_head        ; head of our empty list 
                                                          ; load last of current object list 
; the old head is always our next
                    ldd      objectlist_used_head 
                    std      NEXT_OBJECT,u 
; newobject is always head
                    stu      objectlist_used_head 
                    inc      objectCount                  ; and remember that we created a new object 
                    rts      
cs_done_newObject 
                    rts      


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; removes object from list
; object to be removed in X 
; destroys u, D
removeObject                                              ;#isfunction  
; we must keep DS intackt in this remove -> use y register instead
                    cmpx     objectlist_used_head         ; is it the first? 
                    bne      was_not_first_object         ; no -> jump 
was_first_object 
                    ldu      NEXT_OBJECT,x                ; y pointer to next objext 
                    stu      objectlist_used_head         ; the next object will be the first 
                    bra      exitRemoveObject 
 
was_not_first_object                                      ;      find previous, go thru all objects from first and look where "I" am the next... 
                    ldu      objectlist_used_head         ; start at list head 
try_next_object 
                    cmpx     NEXT_OBJECT,u                ; am I the next object of the current investigated list element 
                    beq      found_next_switch_object     ; jup -> jump 
                    ldu      NEXT_OBJECT,u                ; otherwise load the next as new current 
                    bra      try_next_object              ; and search further 

found_next_switch_object 
                    ldd      NEXT_OBJECT,x                ; we load "our" next object to d 
                    std      NEXT_OBJECT,u                ; and store our next in the place of our previous next and thus eleminate ourselfs 
exitRemoveObject 
                    dec      objectCount 
                    ldu      objectlist_empty_head        ; set us free, as new free head 
                    stu      NEXT_OBJECT,x                ; load to u the next linked list element 
                    stx      objectlist_empty_head 
                    rts      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; initializes the object list 
; and sets the "return address" to the contents of OBJECTS_DONE
initObjects                                           ;#isfunction  
                    lda      #MAX_OBJECTS 
initObjects_a
                    ldu      #object_list 
initObjects_ua					
                    stu      objectlist_empty_head 
                    ldy      #OBJECTS_DONE 
next_list_entry_initObjects
                    leax     ObjectStruct,u 
                    stx      NEXT_OBJECT,u 
                    leau     ,x 
                    deca     
                    bne      next_list_entry_initObjects
                    leau     -ObjectStruct,u 
                    sty      NEXT_OBJECT,u 
                    sty      objectlist_used_head
                    sta      objectCount 
                    rts      
