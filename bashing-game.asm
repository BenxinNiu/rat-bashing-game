.INCLUDE "M32DEF.INC"

LDI R17, LOW(RAMEND) 
OUT SPL, R17
LDI R17,HIGH(RAMEND)
OUT SPH,R17


LDI R17, 0x00
SER R17
OUT DDRD, R17 
CLR R17 
OUT DDRB, R17


; MAIN FUNCTION 
LDI ZL,LOW(DATA<<1) 
LDI ZH,HIGH(DATA<<1)
LDI R25, 0
LDI R28,1
CALL DISPLAYRAT

END: RJMP END






; SUBROUNTINES

DISPLAYRAT:
		CALL START     ; flash 3 times 
		;CALL SUPERDELAY ; wait 1 sec
		LDI R19,8    	 ; 8 round for iterision
		LDI R23, 0x00    ; input value for comparision 
NEXT:	LPM R16, Z+      ; load value from z register       
		OUT PORTD, R16   ; display rat
		CALL DELAY       
		CALL HAMMERWAIT   ; wait for user
        SUB R23, R16     ; see if user has hit the correct rat
		BRNE NOTHING     ; if not jump to nothing 
		PUSH R28 
		INC R25          ; how many rats were hit 
		;PUSH R16         ; store the rat on stck 
		CLR R23          ; clear r23
      ; flash 3 times to inidicate that the rat has been hit
	    CALL START
NOTHING:INC R28            ; UPDATE ROUND 
		DEC R19        
		BRNE NEXT      ; start next round
        SER R17         
		OUT PORTD, R17  ; turn off all leds 
		CALL DELAY
		CALL SHOWSCORE   ; show the score 
STOP:   RJMP STOP
		RET


HAMMERWAIT:
    	CALL DELAY
		CALL DELAY
		IN R23, PINB
		RET

START: LDI R18,3 
AGAIN: OUT PORTD, R17
       CALL DELAY
	   SER R17
	   OUT PORTD, R17
	   CALL DELAY
	   CLR R17 
	   DEC R18
	   BRNE AGAIN
	   RET

SHOWSCORE: 

SHOW:	
		LDI R27,0x00
        POP R26
		POP R26
		LDI R28, 8
		CP R28,R25
		BRNE MORE
		RJMP ALLHIT


MORE:   LDI R16,1    ; register for comparison 
		LDI R17,2
		LDI R18,3
		LDI R19,4 
		LDI R20,5
		LDI R21,6
		LDI R22,7
		LDI R23,8
		POP R26

ONE:	CP R16,R26  ; check if first round were hit 
		BRNE TWO
		LDI R16,0x01
		ADD R27,R16
		RJMP UPDATE

TWO:	CP R17,R26   ; check if 2 round were hit 
		BRNE THREE
		LDI R17,0x02
		ADD R27,R17
		RJMP UPDATE

THREE:	CP R18,R26   ; check if 3 round were hit 
		BRNE FOUR
		LDI R18,0x04
		ADD R27,R18
		RJMP UPDATE

FOUR:	CP R19,R26    ; check if 4 round were hit 
		BRNE FIVE
		LDI R19,0x08
		ADD R27,R19
		RJMP UPDATE

FIVE:	CP R20,R26   ; check if 5 round were hit 
		BRNE SIX
		LDI R20,0x10
		ADD R27,R20
		RJMP UPDATE

SIX:	CP R21,R26   ; check if 6 round were hit 
		BRNE SEVEN
		LDI R21,0x20
		ADD R27,R21
		RJMP UPDATE

SEVEN:	CP R22,R26   ; check if 7 round were hit 
		BRNE EIGHT
		LDI R22,0x40
		ADD R27,R22
		RJMP UPDATE

EIGHT:	CP R23,R26   ; check if 8 round were hit 
		BRNE EIGHT
		LDI R23,0x80
		ADD R27,R23
		RJMP UPDATE

UPDATE:	DEC R25       ; check next successful round  
		BRNE MORE
		LDI R28, 0xFF 
		EOR R27,R28
		OUT PORTD, R27
GG:     RJMP GG

ALLHIT: CALL START
		CALL START ; FLASH 6 TIMES TO INDICATE ALL RATS WERE HIT 
		RJMP GG
		RET
       

DELAY: LDI R20, 0x04
LOOP1: LDI R21, 0xAF
LOOP2: LDI R22, 0xAF
LOOP3: DEC R22
	   BRNE LOOP3
	   DEC R21
	   BRNE LOOP2
	   DEC R20 
	   BRNE LOOP1
	   RET

SUPERDELAY: 
       CALL DELAY 
	   CALL DELAY
	   CALL DELAY
	   CALL DELAY
	   CALL DELAY
	   RET

DATA: .DB 0xFD,0xEF,0xFB,0x7F,0xBF,0x7F,0xFE,0xBF
