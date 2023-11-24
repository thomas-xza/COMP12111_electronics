

	ORG  0

	;;  Reset all the lights to off.
	
	STA &FFFF
	STA &0FFF
	STA &0FFA
	STA &0FF9
	STA &0FF8
	STA &0FF7
	STA &0FF6
	STA &0FF5

	ADD max		;       Test store to memory

	STA &0FFA
	STA &0FF9
	STA &0FF8
	STA &0FF7
	STA &0FF6
	STA &0FF5
	;; STA &0FF4

	SUB max

	;; STA &0FFF

	ADD traffics_on
	;; ADD &07FF
	STA &0FFF

	
loop	sub one
	ADD max
	STA &0FFF
	JNE loop
	

;; 	LDA delay
	
;; loop	SUB one
	
;; 	JNE loop
	
;; 	JMP main
	


	stop    STP              ; STOP - HALT progr

	done    JMP done         ; Just in case stop instr fails


test	DEFW &FFFF
	
one     DEFW 1           ; one
max	DEFW &7FFF	 ; max ?
neg     DEFW &8000       ; -max
zero    DEFW &0000       ; zero
delay	DEFW &000F	 ; 16
	
letter_f	EQU &0003
digit_5		EQU &0FFA
	
traffics_on	EQU &FFFF
