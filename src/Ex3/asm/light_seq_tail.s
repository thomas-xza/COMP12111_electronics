

	done    JMP flash_130         ; Just in case stop instr fails


test	DEFW &FFFF
	
one     DEFW 1           ; one
max	DEFW &7FFF	 ; max ?
neg     DEFW &8000       ; -max
zero    DEFW &0000       ; zero
delay	DEFW &000F	 ; 16
	
delay_1 DEFW &2ABD
delay_2 DEFW &38FF
delay_max DEFW &7FFF

m_pattern_a DEFW &00ED
m_pattern_b DEFW &00DB

traffic DEFW &0FFF
