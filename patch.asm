ORIGIN_Chk_EnemyCollision             set $00004CBE

ORIGIN_Chk_Hit                        set $0000541A

ORIGIN_GRAB_ENEMY                     set $00005598
LOCAL_55A2                            set $000055A2

ORIGIN_ALEX_SUPERMOVE2                set $0000AF6E
ORIGIN_ALEX_SUPERMOVE2_IMPL           set $001F64A0

ORIGIN_BLAZE_SUPERMOVE2               set $0000B15C
BLAZE_SUPERMOVE2_END                  set $001F8000

ORIGIN_HEADBUTT                       set $0000C58E
ORIGIN_HEADBUTT_ENMY_DEATH            set $0000C59C
NEW_HEADBUTT                          set $001F8080

ORIGIN_INIT_ENMY_CLR_ENMY_SPCFC       set $0000E1E6
NEW_INIT_ENMY_CLR_ENMY_SPCFC          set $001F8060
ORIGIN_INIT_ENMY_CLR_ENMY_D6          set $0000E1F2

ORIGIN_SET_X_SPEED_FOR_AIR_HIT        set $001F69A4
ORIGIN_SET_Y_AIR_HIGH                 set $001F7472
NEW_SET_Y_AIR_HIGH                    set $001F7580
ORIGIN_SET_Y_AIR_MATCH_OFFSPECIAL     set $001F7488

NEW_CHECK_ALEX_AIR_PUNCH_SKIP         set $001F7C80

ORIGIN_Chk_EnemyCollision_MAX         set $00004D2C
ORIGIN_LOC_4D42                       set $00004D42
ORIGIN_LOC_4D5C                       set $00004D5C
ORIGIN_LOC_4E8E                       set $00004E8E

ORIGIN_LOC_5502                       set $00005502
ORIGIN_DISPOSE_WEAPON                 set $00011BA2

ORIGIN_CHK_ENMY_COLLISION_HIT_SP      set $00024E00
ORIGIN_DISPLAY_KO_KILL                set $000078E6
ORIGIN_PLAY_SOUND                     set $00040008

ORIGIN_ALEX_FFA_TRIGGER               set $001F5578
ORIGIN_DISPLAY_KO_C2                  set $00007922
ORIGIN_ALEX_SET_RUNNING_ATTACK_MOD    set $0000BE28
ORIGIN_ALEX_RUN_A_DEF_SPECIAL         set $001F5640

OFFSPECIAL_CONSUME_SP                 set $001F5C4A
FRONTGRAB_OFFSPECIAL_CONSUME_SP       set $001F5D4A
BACKGRAB_OFFSPECIAL_CONSUME_SP        set $001F5E52

ORIGIN_FRONTGRAB_THROW_ADD_SP         set $001F7700
ORIGIN_BACKGRAB_THROW_ADD_SP          set $001F77A0
ORIGIN_DRINK_CUP_ADD_SP               set $001F7B00
ORIGIN_DRINK_TEAPOT_ADD_SP            set $001F7C00

NEW_DISPLAY_KO_SP                     set $001F7E00
ORIGIN_WR_VDP_SIX_DIGITS              set $00008F2C
BYTE_7957                             set $00007957

ORIGIN_DISPLAY_KO_ENEMY_KILL_C1       set $00007913
ORIGIN_DISPLAY_KO_ENEMY_KILL_C2       set $0000794F

ORIGIN_GRANDUPPER_FRAME_ANIMATION     set $001F6B92

ORIGIN_ENMY_KNOCKOUT_CALC_Y_INERTIA   set $0000E99E
ORIGIN_LOC_E9B6                       set $0000E9B6
ORIGIN_ENMY_KNOCKOUT_LY_ON_FLOOR      set $0000E9C2
NEW_ENMY_KNOCKOUT_CALC_Y_INERTIA      set $001F66E0

; Overrides: ---------------------------------------------------------------
        org     ORIGIN_Chk_EnemyCollision
ORIGIN_CHECK_ENEMY_COLLISION:

; --------------------------------------------------------------
        org     ORIGIN_Chk_Hit
ORIGIN_CHECK_HIT:

; --------------------------------------------------------------
        org     ORIGIN_Chk_EnemyCollision_MAX
        jmp     NEW_CHECK_ALEX_AIR_PUNCH_SKIP

