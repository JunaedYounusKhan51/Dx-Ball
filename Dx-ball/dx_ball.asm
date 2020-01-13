;;;; important notes and comments
;;----------------------------------
;;line 646: paddle_move proc->UP: (CMP PADDLE_LEFT,13) ;it should be PADDLE_LEFT intead of PADDLE_TOP 
    
;; block4 and block10 e er hit e prob cilo, check_boundary proc er moddhe..tai 5 er bodole 9 sub kora hoise..

;;block7 er prb cilo. tried to correct it by using 9 intead of 5





.model small


draw_row Macro x
    Local l1
; draws a line in row x from col 10 to col 300
    MOV AH, 0CH
    MOV AL, 1
    MOV CX, 10
    MOV DX, x
L1: INT 10h
    INC CX
    CMP CX, 301
    JL L1
    EndM

draw_col Macro y
    Local l2
; draws a line col y from row 10 to row 189
    MOV AH, 0CH
    MOV AL, 1
    MOV CX, y
    MOV DX, 10
L2: INT 10h
    INC DX
    CMP DX, 190
    JL L2
    EndM


.stack 100h

.data


;;;
dx_ball_msg db "               ||\\  \\  //     ||\\    /\   ||    ||     ",0AH,0DH,"               || \\  \\//      ||//   //\\  ||    ||     ",0AH,0DH,"               || ||  //\\  === ||\\  //==\\ ||    ||     ",0AH,0DH,"               ||//  //  \\     ||// //    \\||____||____ $"

 

;;;;

NEW_TIMER_VEC DW ?,?
OLD_TIMER_VEC DW ?,?

NEW_KEY_VEC DW ?,?
OLD_KEY_VEC DW ?,?


NEW_KEY_VEC_2 DW ?,?
OLD_KEY_VEC_2 DW ?,?


SCAN_CODE DB 0
scan_code_2 DB 0 

KEY_FLAG DB 0
KEY_FLAG_2 DB 0

TIMER_FLAG DB 0


;;old paddle

PADDLE_TOP DW 30 ;;prevsly 45
PADDLE_BOTTOM DW 54
PADDLE_COLLUMN DW 11
;;;;;;;;;



;;;; new paddle for dx ball 
  
paddle_right dw 50
paddle_left dw 30 
paddle_row dw 187
;;;


;;blocks


;;1st row

;;block 1
block1_left dw 55
block1_right dw 95
block1_row dw 50


;;block 2

block2_left dw 135
block2_right dw 175
block2_row dw 50

;;block 3

block3_left dw 215
block3_right dw 255
block3_row dw 50


;;;; 2nd row

;;block 4
block4_left dw 15
block4_right dw 55
block4_row dw 70

;;block 5
block5_left dw 95
block5_right dw 135
block5_row dw 70


;;block 6
block6_left dw 175 ; 175
block6_right dw 215
block6_row dw 70

;;block 7
block7_left dw 255;255
block7_right dw 295
block7_row dw 70



;;;; 3rd row

;;block 8
block8_left dw 55
block8_right dw 95
block8_row dw 90


;;block 9
block9_left dw 135
block9_right dw 175
block9_row dw 90

;;block 10
block10_left dw 215
block10_right dw 255
block10_row dw 90




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;try  for multiplayer

;;;;;;;;
PADDLE_TOP_2 DW 30 ;;prevsly 45
PADDLE_BOTTOM_2 DW 54
PADDLE_COLLUMN_2 DW 180
;;;;;;;;;;


VEL_X DW -3
VEL_Y DW -7;;-1

;SCAN CODES

UP_ARROW  = 72
LEFT_ARROW = 75
RIGHT_ARROW = 77
DOWN_ARROW = 80
ESC_KEY = 1
;;
;;


;;colors
paddle_clr db 1 ;; prevsly 2
paddle_clr_2 db 2;;

block_clr db 2

background_clr db 0; blue = 1, green = 2, red = 4, black = 0

;;constant for paddle move right left

