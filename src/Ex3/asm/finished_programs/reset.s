

	ORG  0

	 ;; Reset all the lights to off.
	
	STA &FFFF
	STA &0FFF
	STA &0FFA
	STA &0FF9
	STA &0FF8
	STA &0FF7
	STA &0FF6
	STA &0FF5
	STA &0FFF		;  store to memory &0FFF


	stop    STP              ; STOP - HALT progr

	done    JMP done         ; Just in case stop instr fails


test	DEFW &FFFF
	
one     DEFW 1           ; one
max	DEFW &7FFF	 ; max ?
neg     DEFW &8000       ; -max
zero    DEFW &0000       ; zero
delay	DEFW &000F	 ; 16
	
delay_1 DEFW &2ABD
delay_2 DEFW &38FF
delay_max DEFW &7FFF

traffic DEFW &0FFF