; --------------------------------------------------------------
        org     ORIGIN_GRAB_ENEMY
        bne.s   ORIGIN_SKIP_DISPOSE_WEAPON

        org     LOCAL_55A2
ORIGIN_SKIP_DISPOSE_WEAPON:

; --------------------------------------------------------------
        org     ORIGIN_DISPLAY_KO_ENEMY_KILL_C1
        dc.b    $03

        org     ORIGIN_DISPLAY_KO_ENEMY_KILL_C2
        dc.b    $02

; --------------------------------------------------------------
        org     ORIGIN_WR_VDP_SIX_DIGITS
sub_8F2C:

; --------------------------------------------------------------
        org     ORIGIN_ALEX_SUPERMOVE2
        btst    #0,$1E(A2)
        beq     LOCAL_ALEX_VINSIBILITY
        bset    #7,$49(A2)
        bra     SKIP_ALEX_VINSIBILITY
LOCAL_ALEX_VINSIBILITY:
        bclr    #7,$49(A2)
SKIP_ALEX_VINSIBILITY:
        jmp     ORIGIN_ALEX_SUPERMOVE2_IMPL

; --------------------------------------------------------------
        org     ORIGIN_BLAZE_SUPERMOVE2
        btst    #0,$1E(A2)
        beq     LOCAL_BLAZE_VINSIBILITY
        jsr     BLAZE_SUPERMOVE2_END
        rts
LOCAL_BLAZE_VINSIBILITY:
        bclr    #7,$49(A2)
        bsr     ORIGIN_CHECK_ENEMY_COLLISION
        rts

; --------------------------------------------------------------
        org     ORIGIN_HEADBUTT
        jmp     NEW_HEADBUTT

; --------------------------------------------------------------
        org     ORIGIN_INIT_ENMY_CLR_ENMY_SPCFC
        jmp     NEW_INIT_ENMY_CLR_ENMY_SPCFC

; --------------------------------------------------------------
        org     ORIGIN_ENMY_KNOCKOUT_CALC_Y_INERTIA
        jmp     NEW_ENMY_KNOCKOUT_CALC_Y_INERTIA

; --------------------------------------------------------------
        org     ORIGIN_SET_X_SPEED_FOR_AIR_HIT
        ;cmpi.w  #$1D,D0
        ;beq.s   SET_AIR_SPEED_SLOW
        ;cmpi.w  #$1E,D0
        ;beq.s   SET_AIR_SPEED_SLOW
        cmpi.w  #$1F,D0
        bne.s   LOCAL_NEXT
        cmpi.w  #4,$C(A3)
        beq.s   SET_AIR_SPEED_SLOW
        bra.s   SET_AIR_SPEED_NORMAL
LOCAL_NEXT:
        cmpi.w  #$25,D0
        beq.s   SET_AIR_SPEED_SLOW
        cmpi.w  #$20,D0
        beq.s   SET_AIR_SPEED_SLOW
        cmpi.w  #$22,D0
        beq.s   SET_AIR_SPEED_SLOW
        cmpi.w  #$27,D0
        bne.s   SET_AIR_SPEED_NORMAL
SET_AIR_SPEED_SLOW:
        move.w  #1,$92(A2)
        rts
SET_AIR_SPEED_NORMAL:
        move.w  #2,$92(A2)
        rts

        org     ORIGIN_SET_Y_AIR_HIGH
        jmp     NEW_SET_Y_AIR_HIGH

; --------------------------------------------------------------
        ;org     ORIGIN_LOC_5502
        ;jmp     NEW_CHECK_HIT_ENEMY_DEATH

; --------------------------------------------------------------
        org     ORIGIN_ALEX_FFA_TRIGGER
        cmpi.w  #$A,$4E(A2)
        bge.s   loc_1F5586
        jmp     ORIGIN_ALEX_RUN_A_DEF_SPECIAL

loc_1F5586:
        subi.w  #$A,$4E(A2)
        clr.b   $4A(A2)
        move.w  A2,D0
        move.w  D0,-(SP)
        lea     ($FFEF00).w,A2
        tst.w   $82(A2)
        bmi.w   loc_1F55AC
        move.l  #$50060003,D2
        move.l  #$50140003,D3
        jsr     (ORIGIN_DISPLAY_KO_C2).l