paddle_move_left dw -8
paddle_move_right dw 8
;;;;;;;;;;


;;ball starting position

ball_starting_collumn dw 40; as paddle er left 30, right 50
ball_starting_row dw 186; as paddle er row 187


;;SCORE VARIABLE
score dw 0
score_msg db '  SCORE: $'


;;;
survival dw 0
survival_msg db '    You survived: $'

;;
.code

main proc

    MOV AX,@DATA
    MOV DS , AX
    
    
    ;;;; starting page (menu)
    
     mov ax, 0b800H
    mov es, ax
    
    ;clearing the screen
  
  ;  lea BX, dx_ball_msg_2
  ;  mov dx,00
  ;  call writestringat
  
  
    
    lea dx, dx_ball_msg
     mov ah, 09H
    int 21h
    
    
    mov ah, 07h
    int 21h
    mov ax, 0003H
    int 10H
    
    
    MOV AX, @data
    MOV DS, AX
    
    
    ;;;;
    ;SET GRAPHICS
    
    CALL SET_DISPLAY_MODE
    
    ;DRAW PADDLE
    
    MOV AL,paddle_clr
    CALL DRAW_PADDLE ; DISPLAY RED PADDLE
    
    
    ;;draw blocks
    
    ;;block1
    
    mov al,block_clr
    call draw_block1
    
    ;;block2
    
    mov al,block_clr
    call draw_block2
    
    ;;block3
    mov al, block_clr
    call draw_block3
    
    
    ;;2nd row
    
    ;;block4
    mov al, block_clr
    call draw_block4
    
    ;;block5
    mov al, block_clr
    call draw_block5
    
    ;;block6
    mov al, block_clr
    call draw_block6
    
    ;;block7
    mov al, block_clr
    call draw_block7
    
    
    ;;3rd row
    
    ;;block8
    mov al, block_clr
    call draw_block8
    
    ;;block9
    mov al, block_clr
    call draw_block9
    
    ;;block10
    mov al, block_clr
    call draw_block10
    
    
    ;;;;;;;;;;;;;;;;;;;
    
    
    ;;paddle-2 comment out
    ;;;;;;;;;;
    ;;MOV AL,paddle_clr_2
    ;;CALL DRAW_PADDLE_2 ; DISPLAY RED PADDLE
    ;;; 


    
    
    
    ;;;;;;;;;;;;;;
        ;SET KEYBRD INTP 2
    MOV NEW_KEY_VEC_2, OFFSET KEYBOARD_INT_2
    MOV NEW_KEY_VEC_2+2,CS
    MOV AL,9H
    LEA DI,OLD_KEY_VEC_2
    LEA SI,NEW_KEY_VEC_2
    CALL SETUP_INT

    
    ;;;;;;;;
    
    
    ;SET TIMER INTRPT
    
    MOV NEW_TIMER_VEC, OFFSET TIMER_TICK
    MOV NEW_TIMER_VEC+2,CS
    MOV AL,1CH
    LEA DI,OLD_TIMER_VEC
    LEA SI,NEW_TIMER_VEC
    CALL SETUP_INT
    
    
    
    ;SET KEYBRD INTP
    MOV NEW_KEY_VEC, OFFSET KEYBOARD_INT
    MOV NEW_KEY_VEC+2,CS
    MOV AL,9H
    LEA DI,OLD_KEY_VEC
    LEA SI,NEW_KEY_VEC
    CALL SETUP_INT
    
    
    
