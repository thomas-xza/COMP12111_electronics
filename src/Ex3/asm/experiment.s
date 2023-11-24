

	ORG  0

	STA &FFFF
	STA &0FFA
	STA &0FF9
	STA &0FF8
	STA &0FF7
	STA &0FF6
	STA &0FF5

	ADD max		;       Test store to memory
	;; STA  result1	; Store acc into memory loc result1. result1 = 0

	;; ;;        Test load accumulator from memory
	;; LDA  neg	; Acc should be set to 'h8000
	;; STA  result2	; Store value of acc to memory. result2 = 'h8000

	;; ;;        Simple adder overflow test
	;; ADD neg		; Acc should overflow to 0 ('h8000 + 'h8000)
	;; STA  result3	; Store the addition result to memory. result3 = 0

	;; ;;        Simple subtraction test
	;; SUB one		; Acc should be 'hFFFF(0 - 1 = -1)
	;; STA  result4	; Store the subtraction result to memory. result4 = 'hFFFF

	

	;;        Test store to memory
	;; STA  result1	; Store acc into memory loc result1. result1 = 0

	;;        Test load accumulator from memory
	;; STA  result2	; Store value of acc to memory. result2 = 'h8000

	;; ;;        Simple adder overflow test
	;; ADD neg		; Acc should overflow to 0 ('h8000 + 'h8000)
	;; STA  result3	; Store the addition result to memory. result3 = 0

	;; ;;        Simple subtraction test
	;; SUB one		; Acc should be 'hFFFF(0 - 1 = -1)
	;; STA  result4	; Store the subtraction result to memory. result4 = 'hFFFF
	

	

	;; ;;        Simple adder overflow test
	;; ADD neg		; Acc should overflow to 0 ('h8000 + 'h8000)

	;; ;;        Simple subtraction test
	;; SUB one		; Acc should be 'hFFFF(0 - 1 = -1)

	
	STA &0FFA
	STA &0FF9
	STA &0FF8
	STA &0FF7
	STA &0FF6
	STA &0FF5
	;; STA &0FF4

	SUB max


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
	
lights_on	EQU &0001
result1 DEFW &FFFF
result2 DEFW &0000
result3 DEFW &FFFF
result4 DEFW &0000

