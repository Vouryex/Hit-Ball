TITLE HITBALL (EXE)
.MODEL SMALL
.STACK 200H
;-----------------------------------
.DATA
  HOME_FILE DB 'hb-menu.txt', 00H
  HOWTO_FILE DB 'how.txt', 00H
  ERROR_STR DB "Error!$"
  FILE_HANDLE DW ?
  FILE_BUFFER DB 1896 DUP('$')
  ARROW	      DB	  175, '$'

  PLAYER_HEAD DB  "O$"
  PLAYER_BODY DB "-|-$"
  PLAYER_FEET DB "/ \$"

  PLAYER1_HEAD_ROW DB 22
  PLAYER1_HEAD_COL DB 38
  PLAYER1_BODY_ROW DB 23
  PLAYER1_BODY_COL DB 37
  PLAYER1_FEET_ROW DB 24
  PLAYER1_FEET_COL DB 37

  PLAYER2_HEAD_ROW DB 00
  PLAYER2_HEAD_COL DB 38
  PLAYER2_BODY_ROW DB 01
  PLAYER2_BODY_COL DB 37
  PLAYER2_FEET_ROW DB 02
  PLAYER2_FEET_COL DB 37

  ROW		      DB		0
  COL		      DB		0
  SPACE   		DB   " $" 
;-----------------------------------
.CODE
MAIN PROC FAR
  MOV AX, @data
  MOV DS, AX
  MOV ES, AX

INIT_HOME:
  CALL INIT_HOME_STR

MENU:
  CALL DISP_HOME

GAME:
  CALL PLAY

EXIT:
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
;-----------------------------------
INIT_HOME_STR PROC NEAR
OPEN_HOME_FILE:
  LEA DX, HOME_FILE
  CALL FILE_READ

RETURN:
  RET
INIT_HOME_STR ENDP
;-----------------------------------
DISP_HOME PROC NEAR 

HOME_COLOR:
   CALL SET_HOME_COLOR

HOME_POS:
   MOV DX, 0100H
     PUSH DX
   CALL SET_HOME_POS

DISPLAY_HOME: 
  LEA DX, FILE_BUFFER
  MOV AH, 09
  INT 21H

  MOV COL, 13
  MOV ROW, 23

  CALL SET_CURS

  MOV AH, 09H
  LEA DX, ARROW
  INT 21H

  CHOOSE:		
				      MOV			AH, 00H		;get input
							INT			16H
							CMP 		AL, 0DH 	;ENTER
							JE			CHOICE
							CMP			AH, 4BH		;LEFT
							JE			LEFT
							CMP			AH, 4DH		;RIGHT
							JE			RIGHT

							JMP			CHOOSE

				RIGHT:		
				      ;CALL    BEEP_1
				      CMP			COL, 47		;IF RIGHT KEY
							JE			CHOOSE
							CALL		SET_CURS
							MOV AH, 09H
  							LEA DX, SPACE
  							INT 21H
							;CALL 		DISPLAY
							ADD			COL, 17
							CALL		SET_CURS
							MOV AH, 09H
  							LEA DX, ARROW
  							INT 21H
  							JMP			CHOOSE

				LEFT:	
				      ;CALL    BEEP_1	
				      CMP			COL, 13 	;IF LEFT KEY
							JE			CHOOSE
							CALL		SET_CURS
							MOV AH, 09H
  							LEA DX, SPACE
  							INT 21H
							;CALL 		DISPLAY
							SUB			COL, 17
							CALL		SET_CURS
							MOV AH, 09H
  							LEA DX, ARROW
  							INT 21H
  							JMP			CHOOSE
  				CHOICE:		
				      CMP 		COL, 13		;START GAME
							JE			PLAY_GAME
							CMP 		COL, 30
							JE			HOW_PG
							CMP 		COL, 47
							JE			FIN
							JMP 		CHOOSE
				HOW_PG:		
              		CALL    DISP_HOWTO
				FIN:		
				      ;CALL    BEEP_2
				      CALL		EXIT	;EXIT GAME
				      RET

IS_ENTER:
  ;MOV AH, 10H
    ;INT 16H
    ;CMP AL, 0DH
    JE PLAY_GAME
    JMP IS_ENTER

PLAY_GAME:
  RET
DISP_HOME ENDP
;-------------------------------------
SET_HOME_COLOR PROC NEAR      
  MOV AX, 0600H
  MOV BH, 01H
  MOV CX, 0000H
  MOV DX, 184FH
  INT 10H
  RET
SET_HOME_COLOR ENDP
;-------------------------------------
SET_HOME_POS PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, 00   
  MOV DL, 00   
  INT 10H

  RET
SET_HOME_POS ENDP
;-------------------------------------
PLAY PROC NEAR
CLEAR:
	CALL SET_BALL_COLOR

PLAYER1_COLOR:
	CALL SET_PLAYER1_COLOR

PLAYER1_HEAD_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER1_HEAD

DISPLAY_PLAYER1_HEAD:
	LEA DX, PLAYER_HEAD
  	MOV AH, 09
  	INT 21H

PLAYER1_BODY_POSITION:
	MOV DX, 0100H
	PUSH DX
	CALL SET_PLAYER1_BODY

DISPLAY_PLAYER1_BODY:
	LEA DX, PLAYER_BODY
  	MOV AH, 09
  	INT 21H

