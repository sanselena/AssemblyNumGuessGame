; ADDITIONAL INFO & REPORT REGARDING THIS PROJECT CAN BE FOUND AT: https://github.com/sanselena/AssemblyNumGuessGame
;23lyaz011 SERENAT VAROL - SOFTWARE ENGINEERING DEPARTMENT

DATA SEGMENT                  ; START of the "Data File Cabinet" section.
    
    ; -------------------------------------------------------------------------
    ; DEFINING VARIABLES
    ; DB means "Define Byte". We are creating a string of characters.
    ; 0Dh, 0Ah = New Line (Carriage Return + Line Feed).
    ; '$' = The stop sign for the printer.
    ; -------------------------------------------------------------------------

    msg_intro   DB 0Dh, 0Ah, 'I am thinking of a number between 0 and 9.$'
    msg_prompt  DB 0Dh, 0Ah, 'Enter your guess: $'
    msg_low     DB 0Dh, 0Ah, 'Too low! Try again.$'
    msg_high    DB 0Dh, 0Ah, 'Too high! Try again.$'
    msg_win     DB 0Dh, 0Ah, 'CORRECT! You won!$'
    
    ; -------------------------------------------------------------------------
    ; THE SECRET NUMBER
    ; We store '7' as text (ASCII) so we can compare it directly to the key press.
    ; -------------------------------------------------------------------------
    secret_num  DB '7'

DATA ENDS                     ; END of the Data Segment.

CODE SEGMENT                  ; START of the "Code Instructions" section.
    ASSUME CS:CODE, DS:DATA

START:
    ; -------------------------------------------------------------------------
    ; 1. SETUP THE OFFICE (Initialization)
    ; The CPU (Worker) needs to know where the Data Cabinet is.
    ; We cannot move numbers directly into DS (short arms), so we use AX as a bridge.
    ; -------------------------------------------------------------------------
    MOV AX, DATA              ; Copy address of DATA segment to AX tray.
    MOV DS, AX                ; Copy AX to DS (Now the CPU can find variables).

    ; -------------------------------------------------------------------------
    ; 2. PRINT INTRO MESSAGE
    ; -------------------------------------------------------------------------
    LEA DX, msg_intro         ; LEA = Load Effective Address.
                              ; Point DX to the 'msg_intro' variable.
    MOV AH, 09h               ; 09h = "Manager (DOS), please PRINT string".
    INT 21h                   ; Interrupt = Call the Manager.

GAME_LOOP:
    ; -------------------------------------------------------------------------
    ; 3. PRINT PROMPT "Enter your guess:"
    ; -------------------------------------------------------------------------
    LEA DX, msg_prompt
    MOV AH, 09h
    INT 21h

    ; -------------------------------------------------------------------------
    ; 4. GET USER INPUT
    ; -------------------------------------------------------------------------
    MOV AH, 01h               ; 01h = "Manager, READ one character".
    INT 21h                   ; Call Manager. Result appears in AL register.

    ; -------------------------------------------------------------------------
    ; 5. THE LOGIC (The Comparison)
    ; CMP subtracts (AL - secret_num) to set the Flags (Lightbulbs).
    ; -------------------------------------------------------------------------
    CMP AL, secret_num        ; Compare User Input (AL) vs Secret ('7').
    
    JE WINNER                 ; Jump if Equal (Zero Flag is ON).
    JL IS_LOW                 ; Jump if Less (Sign Flag is ON).
    JG IS_HIGH                ; Jump if Greater.

IS_LOW:
    LEA DX, msg_low           ; Point to "Too low" message.
    MOV AH, 09h               ; Prep print command.
    INT 21h                   ; Print it.
    JMP GAME_LOOP             ; FORCE JUMP back to start to try again.

IS_HIGH:
    LEA DX, msg_high          ; Point to "Too high" message.
    MOV AH, 09h
    INT 21h
    JMP GAME_LOOP             ; FORCE JUMP back to start.

WINNER:
    LEA DX, msg_win           ; Point to "You Won" message.
    MOV AH, 09h
    INT 21h

    ; -------------------------------------------------------------------------
    ; 6. EXIT PROGRAM
    ; -------------------------------------------------------------------------
    MOV AH, 4Ch               ; 4Ch = "Terminate Process".
    INT 21h                   ; "Manager, I am done."

CODE ENDS
END START