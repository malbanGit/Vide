initializeData_bss:
 pshs d, x,u
 ldu #data_to_initialize_bss
 ldx #RAM_to_initialize_start
initializeData_bss_cont:
 ldb ,u+ 
 stb ,x+ 
 cmpx #RAM_to_initialize_end
 bne initializeData_bss_cont


 puls d, x,u, pc