;;;;X    Y_BALL
    
    
    ;START BALL AT COL = 298, ROW = 100
    
    MOV CX, ball_starting_collumn; 298
    MOV DX,ball_starting_row;100
    MOV AL,3
    CALL DISPLAY_BALL




    ;;;LOL TRY 2ND BALL  1

    ;MOV CX,150
    ;MOV DX,100
    ;MOV AL,3
    ;CALL DISPLAY_BALL
    
   ;;;;
  
   
    ;CHECK KEY FLAG
    
    TEST_KEY:
        CMP KEY_FLAG,1
        JNE TEST_TIMER
        MOV KEY_FLAG,0
        CMP SCAN_CODE,ESC_KEY
        JNE TK_1
        JMP DONE
        
    TK_1:
        CMP SCAN_CODE,LEFT_ARROW
        JNE TK_2
        MOV AX ,paddle_move_left; -4
        CALL MOVE_PADDLE
        JMP TEST_TIMER
    
    TK_2:
        CMP SCAN_CODE, RIGHT_ARROW
        JNE TK_3
        MOV AX,paddle_move_right; 4
        CALL MOVE_PADDLE
        JMP TEST_TIMER
    
    TK_3:
        CMP SCAN_CODE, 'a'
        JNE TK_4
        MOV AX,paddle_move_left ;-4
        CALL MOVE_right_left
        JMP TEST_TIMER
    
    TK_4:        
    CMP SCAN_CODE, 'b'
        JNE TEST_TIMER
        MOV AX,paddle_move_right;4
        CALL MOVE_right_left
        ;JMP TEST_TIMER    
            
    TEST_TIMER:
        CMP TIMER_FLAG,1
        JNE TEST_KEY
        MOV TIMER_FLAG,0
        CALL MOVE_BALL_A

    ;CHECK IF PADDLE MISSED BALL
    
    ;;LEFT WALL E BALL LAGLE TERMNTN
    
    ;COMMENT OUT
    
    CMP DX,186
    JLE TEST_KEY
    CMP CX,PADDLE_left
    JL CP_1
    CMP CX,PADDLE_right
    JG CP_1
    
    
    ;;;;;;;;;
    
    
    
    
   ;PADDLE HIT THE BALL, DELAY ONE TICK
    
  ; MOVE THE BALL AND REDRAW PADDLE
 
    DELAY:
        CMP TIMER_FLAG,1
        JNE DELAY
        MOV TIMER_FLAG,0
        CALL MOVE_BALL_A
        MOV AL,paddle_clr
        CALL DRAW_PADDLE
        JMP TEST_KEY
        
   ;PADDLE MISSED THE BALL, ERASE THE BALL, TERMINTE
   
   CP_1:
        MOV AL,0
        CALL DISPLAY_BALL
   
   DONE:
       ;;LEA DI,NEW_TIMER_VEC
       ;;...........
       
 
        ;RETURN TO DOS
        
        ;;msg- (score: )
        LEA DX,score_msg
        MOV AH,9
        INT 21H
        
        ;;score print
        mov ah,2
        mov dx,score
        add dx,48
        int 21h
        
        ;;termination
        MOV AH,4CH
        INT 21H
        
MAIN ENDP


KEYBOARD_INT PROC
    PUSH DS
    PUSH AX
  
    MOV AX, SEG SCAN_CODE
    MOV DS,AX
    
    ;INPUT SCAN CODE
    
    IN AL,60H
    PUSH AX
    IN AL,61H
    MOV AH,AL
    OR AL,80H
    OUT 61H,AL
    XCHG AH,AL
    OUT 61H,AL
    POP AX
    MOV AH,AL
    TEST AL,80H
    JNE KEY_0
    
    
    ;MAKE CODE
    
    MOV SCAN_CODE,AL
    MOV KEY_FLAG,1
    
    KEY_0:
    MOV AL,20H
    OUT 20H,AL
    
    POP AX
    POP DS
    
    IRET
    
KEYBOARD_INT ENDP





KEYBOARD_INT_2 PROC
    PUSH DS
    PUSH AX
  
    MOV AX, SEG SCAN_CODE_2
    MOV DS,AX
    
    ;INPUT SCAN CODE
    
    IN AL,60H
    PUSH AX
    IN AL,61H
    MOV AH,AL
    OR AL,80H
    OUT 61H,AL
    XCHG AH,AL
    OUT 61H,AL
    POP AX
    MOV AH,AL
    TEST AL,80H
    JNE KEY_0_2
    
    
    ;MAKE CODE
    
    MOV SCAN_CODE_2,AL
    MOV KEY_FLAG_2,1
    
    KEY_0_2:
    MOV AL,20H
    OUT 20H,AL
    
    POP AX
    POP DS
    
    IRET
    