loc_1F55AC:
        lea     ($FFF000).w,A2
        tst.w   $82(A2)
        bmi.w   loc_1F55CA
        move.l  #$50300003,D2
        move.l  #$503E0003,D3
        jsr     (ORIGIN_DISPLAY_KO_C2).l

loc_1F55CA:
        move.w  (SP)+,D0
        movea.w D0,A2
        move.b  $52(A2),$4B(A2)
        bclr    #4,$48(A2)
        andi.w  #1,$E(A2)
        ori.w   #$62,$E(A2)
        jmp     ORIGIN_ALEX_SET_RUNNING_ATTACK_MOD

; --------------------------------------------------------------
        org     OFFSPECIAL_CONSUME_SP
        dc.w    $4E71
        dc.w    $4E71
        dc.w    $4E71

        org     FRONTGRAB_OFFSPECIAL_CONSUME_SP
        dc.w    $4E71
        dc.w    $4E71
        dc.w    $4E71

        org     BACKGRAB_OFFSPECIAL_CONSUME_SP
        nop
        nop
        nop

; --------------------------------------------------------------
        org     ORIGIN_GRANDUPPER_FRAME_ANIMATION
        cmpi.w  #2,$18(A2)
        ble.s   loc_1F6BA4
        cmpi.w  #9,$18(A2)
        ble.s   loc_1F6BAC
        rts

loc_1F6BA4:                             ; CODE XREF: ROM:001F6B98↑j
        bset    #7,$49(A2)
        rts

loc_1F6BAC:                             ; CODE XREF: ROM:001F6BA0↑j
        move.b  $4B(A2),D6
        btst    #3,D6
        beq.s   loc_left
        ;cmpi.w  #3,$18(A2)
        ;ble.s   loc_right_faster
        addi.l  #$1C000,$40(A2)
        rts
loc_right_faster:
        addi.l  #$20000,$40(A2)
        rts

loc_left:                               ; CODE XREF: ROM:001F6BB4↑j
        btst    #2,D6
        beq.s   locret_1F6BCE
        ;cmpi.w  #3,$18(A2)
        ;ble.s   loc_left_faster
        subi.l  #$1C000,$40(A2)
locret_1F6BCE:                          ; CODE XREF: ROM:001F6BC4↑j
        rts

loc_left_faster:
        subi.l  #$20000,$40(A2)
        rts

; --------------------------------------------------------------
        org     ORIGIN_FRONTGRAB_THROW_ADD_SP
        bclr    #5,$49(A2)
        addi.w  #$2,$4E(A2)
        move.w  $4C(A2),D0
        cmp.w   $4E(A2),D0
        bge.s   ORIGIN_FRONTGRAB_THROW_DISPLAY_SP
        move.w  D0,$4E(A2)
        bra.s   ORIGIN_FRONTGRAB_THROW_DISPLAY_SP
        nop
        nop
        nop
        nop
        nop
        nop
ORIGIN_FRONTGRAB_THROW_DISPLAY_SP:

        org     ORIGIN_BACKGRAB_THROW_ADD_SP
        move.w  #$20,(A2)
        addi.w  #$2,$4E(A2)
        move.w  $4C(A2),D0
        cmp.w   $4E(A2),D0
        bge.s   ORIGIN_BACKGRAB_THROW_DISPLAY_SP
        move.w  D0,$4E(A2)
        bra.s   ORIGIN_BACKGRAB_THROW_DISPLAY_SP
        nop
        nop
        nop
        nop
        nop
        nop
        nop
ORIGIN_BACKGRAB_THROW_DISPLAY_SP:

        org     ORIGIN_DRINK_CUP_ADD_SP
        addi.w  #$A,$4E(A2)
        move.w  $4C(A2),D0
        cmp.w   $4E(A2),D0
        bge.s   ORIGIN_DRINK_CUP_DISPLAY_SP
        move.w  D0,$4E(A2)
        bra.s   ORIGIN_DRINK_CUP_DISPLAY_SP
        nop
        nop
        nop
        nop
        nop
ORIGIN_DRINK_CUP_DISPLAY_SP:

        org     ORIGIN_DRINK_TEAPOT_ADD_SP
        addi.w  #$14,$4E(A2)
        move.w  $4C(A2),D0
        cmp.w   $4E(A2),D0
        bge.s   ORIGIN_DRINK_TEAPOT_DISPLAY_SP
        move.w  D0,$4E(A2)
        bra.s   ORIGIN_DRINK_TEAPOT_DISPLAY_SP
        nop
        nop
        nop
        nop
        nop
