

	ORG  0

	 ;; Reset all the lights to off.
	
	STA &FFFF
	STA &0FFF
	;; STA &0FFA
	;; STA &0FF9
	;; STA &0FF8
	;; STA &0FF7
	;; STA &0FF6
	;; STA &0FF5


	;; ADD max			;  add max to ACC
	;; STA &0FFF		;  store to memory &FF0
	
	
	;; ADD max		;       Test store to memory

	;; STA &0FFA
	;; STA &0FF9
	;; STA &0FF8
	;; STA &0FF7
	;; STA &0FF6
	;; STA &0FF5
	;; ;; STA &0FF4

	;; SUB max

	;; STA &0FFF

	;; ADD traffics_on
	;; ;; ADD &07FF
	;; STA &0FFF


flash_4

	ADD max			;  add max to ACC
	STA &0FFF		;  store to memory &0FFF
	
		LDA delay_max
loop_delay_4_0	sub one
		JNE loop_delay_4_0
	
			LDA delay_max
loop_delay_4_1		sub one
			JNE loop_delay_4_0_1
	
	STA &0FFF		;  store to memory &0FFF

			LDA delay_max
loop_delay_4_1		sub one
			JNE loop_delay_4_1
	
			LDA delay_max
loop_delay_4_2		sub one
			JNE loop_delay_4_1_1
	


flash_3

	ADD max			;  add max to ACC
	STA &0FFF		;  store to memory &0FFF
	
		LDA delay_max
loop_delay_3_0	sub one
		JNE loop_delay_3_0
	
	STA &0FFF		;  store to memory &0FFF

		LDA delay_max
loop_delay_3_1	sub one
		JNE loop_delay_3_1
	


	
flash_2

	ADD max			;  add max to ACC
	STA &0FFF		;  store to memory &0FFF
	
		LDA delay_1
loop_delay_2_0	sub one
		JNE loop_delay_2_0
	
	STA &0FFF		;  store to memory &0FFF

		LDA delay_1
loop_delay_2_1	sub one
		JNE loop_delay_2_1


	

flash_1

	ADD max			;  add max to ACC
	STA &0FFF		;  store to memory &0FFF
	
		LDA delay_2
loop_delay_1_0	sub one
		JNE loop_delay_1_0
	
	STA &0FFF		;  store to memory &0FFF

		LDA delay_2
loop_delay_1_1	sub one
		JNE loop_delay_1_1



flash_0

	ADD max			;  add max to ACC
	STA &0FFF		;  store to memory &0FFF
	
		LDA delay_1
loop_delay_0_0	sub one
		JNE loop_delay_0_0
	
	STA &0FFF		;  store to memory &0FFF

		LDA delay_1
loop_delay_0_1	sub one
		JNE loop_delay_0_1
	

	
	JMP flash_0

	
	
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
	
delay_1 DEFW &2ABD
delay_2 DEFW &38FF
delay_max DEFW &7FFF

traffic DEFW &0FFF