KEYBOARD_INT_2 ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;draw blocks

;;block1

draw_block1 proc

    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,block1_row ;;11
    MOV cX,block1_left
    
    DP_block1:
        INT 10H
        INC cx
        CMP cx,block1_right
        JLE DP_block1
        
        POP DX
        POP CX
        
        RET




draw_block1 endp
;;;;


;;block2

draw_block2 proc

    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,block2_row ;;11
    MOV cX,block2_left
    
    DP_block2:
        INT 10H
        INC cx
        CMP cx,block2_right
        JLE DP_block2
        
        POP DX
        POP CX
        
        RET




draw_block2 endp

;;;

draw_block3 proc

    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,block3_row ;;11
    MOV cX,block3_left
    
    DP_block3:
        INT 10H
        INC cx
        CMP cx,block3_right
        JLE DP_block3
        
        POP DX
        POP CX
        
        RET




draw_block3 endp
;;;;


draw_block4 proc

    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,block4_row ;;11
    MOV cX,block4_left
    
    DP_block4:
        INT 10H
        INC cx
        CMP cx,block4_right
        JLE DP_block4
        
        POP DX
        POP CX
        
        RET




draw_block4 endp
;;;;




draw_block5 proc

    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,block5_row ;;11
    MOV cX,block5_left
    
    DP_block5:
        INT 10H
        INC cx
        CMP cx,block5_right
        JLE DP_block5
        
        POP DX
        POP CX
        
        RET




draw_block5 endp
;;;;

draw_block6 proc

    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,block6_row ;;11
    MOV cX,block6_left
    
    DP_block6:
        INT 10H
        INC cx
        CMP cx,block6_right
        JLE DP_block6
        
        POP DX
        POP CX
        
        RET




draw_block6 endp
;;;;


draw_block7 proc

    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,block7_row ;;11
    MOV cX,block7_left
    
    DP_block7:
        INT 10H
        INC cx
        CMP cx,block7_right
        JLE DP_block7
        
        POP DX
        POP CX
        
        RET




draw_block7 endp
;;;;

draw_block8 proc

    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,block8_row ;;11
    MOV cX,block8_left
    
    DP_block8:
        INT 10H
        INC cx
        CMP cx,block8_right
        JLE DP_block8
        
        POP DX
        POP CX
        
        RET




draw_block8 endp
;;;;

draw_block9 proc

    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,block9_row ;;11
    MOV cX,block9_left
    
    DP_block9:
        INT 10H
        INC cx
        CMP cx,block9_right
        JLE DP_block9
        
        POP DX
        POP CX
        
        RET




draw_block9 endp
;;;;


draw_block10 proc

    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,block10_row ;;11
    MOV cX,block10_left
    
    DP_block10:
        INT 10H
        INC cx
        CMP cx,block10_right
        JLE DP_block10
        
        POP DX
        POP CX
        
        RET




draw_block10 endp
;;;;











;;;;;;;;;;






;;;;;;remove blocks

;;rmv blk 1

remove_block1 proc
   

    push ax
    push bx
   
   ;;score increase as block hit korse
    
   mov bx, score
   inc bx
   mov score,bx
       
    
   ;;undraw = draw with 0
   
   mov al,0
   call draw_block1
   
     
   
   ;;this block has been hit
   ;;changing the block1 co-ordinates to remove it to a distant place
   
   
   mov block1_left,9999
   mov block1_right,9999
   mov block1_row,9999
   
   pop bx
   pop ax
   
   ret

remove_block1 endp