ORIGIN_DRINK_TEAPOT_DISPLAY_SP:

; --------------------------------------------------------------
        org     ORIGIN_CHK_ENMY_COLLISION_HIT_SP
        jsr     (ORIGIN_PLAY_SOUND).l
        move.w  $E(A2),D0
        lsr.w   #1,D0
        cmpi.w  #$25,D0
        bne.s   INIT_MAX_SP
        rts
INIT_MAX_SP:
        cmpi.w  #0,$4C(A2)
        bne.s   MAX_THROW_ADD_SP
        move.w  #0,$C0(A2)
        move.w  #$64,$4C(A2)
MAX_THROW_ADD_SP:
        cmpi.w  #$29,D0
        bne.s   HIT_ADD_SP
        addi.w  #2,$4E(A2)
        addq.w  #1,$C0(A2)

HIT_ADD_SP:
        cmpi.w  #0,$5E(A3)
        bne.s   CHECK_AIR_HIT_ADD_MAX_SP
        cmpi.w  #2,$C(A2)
        bne.s   INCREASE_SP
        cmpi.w  #$31,D0
        beq.s   CHECK_SP_IN_MAX_VALUE
        cmpi.w  #$24,D0
        beq.s   CHECK_SP_IN_MAX_VALUE
INCREASE_SP:
        addq.w  #1,$4E(A2)
        bra.s   CHECK_SP_IN_MAX_VALUE
CHECK_AIR_HIT_ADD_MAX_SP:
        cmpi.w  #$31,D0
        bne.s   CHECK_IS_AIR_FFB_ADD_MAX_SP
        bra.s   CHECK_SP_IN_MAX_VALUE
CHECK_IS_AIR_FFB_ADD_MAX_SP:
        cmpi.w  #$24,D0
        bne.s   INCREASE_MAX_SP
CHECK_ENMY_IS_FALL_DOWN:
        tst.l   $2E(A3)
        ble.s   CHECK_SP_IN_MAX_VALUE
        addq.w  #1,$C0(A2)
INCREASE_MAX_SP:
        addq.w  #1,$C0(A2)
        cmpi.w  #10,$C0(A2)
        blt.s   CHECK_COMBO_END
        addq.w  #1,$4C(A2)
        subi.w  #10,$C0(A2)
        
CHECK_COMBO_END:
        cmpi.w  #$1F,D0
        bne.s   CHECK_SP_IN_MAX_VALUE
        addq.w  #1,$4E(A2)

CHECK_SP_IN_MAX_VALUE:
        move.w  $4C(A2),D0
        cmp.w   $4E(A2),D0
        bge.s   DISPLAY_1P_SP
        move.w  D0,$4E(A2)

DISPLAY_1P_SP:
        move.w  A2,D0
        move.w  D0,-(SP)
        lea     ($FFEF00).l,A2
        tst.w   $82(A2)
        bmi.w   DISPLAY_2P_SP
        move.l  #$50060003,D2
        move.l  #$50140003,D3
        jsr     NEW_DISPLAY_KO_SP

DISPLAY_2P_SP:
        lea     ($FFF000).l,A2
        tst.w   $82(A2)
        bmi.w   loc_24E82
        move.l  #$50300003,D2
        move.l  #$503E0003,D3
        jsr     NEW_DISPLAY_KO_SP

loc_24E82:
        move.w  (SP)+,D0
        movea.w D0,A2
        rts

; Change: ---------------------------------------------------------------
        org     NEW_ENMY_KNOCKOUT_CALC_Y_INERTIA
        move.l  $2E(A2),D0
        add.l   D0,$5E(A2)
        ; Check enemy === marking grand upper Y inertia === when knockout
        cmpi.b  #1,$4F(A2)
        beq.s   NEW_ENMY_KNOWOUT_GRANDUPPER_Y_INERTIA
        addi.l  #$3000,$2E(A2)
        bmi.s   GOTO_E9B6
        bra.s   NEW_ENMY_KNOWOUT_CHK_ON_GROUND
NEW_ENMY_KNOWOUT_GRANDUPPER_Y_INERTIA:
        addi.l  #$4000,$2E(A2)
        bmi.s   GOTO_E9B6
