        ;; Test ACALL and AJMP range

        .area   test (ABS,OVR)
back1:  .ds     2046
        ajmp    back1           ; Should fail at link time

        .org    4*1024
back2:  .ds     2047
        ajmp    back2           ; Should fail at link time

        .org    6*1024
        .ds     2046
        ajmp    forward1
forward1:

	.org	8*1024
	.ds	2046
	ajmp	forward2

	.org	12*1024 - 1
forward2:

	.org	12*1024
	.ds	2046
	ajmp	forward3	; Should fail at link time

	.org	16*1024
forward3:

 