;;rmv blk 2
;;;;;;;;
remove_block2 proc
   
    push ax
    push bx
   
    ;;score increase as block hit korse
    
   mov bx, score
   inc bx
   mov score,bx
   
   ;undraw
   
   mov al,0
   call draw_block2
   
   
   ;;this block has been hit
   ;;changing the block1 co-ordinates to remove it to a distant place
   
   
   mov block2_left,9999
   mov block2_right,9999
   mov block2_row,9999
   
   pop bx
   pop ax
   
   ret




remove_block2 endp
;;;;;;;;;;


;;;;;;;;
remove_block3 proc
   
    push ax
    push bx
   
    ;;score increase as block hit korse
    
   mov bx, score
   inc bx
   mov score,bx
   
   ;undraw
   
   mov al,0
   call draw_block3
   
   
   ;;this block has been hit
   ;;changing the block1 co-ordinates to remove it to a distant place
   
   
   mov block3_left,9999
   mov block3_right,9999
   mov block3_row,9999
   
   pop bx
   pop ax
   
   ret




remove_block3 endp
;;;;;;;;;;


;;;;;;;;
remove_block4 proc
   
    push ax
    push bx
   
    ;;score increase as block hit korse
    
   mov bx, score
   inc bx
   mov score,bx
   
   ;undraw
   
   mov al,0
   call draw_block4
   
   
   ;;this block has been hit
   ;;changing the block1 co-ordinates to remove it to a distant place
   
   
   mov block4_left,9999
   mov block4_right,9999
   mov block4_row,9999
   
   pop bx
   pop ax
   
   ret




remove_block4 endp
;;;;;;;;;;


;;;;;;;;;;


;;;;;;;;
remove_block5 proc
   
    push ax
    push bx
   
    ;;score increase as block hit korse
    
   mov bx, score
   inc bx
   mov score,bx
   
   ;undraw
   
   mov al,0
   call draw_block5
   
   
   ;;this block has been hit
   ;;changing the block1 co-ordinates to remove it to a distant place
   
   
   mov block5_left,9999
   mov block5_right,9999
   mov block5_row,9999
   
   pop bx
   pop ax
   
   ret




remove_block5 endp
;;;;;;;;;;


;;;;;;;;
remove_block6 proc
   
    push ax
    push bx
   
    ;;score increase as block hit korse
    
   mov bx, score
   inc bx
   mov score,bx
   
   ;undraw
   
   mov al,0
   call draw_block6
   
   
   ;;this block has been hit
   ;;changing the block1 co-ordinates to remove it to a distant place
   
   
   mov block6_left,9999
   mov block6_right,9999
   mov block6_row,9999
   
   pop bx
   pop ax
   
   ret




remove_block6 endp
;;;;;;;;;;

;;;;;;;;
remove_block7 proc
   
    push ax
    push bx
   
    ;;score increase as block hit korse
    
   mov bx, score
   inc bx
   mov score,bx
   
   ;undraw
   
   mov al,0
   call draw_block7
   
   
   ;;this block has been hit
   ;;changing the block1 co-ordinates to remove it to a distant place
   
   
   mov block7_left,9999
   mov block7_right,9999
   mov block7_row,9999
   
   pop bx
   pop ax
   
   ret




remove_block7 endp
;;;;;;;;;;


;;;;;;;;
remove_block8 proc
   
    push ax
    push bx
   
    ;;score increase as block hit korse
    
   mov bx, score
   inc bx
   mov score,bx
   
   ;undraw
   
   mov al,0
   call draw_block8
   
   
   ;;this block has been hit
   ;;changing the block1 co-ordinates to remove it to a distant place
   
   
   mov block8_left,9999
   mov block8_right,9999
   mov block8_row,9999
   
   pop bx
   pop ax
   
   ret




remove_block8 endp
;;;;;;;;;;

;;;;;;;;
remove_block9 proc
   
    push ax
    push bx
   
    ;;score increase as block hit korse
    
   mov bx, score
   inc bx
   mov score,bx
   
   ;undraw
   
   mov al,0
   call draw_block9
   
   
   ;;this block has been hit
   ;;changing the block1 co-ordinates to remove it to a distant place
   
   
   mov block9_left,9999
   mov block9_right,9999
   mov block9_row,9999
   
   pop bx
   pop ax
   
   ret