NEW_ENMY_KNOWOUT_CHK_ON_GROUND:
        tst.w   $5E(A2)
        bpl.s   NEW_ENMY_KNOWOUT_ON_GROUND
GOTO_E9B6:
        jmp     ORIGIN_LOC_E9B6
NEW_ENMY_KNOWOUT_ON_GROUND:
        bclr    #7,$49(A2)
        ; Clear enemy === marking skip next air combo end === to alow normal combo
        sf      $4E(A2)
        ; Clear enemy === marking grand upper Y inertia === when knockout
        sf      $4F(A2)
        jmp     ORIGIN_ENMY_KNOCKOUT_LY_ON_FLOOR

; --------------------------------------------------------------
        org     NEW_SET_Y_AIR_HIGH
        move.w  $E(A3),D0
        lsr.w   #1,D0

        ; Check whether the enemy is in air or on the ground. Value 0 means on the ground.
        cmpi.w  #0,$5E(A2)
        beq     NEW_SET_Y_AIR_CHECK_GRANDUPPER

        ; Check whether the Animation is air normal punch
        cmpi.w  #$1D,D0
        bne.s     NEW_SET_Y_AIR_CHECK_3RD_PUNCH
        ; Set the Y air inertia. Negative value means move Up, the bigger of the value, the faster on the Y direction.
        move.l  #$FFFF3600,$2E(A2)

        ;cmpi.l  #$FFF60000,$5E(A2)
        ;bge.s   NEW_SET_Y_AIR_COMBO_CATCH_UP
        ;move.l  #$FFFF3500,$2E(A2)
        ;bra.s   NEW_SET_Y_AIR_NORMAL_PUNCH_RETURN
;NEW_SET_Y_AIR_COMBO_CATCH_UP:
        ;move.l  #$FFFE8000,$2E(A2)

NEW_SET_Y_AIR_NORMAL_PUNCH_RETURN:
        move.w  #0,$92(A2)
        rts

NEW_SET_Y_AIR_CHECK_3RD_PUNCH:
        cmpi.w  #$1E,D0
        bne.s   NEW_SET_Y_AIR_CHECK_COMBO_END
        move.l  #$FFFE8000,$2E(A2)
        move.w  #0,$92(A2)
        rts

NEW_SET_Y_AIR_CHECK_COMBO_END:
        cmpi.w  #$1F,D0
        bne.s   NEW_SET_Y_AIR_CHECK_FF_A

        ; Check the FrameId at $18 character variable. From the begin to the end the FrameId is decreasing
        cmpi.w  #2,$18(A3)
        ble.s   NEW_SET_Y_AIR_COMBO_END_MATCH_LAST_TWO_FRAMES
        move.l  #$FFFE8000,$2E(A2)
        move.w  #0,$92(A2)
        rts

NEW_SET_Y_AIR_COMBO_END_MATCH_LAST_TWO_FRAMES:
        cmpi.w  #2,$C(A3)
        bne.s   NEW_SET_Y_AIR_COMBO_END_RETURN

        ; Set enemy === marking skip next air combo end === so that next air combo will be skipped
        move.b  #1,$4E(A2)
NEW_SET_Y_AIR_COMBO_END_RETURN:
        move.l  #$FFFAC400,$2E(A2)
        rts

        ; Check whether the Animation is air F-Foward A
NEW_SET_Y_AIR_CHECK_FF_A:
        cmpi.w  #$31,D0
        bne.s   NEW_SET_Y_AIR_CHECK_GRANDUPPER
        cmpi.w  #4,$C(A3)
        bne.s   NEW_SET_Y_AIR_CHECK_FF_A_ALEX
        cmpi.w  #$E,$18(A3)
        bgt.s   NEW_SET_Y_AIR_MATCH_FF_A
        bra     NEW_SET_Y_AIR_NORMAL_RETURN
NEW_SET_Y_AIR_CHECK_FF_A_ALEX:
        cmpi.w  #2,$C(A3)
        bne.s   NEW_SET_Y_AIR_NORMAL_RETURN
        cmpi.w  #6,$18(A3)
        bgt.s   NEW_SET_Y_AIR_MATCH_FF_A
        move.l  #$FFFAC400,$2E(A2)
        cmpi.w  #4,$18(A3)
        bgt.s   NEW_SET_Y_AIR_MATCH_FF_A_RETURN
        move.l  #$FFFA9000,$2E(A2)
        bclr    #7,$49(A2)
