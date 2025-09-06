SUB_4CBE                              set $00004CBE

ORIGIN_GRAB_ENEMY                     set $00005598
LOCAL_55A2                            set $000055A2

ORIGIN_ALEX_SUPERMOVE2                set $0000AF6E
ORIGIN_ALEX_SUPERMOVE2_IMPL           set $001F64A0

ORIGIN_BLAZE_SUPERMOVE2               set $0000B15C
BLAZE_SUPERMOVE2_END                  set $001F8000

ORIGIN_SET_X_SPEED_FOR_AIR_HIT        set $001F69A4
ORIGIN_SET_Y_AIR_HIGH                 set $001F7472
NEW_SET_Y_AIR_HIGH                    set $001F7580
ORIGIN_SET_Y_AIR_MATCH_OFFSPECIAL     set $001F7488

; Overrides: ---------------------------------------------------------------
        org     SUB_4CBE
ORIGIN_CHECK_ENEMY_COLLISION

        org     ORIGIN_GRAB_ENEMY
        bne.s   ORIGIN_SKIP_DISPOSE_WEAPON

        org     LOCAL_55A2
ORIGIN_SKIP_DISPOSE_WEAPON

        org     ORIGIN_ALEX_SUPERMOVE2
        btst    #0,$1E(A2)
        beq     LOCAL_ALEX_VINSIBILITY
        bset    #7,$49(A2)
        bra     SKIP_ALEX_VINSIBILITY
LOCAL_ALEX_VINSIBILITY
        bclr    #7,$49(A2)
SKIP_ALEX_VINSIBILITY
        jmp     ORIGIN_ALEX_SUPERMOVE2_IMPL

        org     ORIGIN_BLAZE_SUPERMOVE2
        btst    #0,$1E(A2)
        beq     LOCAL_BLAZE_VINSIBILITY
        jsr     BLAZE_SUPERMOVE2_END
        rts
LOCAL_BLAZE_VINSIBILITY
        bclr    #7,$49(A2)
        bsr     ORIGIN_CHECK_ENEMY_COLLISION
        rts

        org     ORIGIN_SET_X_SPEED_FOR_AIR_HIT
        ;cmpi.w  #$1D,d0
        ;beq.s   SET_AIR_SPEED_SLOW
        ;cmpi.w  #$1E,d0
        ;beq.s   SET_AIR_SPEED_SLOW
        cmpi.w  #$1F,d0
        bne.s   LOCAL_NEXT
        cmpi.w  #4,$C(A3)
        beq.s   SET_AIR_SPEED_SLOW
        bra.s   SET_AIR_SPEED_NORMAL
LOCAL_NEXT
        cmpi.w  #$25,d0
        beq.s   SET_AIR_SPEED_SLOW
        cmpi.w  #$20,d0
        beq.s   SET_AIR_SPEED_SLOW
        cmpi.w  #$22,d0
        beq.s   SET_AIR_SPEED_SLOW
        cmpi.w  #$27,d0
        bne.s   SET_AIR_SPEED_NORMAL
SET_AIR_SPEED_SLOW
        move.w  #1,$92(A2)
        rts
SET_AIR_SPEED_NORMAL
        move.w  #2,$92(A2)
        rts

        org     ORIGIN_SET_Y_AIR_HIGH
        jmp     NEW_SET_Y_AIR_HIGH
; Change: ---------------------------------------------------------------
        org     BLAZE_SUPERMOVE2_END
        bset    #7,$49(A2)
        clr.l   $5E(A2)
        andi.w  #1,$E(A2)
        ori.w   #0,$E(A2)
        move.w  #2,0(A2)
        sf      $9E(A2)
        rts

        org     NEW_SET_Y_AIR_HIGH
        move.w  $E(A3),D0
        lsr.w   #1,D0

        ; Check whether the enemy is in air or on the ground. Value 0 means on the ground.
        cmpi.w  #0,$5E(A2)
        beq     NEW_SET_Y_AIR_CHECK_OFFSPECIAL

        ; Check whether the Animation is air Combo
        cmpi.w  #$1D,D0
        beq     NEW_SET_Y_AIR_MATCH_NORMAL_PUNCH
        cmpi.w  #$1E,D0
        beq     NEW_SET_Y_AIR_MATCH_COMBO_DEFAULT
        cmpi.w  #$1F,D0
        bne.s   NEW_SET_Y_AIR_CHECK_FF_A
        ; Check the FrameId at $18 character variable. From the begin to the end the FrameId is decreasing
        cmpi.w  #2,$18(A3)
        bgt     NEW_SET_Y_AIR_MATCH_COMBO_DEFAULT
        cmpi.w  #4,$C(A3)
        beq.s   NEW_SET_Y_AIR_NORMAL_RETURN
        bclr    #7,$49(A2)
        bra.s   NEW_SET_Y_AIR_NORMAL_RETURN

        ; Check whether the Animation is air F-Foward A