remove_block9 endp
;;;;;;;;;;



;;;;;;;;
remove_block10 proc
   
    push ax
    push bx
   
    ;;score increase as block hit korse
    
   mov bx, score
   inc bx
   mov score,bx
   
   ;undraw
   
   mov al,0
   call draw_block10
   
   
   ;;this block has been hit
   ;;changing the block1 co-ordinates to remove it to a distant place
   
   
   mov block10_left,9999
   mov block10_right,9999
   mov block10_row,9999
   
   pop bx
   pop ax
   
   ret




remove_block10 endp
;;;;;;;;;;





;;paddle

;draw paddle

DRAW_PADDLE PROC
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV DX,PADDLE_row ;;11
    MOV cX,PADDLE_left
    
    DP1:
        INT 10H
        INC cx
        CMP cx,PADDLE_right
        JLE DP1
        
        POP DX
        POP CX
        
        RET
        
DRAW_PADDLE ENDP



;;no need
DRAW_PADDLE_2 PROC
    PUSH CX
    PUSH DX
    MOV AH,0CH
    MOV CX,PADDLE_COLLUMN_2 ;;11
    MOV DX,PADDLE_TOP_2
    
    DP1_2:
        INT 10H
        INC DX
        CMP DX,PADDLE_BOTTOM_2
        JLE DP1_2
        
        POP DX
        POP CX
        
        RET
        
DRAW_PADDLE_2 ENDP



;;move paddle up down (no need)

MOVE_PADDLE PROC
    
    MOV BX,AX
    CMP AX,0
    JL UP
    
    CMP PADDLE_right,298 ;; INSTEAD OF 300 (OF COLLUMN) 
    JGE DONE_PADDLE
    JMP UPDATE
    
    UP:
    CMP PADDLE_LEFT,14 ; INSTEAD OF 11 OF COLLUMN ;; 
    ;;;N.B. - IN ALL THE PREVIOUS VERSIONS, THE WAS A MISTAKE IN THE AVOBE LINE: it should be PADDLE_LEFT intead of PADDLE_TOP 
    JLE DONE_PADDLE
     
    UPDATE:
        ;ERASE PADDLE
         MOV AL,0
         CALL DRAW_PADDLE
         
         ;CHANGE PADDLE POSTN
         ADD PADDLE_right,BX
         ADD PADDLE_left,BX
            
         ;DISPLAY PADDLE AT NEW PSTN
          MOV AL,paddle_clr
          CALL DRAW_PADDLE
               
       DONE_PADDLE:
               
            RET


MOVE_PADDLE ENDP


;;move  paddle right left

MOVE_RIGHT_LEFT PROC
    
    MOV BX,AX
    
    MOV AL,0
    CALL DRAW_PADDLE
         
    ;CHANGE PADDLE POSTN
    ADD PADDLE_COLLUMN,BX
    
    ;DISPLAY PADDLE AT NEW PSTN
     MOV AL,paddle_clr
    CALL DRAW_PADDLE
               
    RET        
    

MOVE_RIGHT_LEFT ENDP



;;;display
      
set_display_mode Proc
; sets display mode and draws boundary
    MOV AH, 0
    MOV AL, 04h; 320x200 4 color
    INT 10h
; select palette    
    MOV AH, 0BH
    MOV BH, 1
    MOV BL, 1  
    INT 10h
; set bgd color
    MOV BH, 0
    MOV BL, background_clr; ; blue = 1, green = 2, red = 4, black = 0
    INT 10h
; draw boundary
    draw_row 10
    draw_row 189
    draw_col 10
    draw_col 300
    
    RET
set_display_mode EndP


;;;ball


display_ball Proc
; displays ball at col CX and row DX with color given in AL
; input: AL = color of ball
;    CX = col
;    DX = row
    MOV AH, 0CH ; write pixel
    INT 10h
    INC CX      ; pixel on next col
    INT 10h
    INC DX      ; down 1 row
    INT 10h
    DEC CX      ; prev col
    INT 10h
    DEC DX      ; restore dx
    RET 