PLAYER1_FEET_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER1_FEET

DISPLAY_PLAYER1_FEET:
  	LEA DX, PLAYER_FEET
  	MOV AH, 09
  	INT 21H

PLAYER2_COLOR:
  	CALL SET_PLAYER2_COLOR

PLAYER2_HEAD_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER2_HEAD

DISPLAY_PLAYER2_HEAD:
  	LEA DX, PLAYER_HEAD
  	MOV AH, 09
  	INT 21H

PLAYER2_BODY_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER2_BODY

DISPLAY_PLAYER2_BODY:
  	LEA DX, PLAYER_BODY
  	MOV AH, 09
  	INT 21H

PLAYER2_FEET_POSITION:
    MOV DX, 0100H
    PUSH DX
    CALL SET_PLAYER2_FEET

DISPLAY_PLAYER2_FEET:
  LEA DX, PLAYER_FEET
  MOV AH, 09
  INT 21H

  RET
PLAY ENDP
;---------------------------------------------
SET_BALL_COLOR PROC NEAR
  MOV AX, 0600H   
  MOV BH, 03H     
  MOV CX, 0000H   
  MOV DX, 184FH   
  INT 10H

  RET
SET_BALL_COLOR ENDP
;---------------------------------------------
SET_PLAYER1_COLOR PROC NEAR
  MOV AX, 0600H   
  MOV BH, 01H     
  MOV CX, 1600H   
  MOV DX, 184FH   
  INT 10H

  RET
SET_PLAYER1_COLOR ENDP
;---------------------------------------------
SET_PLAYER1_HEAD PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER1_HEAD_ROW   
  MOV DL, PLAYER1_HEAD_COL   
  INT 10H

  RET
SET_PLAYER1_HEAD ENDP
;---------------------------------------------
SET_PLAYER1_BODY PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER1_BODY_ROW   
  MOV DL, PLAYER1_BODY_COL   
  INT 10H

  RET
SET_PLAYER1_BODY ENDP
;---------------------------------------------
SET_PLAYER1_FEET PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER1_FEET_ROW   
  MOV DL, PLAYER1_FEET_COL   
  INT 10H

  RET
SET_PLAYER1_FEET ENDP
;---------------------------------------------
SET_PLAYER2_COLOR PROC NEAR
  MOV AX, 0600H   
  MOV BH, 04H     
  MOV CX, 0000H   
  MOV DX, 034FH   
  INT 10H

  RET
SET_PLAYER2_COLOR ENDP
;---------------------------------------------
SET_PLAYER2_HEAD PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER2_HEAD_ROW   
  MOV DL, PLAYER2_HEAD_COL   
  INT 10H

  RET
SET_PLAYER2_HEAD ENDP
;---------------------------------------------
SET_PLAYER2_BODY PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER2_BODY_ROW   
  MOV DL, PLAYER2_BODY_COL   
  INT 10H

  RET
SET_PLAYER2_BODY ENDP
;---------------------------------------------
SET_PLAYER2_FEET PROC NEAR
  POP BX
  POP DX
  PUSH BX
  MOV AH, 02H   
  MOV BH, 00    
  MOV DH, PLAYER2_FEET_ROW   
  MOV DL, PLAYER2_FEET_COL   
  INT 10H

  RET
SET_PLAYER2_FEET ENDP
;---------------------------------------------
SET_CURS 			PROC		NEAR
							MOV			AH, 02H
							MOV			BH, 00
							MOV			DH, ROW
							MOV			DL, COL
							INT			10H
							RET
SET_CURS 			ENDP
RET
;---------------------------------------------
DISP_HOWTO		PROC		NEAR
							MOV 		ROW, 0
							MOV 		COL, 0
							CALL 		SET_CURS
							CALL		CLS
							LEA			DX, HOWTO_FILE
							CALL FILE_READ
							MOV			AH, 00H		;get any key input
							INT			16H
							CALL    DISP_HOME
							RET

DISP_HOWTO		ENDP
;--------------------------------------------
FILE_READ			PROC		NEAR
							MOV			AX, 3D02H											;OPEN FILE
							INT			21H
							JC			_ERROR
							MOV			FILE_HANDLE, AX
							
							MOV			AH, 3FH												;READ FILE
							MOV			BX, FILE_HANDLE
							MOV			CX, 1896
							LEA			DX, FILE_BUFFER
							INT			21H
							JC			_ERROR
							
							MOV			DX, 0500H											;DISPLAY FILE
							CALL 		SET_CURS
							LEA			DX, FILE_BUFFER
						  	MOV AH, 09
						  	INT 21H

							MOV 		AH, 3EH         							;CLOSE FILE
							MOV 		BX, FILE_HANDLE
							INT 		21H
							JC 			_ERROR

							RET

			 _ERROR:		
			        LEA			DX, ERROR_STR									;ERROR IN FILE OPERATION
  					MOV AH, 09
  					INT 21H
							RET
				BK:			
				      RET
FILE_READ			ENDP
;---------------------------------------------
CLS 					PROC		NEAR			
							MOV			AX, 0600H
							MOV			BH, 01H
							MOV			CX, 0000H
							MOV			DX, 184FH
							INT			10H
							RET
CLS 					ENDP
END MAIN