NEW_SET_Y_AIR_CHECK_FF_A
        cmpi.w  #$31,D0
        bne.s   NEW_SET_Y_AIR_CHECK_GRANDUPPER
        cmpi.w  #4,$C(A3)
        bne.s   NEW_SET_Y_AIR_CHECK_FF_A_ALEX
        cmpi.w  #$E,$18(A3)
        bgt     NEW_SET_Y_AIR_MATCH_FF_A
        bra.s   NEW_SET_Y_AIR_NORMAL_RETURN
NEW_SET_Y_AIR_CHECK_FF_A_ALEX
        cmpi.w  #2,$C(A3)
        bne.s   NEW_SET_Y_AIR_NORMAL_RETURN
        cmpi.w  #6,$18(A3)
        bgt.s   NEW_SET_Y_AIR_MATCH_FF_A
        move.l  #$FFFAC400,$2E(A2)
        cmpi.w  #4,$18(A3)
        bgt.s   NEW_SET_Y_AIR_MATCH_FF_A_RETURN
        bclr    #7,$49(A2)
NEW_SET_Y_AIR_MATCH_FF_A_RETURN
        rts

        ; Check whether the Animation is Alex's Grandupper
NEW_SET_Y_AIR_CHECK_GRANDUPPER
        cmpi.w  #$24,D0
        bne.s   NEW_SET_Y_AIR_CHECK_OFFSPECIAL
        cmpi.w  #2,$C(A3)
        bne.s   NEW_SET_Y_AIR_NORMAL_RETURN
        cmpi.w  #2,$18(A3)
        bgt.s   NEW_SET_Y_AIR_NORMAL_RETURN
        bclr    #7,$49(A2)
        bra.s   NEW_SET_Y_AIR_NORMAL_RETURN

        ; Check whether the Animation is off special no matter air or on the ground
NEW_SET_Y_AIR_CHECK_OFFSPECIAL
        cmpi.w  #$25,D0
        beq.s   NEW_SET_Y_AIR_MATCH_OFFSPECIAL
NEW_SET_Y_AIR_NORMAL_RETURN
        move.l  #$FFFAC400,$2E(A2)
        rts

NEW_SET_Y_AIR_MATCH_OFFSPECIAL
        jmp     ORIGIN_SET_Y_AIR_MATCH_OFFSPECIAL

NEW_SET_Y_AIR_MATCH_NORMAL_PUNCH
        ; Set the Y air inertia. As negative value, the bigger of the value, the lower of the Y position.
        move.l  #$FFFF3600,$2E(A2)
        bra.s   NEW_SET_Y_AIR_COMBO_RETURN
        ;cmpi.l  #$FFF60000,$5E(A2)
        ;bge.s   NEW_SET_Y_AIR_COMBO_CATCH_UP
        ;move.l  #$FFFF3500,$2E(A2)
        ;bra.s   NEW_SET_Y_AIR_COMBO_RETURN
;NEW_SET_Y_AIR_COMBO_CATCH_UP
        ;move.l  #$FFFE8000,$2E(A2)
        ;bra.s   NEW_SET_Y_AIR_COMBO_RETURN

NEW_SET_Y_AIR_MATCH_COMBO_DEFAULT
        move.l  #$FFFE8000,$2E(A2)
NEW_SET_Y_AIR_COMBO_RETURN
        move.w  #0,$92(A2)
        rts

NEW_SET_Y_AIR_MATCH_FF_A
        move.l  #$FFFE8000,$2E(A2)
        move.w  #1,$92(A2)
        rts