display_ball EndP

;;;;;

timer_tick Proc
    PUSH DS
    PUSH AX
    
    
    MOV AX, Seg timer_flag
    MOV DS, AX
    MOV timer_flag, 1
    
    POP AX
    POP DS
    
    IRET
timer_tick EndP


;;;;;;;


move_ball_A Proc
; erase ball at current position and display at new position
; input: CX = col of ball position
;    DX = rwo of ball position
; erase ball
    MOV AL, 0
    CALL display_ball
; get new position
    ADD CX, vel_x
    ADD DX, vel_y
; check boundary
    CALL check_boundary
; wait for 1 timer tick to display ball
test_timer_1:
    CMP timer_flag, 1
    JNE test_timer_1
    MOV timer_flag, 0
    MOV AL, 3
    CALL display_ball
    RET 
    move_ball_A EndP

;;;;;;;;;;;;










;;;;;;;;;;;;
check_boundary Proc
; determine if ball is outside screen, if so move it back in and 
;  change ball direction
; input: CX = col of ball
;    DX = row of ball
; output: CX = valid col of ball
;     DX = valid row of ball
; check col value

PUSH BX
;;
MOV BX,block1_row
ADD BX, 3 
CMP dx,BX
JG NOT_HIT_block1
SUB BX,6
CMP dX,BX
JL NOT_HIT_block1
CMP CX,block1_right
JG NOT_HIT_block1
CMP CX, block1_left
JL NOT_HIT_block1
JMP HIT_block1

HIT_block1:
 call remove_block1
 NEG vel_x
 NEG VEL_Y    

NOT_HIT_block1:


;;now check for block 2

;;
MOV BX,block2_row
ADD BX, 3 
CMP dx,BX
JG NOT_HIT_block2
SUB BX,5
CMP dX,BX
JL NOT_HIT_block2
CMP CX,block2_right
JG NOT_HIT_block2
CMP CX, block2_left
JL NOT_HIT_block2
JMP HIT_block2

HIT_block2:
 call remove_block2
 NEG vel_x
 NEG VEL_Y    

NOT_HIT_block2:

MOV BX,block3_row
ADD BX, 3 
CMP dx,BX
JG NOT_HIT_block3
SUB BX,5
CMP dX,BX
JL NOT_HIT_block3
CMP CX,block3_right
JG NOT_HIT_block3
CMP CX, block3_left
JL NOT_HIT_block3
JMP HIT_block3

HIT_block3:
 call remove_block3
 NEG vel_x
 NEG VEL_Y    

NOT_HIT_block3:




MOV BX,block4_row
ADD BX, 3 
CMP dx,BX
JG NOT_HIT_block4
SUB BX,9 ;; 5 dile prothom bar hit kore na, so 5 er bodole 9 
CMP dX,BX
JL NOT_HIT_block4
CMP CX,block4_right
JG NOT_HIT_block4
CMP CX, block4_left
JL NOT_HIT_block4
JMP HIT_block4

HIT_block4:
 call remove_block4
 NEG vel_x
 NEG VEL_Y    

NOT_HIT_block4:



MOV BX,block5_row
ADD BX, 3 
CMP dx,BX
JG NOT_HIT_block5
SUB BX,5
CMP dX,BX
JL NOT_HIT_block5
CMP CX,block5_right
JG NOT_HIT_block5
CMP CX, block5_left
JL NOT_HIT_block5
JMP HIT_block5

HIT_block5:
 call remove_block5
 NEG vel_x
 NEG VEL_Y    

 NOT_HIT_block5:


 
 
 
 
 
 MOV BX,block6_row
ADD BX, 3 
CMP dx,BX
JG NOT_HIT_block6
SUB BX,5
CMP dX,BX
JL NOT_HIT_block6
CMP CX,block6_right
JG NOT_HIT_block6
CMP CX, block6_left
JL NOT_HIT_block6
JMP HIT_block6