NEW_SET_Y_AIR_MATCH_FF_A_RETURN:
        rts

NEW_SET_Y_AIR_MATCH_FF_A:
        move.l  #$FFFE8000,$2E(A2)
        move.w  #1,$92(A2)
        rts

        ; Check whether the Animation is Alex's Grandupper
NEW_SET_Y_AIR_CHECK_GRANDUPPER:
        cmpi.w  #$24,D0
        bne.s   NEW_SET_Y_AIR_CHECK_OFFSPECIAL
        cmpi.w  #2,$C(A3)
        bne.s   NEW_SET_Y_AIR_NORMAL_RETURN
        move.l  #$FFFBD000,$2E(A2)
        cmpi.w  #4,$18(A3)
        bgt.s   NEW_SET_Y_AIR_MATCH_GRANDUPPER_RETURN
        move.w  #3,$92(A2)
        ; Set enemy === marking grand upper Y inertia ===
        move.b  #1,$4F(A2)
        move.l  #$FFFAC400,$2E(A2)
        bclr    #7,$49(A2)
NEW_SET_Y_AIR_MATCH_GRANDUPPER_RETURN:
        rts

        ; Check whether the Animation is off special no matter air or on the ground
NEW_SET_Y_AIR_CHECK_OFFSPECIAL:
        cmpi.w  #$25,D0
        beq.s   NEW_SET_Y_AIR_MATCH_OFFSPECIAL
NEW_SET_Y_AIR_NORMAL_RETURN:
        move.l  #$FFFAC400,$2E(A2)
        rts

NEW_SET_Y_AIR_MATCH_OFFSPECIAL:
        jmp     ORIGIN_SET_Y_AIR_MATCH_OFFSPECIAL

; --------------------------------------------------------------
        org     NEW_CHECK_ALEX_AIR_PUNCH_SKIP
        ; Check enemy === marking skip next air combo end === so to skip this air combo
        cmpi.b  #1,$4E(A3)
        bne.s   NEW_CHECK_ALEX_AIR_PUNCH_MAX
        ;cmpi.w  #0,$5E(A3)
        ;bne.s   CHECK_IS_ALEX_AIR_PUNCH_SKIP
        ; Clear enemy === marking skip next air combo end === to alow normal combo
        ;sf      $4E(A3)
        ;bra.s   NEW_CHECK_ALEX_AIR_PUNCH_MAX

CHECK_IS_ALEX_AIR_PUNCH_SKIP:
        cmpi.w  #2,$C(A2)
        bne.s   NEW_CHECK_ALEX_AIR_PUNCH_MAX
        move.w  $E(A2),D0
        lsr.w   #1,D0
        cmpi.w  #$1D,D0
        beq.s   NEW_MATCH_ALEX_AIR_PUNCH_SKIP
        cmpi.w  #$1E,D0
        beq.s   NEW_MATCH_ALEX_AIR_PUNCH_SKIP
        cmpi.w  #$1F,D0
        beq.s   NEW_MATCH_ALEX_AIR_PUNCH_SKIP
        bra.s   NEW_CHECK_ALEX_AIR_PUNCH_SKIP_SKATE

NEW_MATCH_ALEX_AIR_PUNCH_SKIP:
        jmp     ORIGIN_LOC_4E8E

NEW_CHECK_ALEX_AIR_PUNCH_MAX:
        cmpi.w  #0,$C(A2)
        bne.s   NEW_CHECK_ALEX_AIR_PUNCH_RETURN
        move.w  $E(A2),D0
        andi.w  #$FFFE,D0
        cmpi.w  #$52,D0
        beq.s   NEW_CHECK_ALEX_AIR_PUNCH_SKIP_SKATE
NEW_CHECK_ALEX_AIR_PUNCH_RETURN:
        jmp     ORIGIN_LOC_4D42
NEW_CHECK_ALEX_AIR_PUNCH_SKIP_SKATE:
        jmp     ORIGIN_LOC_4D5C

