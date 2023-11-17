
	;;  Note: commented numbers in hexidecimal.
	
	;; 			  F	DATA  => [ADDR]
	
	ORG 0
	
	STA result1		; 1	0000? => [FFFF]
		
	LDA neg			; 0
	STA result2		; 1	8000* => [0000]
	
	ADD neg			; 2	8000
	STA result3		; 1	0000* => [FFFF]
	
	SUB one			; 3	1
	STA result4		; 1	FFFF* => [0000]

	JMP jmp1ok		; 4
	LDA jmperr1		; 0	FA01
	STA result5		; 1	FA01  => [1A55]
	
jmp1ok	LDA one			; 0	1
	JNE jmp2ok		; 6	
	
	LDA jmperr2		; 0	FA02
	STA result6		; 1	FA02  => [0000]
	JMP fail1		; 4

jmp2ok	LDA pass1		; 0	1A55
	STA result6		; 1	1A55* => [0000]

fail1	LDA zero		; 0	0000
	JNE fail2		; 6
	JMP jmp3ok		; 4

fail2	LDA jmperr3		; 0
	STA result7		; 1	????  => [0000]
	JMP stop		; 4

jmp3ok	LDA pass1		; 0	1A55
	STA result7		; 1	1A55* => [0000]

stop	STP			; 7
done	JMP done		; 4

one	DEFW 1
neg	DEFW &8000
zero 	DEFW &0000
	
jmperr1	DEFW &FA01
jmperr2 DEFW &FA02
jmperr3 DEFW &FA03
	
pass1	DEFW &1A55
	
result1 DEFW &FFFF
result2 DEFW &0000
result3 DEFW &FFFF
result4 DEFW &0000
result5 DEFW &1A55
result6 DEFW &0000
result7 DEFW &0000