HIT_block6:
 call remove_block6
 NEG vel_x
 NEG VEL_Y    

NOT_HIT_block6:





MOV BX,block7_row
ADD BX, 3 
CMP dx,BX
JG NOT_HIT_block7
SUB BX,9;; 5 dile prothom bar hit kore na, so 5 er bodole 9
CMP dX,BX
JL NOT_HIT_block7
CMP CX,block7_right
JG NOT_HIT_block7
CMP CX, block7_left
JL NOT_HIT_block7
JMP HIT_block7

HIT_block7:
 call remove_block7
 NEG vel_x
 NEG VEL_Y    

NOT_HIT_block7:




MOV BX,block8_row
ADD BX, 3 
CMP dx,BX
JG NOT_HIT_block8
SUB BX,5
CMP dX,BX
JL NOT_HIT_block8
CMP CX,block8_right
JG NOT_HIT_block8
CMP CX, block8_left
JL NOT_HIT_block8
JMP HIT_block8

HIT_block8:
 call remove_block8
 NEG vel_x
 NEG VEL_Y    

NOT_HIT_block8:





MOV BX,block9_row
ADD BX, 3 
CMP dx,BX
JG NOT_HIT_block9
SUB BX,5
CMP dX,BX
JL NOT_HIT_block9
CMP CX,block9_right
JG NOT_HIT_block9
CMP CX, block9_left
JL NOT_HIT_block9
JMP HIT_block9

HIT_block9:
 call remove_block9
 NEG vel_x
 NEG VEL_Y    

NOT_HIT_block9:





MOV BX,block10_row
ADD BX, 3 ; 3 er bodole 5 
CMP dx,BX
JG NOT_HIT_block10
SUB BX,9 ; 5 dile hit kore na, so 5 er bodole 9 disi
CMP dX,BX
JL NOT_HIT_block10
CMP CX,block10_right
JG NOT_HIT_block10
CMP CX, block10_left
JL NOT_HIT_block10
JMP HIT_block10

HIT_block10:
 call remove_block10
 NEG vel_x
 NEG VEL_Y    

NOT_HIT_block10:




then:

never_hit_block:

;;check if ball hits the paddle

;MOV BX, PADDLE_ROW
;SUB BX,8
;JLE LETS
;JMP NOT_HIT_PADDLE
;LETS:

;CMP CX, PADDLE_RIGHT
;JG NOT_HIT_PADDLE
;CMP CX,PADDLE_LEFT
;JL NOT_HIT_PADDLE
;JMP HIT_PADDLE

;HIT_PADDLE:
 ;   NEG VEL_X
 ;   NEG vEL_Y
    
 




 ;NOT_HIT_PADDLE:

    CMP CX, 11
    JG LP1
    MOV CX, 11
    NEG vel_x
    JMP LP2 
    

LP1:    
    CMP CX, 298
    JL LP2
    MOV CX, 298
    NEG vel_x
; check row value
LP2:    CMP DX, 11
    JG LP3
    MOV DX, 11
    NEG vel_y
    JMP done_1
LP3:    CMP DX, 187
    JL done_1
    MOV DX, 187
    NEG vel_y
    
done_1:
    POP BX

    RET 
check_boundary EndP

setup_int Proc
; save old vector and set up new vector
; input: al = interrupt number
;    di = address of buffer for old vector
;    si = address of buffer containing new vector
; save old interrupt vector
    MOV AH, 35h ; get vector
    INT 21h
    MOV [DI], BX    ; save offset
    MOV [DI+2], ES  ; save segment
; setup new vector
    MOV DX, [SI]    ; dx has offset
    PUSH DS     ; save ds
    MOV DS, [SI+2]  ; ds has the segment number
    MOV AH, 25h ; set vector
    INT 21h
    POP DS
    RET
setup_int EndP






  
  
END MAIN  
       
   
   
     
    
    

  