; --------------------------------------------------------------
;NEW_CHECK_HIT_ENEMY_DEATH:
;        btst    #6,$49(A2)
;        beq.s   NEW_CHECK_HIT_NORMAL_HIT
;        sf      $49(A2)
;        move.w  #3,$92(A2)
;        move.l  #$FFFAC400,$2E(A2)
;        ori.w   #$14,D1
;        move.w  D1,$E(A1)
;        move.w  #6,0(A2)
;        jsr     ORIGIN_DISPOSE_WEAPON
;        addq.w  #4,SP
;        rts
;NEW_CHECK_HIT_NORMAL_HIT:
;        sf      $49(A2)
;        bset    #7,$49(A2)
;        move.w  #0,$92(A2)
;        move.l  #$FFFAC400,$2E(A2)
;        ori.w   #$14,D1
;        clr     $80(A2)
;        move.w  D1,$E(A1)
;        move.w  #6,0(A2)
;        jsr     ORIGIN_DISPOSE_WEAPON
;        addq.w  #4,SP
;        rts

; --------------------------------------------------------------
        org NEW_DISPLAY_KO_SP
        clr.l   ($FFFFFC94).w
        move.w  $4C(A2),D1
        subq.w  #1,D1
        bmi.s   loc_790E

loc_78F2:                ; CODE XREF: Display_KO_Enemy_Kill+24j
        move    #4,ccr
        move.w  #2,D0
        lea     ($FFFFFC97).w,A0
        lea     (BYTE_7957).l,A1

loc_7904:                ; CODE XREF: Display_KO_Enemy_Kill+20j
        abcd    -(A1),-(A0)
        dbf     D0,loc_7904
        dbf     D1,loc_78F2

loc_790E:                ; CODE XREF: Display_KO_Enemy_Kill+Aj
        lea     ($FFFFFC94).w,A0
        move.l  D3,D1
        jsr     sub_8F2C
        move.w  #$3A,D0    ; '*'
        add.w   ($FFFFFC12).w,D0
        move.w  D0,(A1)
        move.w  $C0(A2),D0
        addi.b  #$30,D0    ; '0'
        add.w   ($FFFFFC12).w,D0
        move.w  D0,(A1)
        clr.l   ($FFFFFC94).w
        move.w  $4E(A2),D1
        subq.w  #1,D1
        bmi.s   loc_794A

loc_792E:                ; CODE XREF: Display_KO_Enemy_Kill+60j
        move    #4,ccr
        move.w  #2,D0
        lea     ($FFFFFC97).w,A0
        lea     (BYTE_7957).l,A1

loc_7940:                ; CODE XREF: Display_KO_Enemy_Kill+5Cj
        abcd    -(A1),-(A0)
        dbf     D0,loc_7940
        dbf     D1,loc_792E

loc_794A:                ; CODE XREF: Display_KO_Enemy_Kill+46j
        lea     ($FFFFFC94).w,A0
        move.l  D2,D1
        jsr     sub_8F2C
        move.w  #$2F,D0    ; '/'
        add.w   ($FFFFFC12).w,D0
        move.w  D0,(A1)
        rts

; --------------------------------------------------------------
        org     BLAZE_SUPERMOVE2_END
        bset    #7,$49(A2)
        clr.l   $5E(A2)
        andi.w  #1,$E(A2)
        ori.w   #0,$E(A2)
        move.w  #2,0(A2)
        sf      $9E(A2)
        rts

; --------------------------------------------------------------
        org     NEW_INIT_ENMY_CLR_ENMY_SPCFC
        ; Clear enemy === marking skip next air combo end === to alow normal combo
        sf      $4E(A2)
        ; Clear enemy === marking grand upper Y inertia === when knockout
        sf      $4F(A2)
        clr.w   $D0(a0)
        clr.w   $D2(a0)
        clr.w   $D4(a0)
        jmp     ORIGIN_INIT_ENMY_CLR_ENMY_D6

; --------------------------------------------------------------
        org     NEW_HEADBUTT
        jsr     ORIGIN_CHK_HIT
        btst    #0,$1E(A2)   
        bne.s   LOCAL_CHK_ENMY_DEATH
        jsr     ORIGIN_CHECK_ENEMY_COLLISION
        movea.l $86(A2),A3
        cmpi.w  #6,$0(A3)
        bne.s   LOCAL_HEADBUTT_RETURN
        btst    #5,$49(A2)
        beq.s   LOCAL_HEADBUTT_RETURN
        bclr    #5,$49(A2)
LOCAL_HEADBUTT_RETURN:
        rts
LOCAL_CHK_ENMY_DEATH:
        jmp     ORIGIN_HEADBUTT_ENMY_DEATH
