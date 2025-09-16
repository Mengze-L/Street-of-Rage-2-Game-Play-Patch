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

NEW_CHECK_ALEX_AIR_PUNCH_SKIP         set $001F7C80

ORIGIN_LOC_4D2C                       set $00004D2C
ORIGIN_LOC_4D42                       set $00004D42
ORIGIN_LOC_4D5C                       set $00004D5C
ORIGIN_LOC_4E8E                       set $00004E8E

ORIGIN_SUB_24E00                      set $00024E00
ORIGIN_PLAY_SOUND                     set $00040008

OFFSPECIAL_CONSUME_SP                 set $001F5C4A
FRONTGRAB_OFFSPECIAL_CONSUME_SP       set $001F5D4A
BACKGRAB_OFFSPECIAL_CONSUME_SP        set $001F5E52

ORIGIN_FRONTGRAB_THROW_ADD_SP         set $001F7700
ORIGIN_BACKGRAB_THROW_ADD_SP          set $001F77A0
ORIGIN_DRINK_CUP_ADD_SP               set $001F7B00
ORIGIN_DRINK_TEAPOT_ADD_SP            set $001F7C00

NEW_DISPLAY_KO_SP                     set $001F7E00
ORIGIN_SUB_8F2C                       set $00008F2C
BYTE_7957                             set $00007957

ORIGIN_DISPLAY_KO_ENEMY_KILL_C1       set $00007913
ORIGIN_DISPLAY_KO_ENEMY_KILL_C2       set $0000794F

; Overrides: ---------------------------------------------------------------
        org     SUB_4CBE
ORIGIN_CHECK_ENEMY_COLLISION:

        org     ORIGIN_GRAB_ENEMY
        bne.s   ORIGIN_SKIP_DISPOSE_WEAPON

        org     LOCAL_55A2
ORIGIN_SKIP_DISPOSE_WEAPON:

        org     ORIGIN_DISPLAY_KO_ENEMY_KILL_C1
        dc.b    $03

        org     ORIGIN_DISPLAY_KO_ENEMY_KILL_C2
        dc.b    $02

        org     ORIGIN_SUB_8F2C
sub_8F2C:

        org     ORIGIN_ALEX_SUPERMOVE2
        btst    #0,$1E(A2)
        beq     LOCAL_ALEX_VINSIBILITY
        bset    #7,$49(A2)
        bra     SKIP_ALEX_VINSIBILITY
LOCAL_ALEX_VINSIBILITY:
        bclr    #7,$49(A2)
SKIP_ALEX_VINSIBILITY:
        jmp     ORIGIN_ALEX_SUPERMOVE2_IMPL

        org     ORIGIN_BLAZE_SUPERMOVE2
        btst    #0,$1E(A2)
        beq     LOCAL_BLAZE_VINSIBILITY
        jsr     BLAZE_SUPERMOVE2_END
        rts
LOCAL_BLAZE_VINSIBILITY:
        bclr    #7,$49(A2)
        bsr     ORIGIN_CHECK_ENEMY_COLLISION
        rts

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

        org     ORIGIN_LOC_4D2C
        jmp     NEW_CHECK_ALEX_AIR_PUNCH_SKIP

        org     ORIGIN_SUB_24E00
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
        bne.s   COMBO_ADD_SP
        addi.w  #2,$4E(A2)
        addq.w  #1,$C0(A2)

COMBO_ADD_SP:
        addq.w  #1,$4E(A2)
        cmpi.w  #0,$5E(A3)
        beq.s   CHECK_SP_IN_MAX_VALUE
        addq.w  #1,$4E(A2)
        cmpi.w  #$31,D0
        beq.s   CHECK_SP_IN_MAX_VALUE
        cmpi.w  #$24,D0
        beq.s   CHECK_SP_IN_MAX_VALUE
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
        ;bclr    #7,$49(A2)
        move.b  #1,$4E(A2)
        bra.s   NEW_SET_Y_AIR_NORMAL_RETURN

        ; Check whether the Animation is air F-Foward A
NEW_SET_Y_AIR_CHECK_FF_A:
        cmpi.w  #$31,D0
        bne.s   NEW_SET_Y_AIR_CHECK_GRANDUPPER
        cmpi.w  #4,$C(A3)
        bne.s   NEW_SET_Y_AIR_CHECK_FF_A_ALEX
        cmpi.w  #$E,$18(A3)
        bgt     NEW_SET_Y_AIR_MATCH_FF_A
        bra.s   NEW_SET_Y_AIR_NORMAL_RETURN
NEW_SET_Y_AIR_CHECK_FF_A_ALEX:
        cmpi.w  #2,$C(A3)
        bne.s   NEW_SET_Y_AIR_NORMAL_RETURN
        cmpi.w  #6,$18(A3)
        bgt.s   NEW_SET_Y_AIR_MATCH_FF_A
        move.l  #$FFFAC400,$2E(A2)
        cmpi.w  #4,$18(A3)
        bgt.s   NEW_SET_Y_AIR_MATCH_FF_A_RETURN
        bclr    #7,$49(A2)
NEW_SET_Y_AIR_MATCH_FF_A_RETURN:
        rts

        ; Check whether the Animation is Alex's Grandupper
NEW_SET_Y_AIR_CHECK_GRANDUPPER:
        cmpi.w  #$24,D0
        bne.s   NEW_SET_Y_AIR_CHECK_OFFSPECIAL
        cmpi.w  #2,$C(A3)
        bne.s   NEW_SET_Y_AIR_NORMAL_RETURN
        cmpi.w  #2,$18(A3)
        bgt.s   NEW_SET_Y_AIR_NORMAL_RETURN
        bclr    #7,$49(A2)
        bra.s   NEW_SET_Y_AIR_NORMAL_RETURN

        ; Check whether the Animation is off special no matter air or on the ground
NEW_SET_Y_AIR_CHECK_OFFSPECIAL:
        cmpi.w  #$25,D0
        beq.s   NEW_SET_Y_AIR_MATCH_OFFSPECIAL
NEW_SET_Y_AIR_NORMAL_RETURN:
        move.l  #$FFFAC400,$2E(A2)
        rts

NEW_SET_Y_AIR_MATCH_OFFSPECIAL:
        jmp     ORIGIN_SET_Y_AIR_MATCH_OFFSPECIAL

NEW_SET_Y_AIR_MATCH_NORMAL_PUNCH:
        ; Set the Y air inertia. As negative value, the bigger of the value, the lower of the Y position.
        ;move.l  #$FFFF3600,$2E(A2)
        ;bra.s   NEW_SET_Y_AIR_COMBO_RETURN
        cmpi.l  #$FFF60000,$5E(A2)
        bge.s   NEW_SET_Y_AIR_COMBO_CATCH_UP
        move.l  #$FFFF3500,$2E(A2)
        bra.s   NEW_SET_Y_AIR_COMBO_RETURN
NEW_SET_Y_AIR_COMBO_CATCH_UP:
        move.l  #$FFFE8000,$2E(A2)
        bra.s   NEW_SET_Y_AIR_COMBO_RETURN

NEW_SET_Y_AIR_MATCH_COMBO_DEFAULT:
        move.l  #$FFFE8000,$2E(A2)
NEW_SET_Y_AIR_COMBO_RETURN:
        move.w  #0,$92(A2)
        rts

NEW_SET_Y_AIR_MATCH_FF_A:
        move.l  #$FFFE8000,$2E(A2)
        move.w  #1,$92(A2)
        rts

        org     NEW_CHECK_ALEX_AIR_PUNCH_SKIP
        cmpi.b  #1,$4E(A3)
        bne.s   NEW_CHECK_ALEX_AIR_PUNCH_MAX
        cmpi.w  #0,$5E(A3)
        bne.s   CHECK_IS_ALEX_AIR_PUNCH_SKIP
        sf      $4E(A3)
        bra.s   NEW_CHECK_ALEX_AIR_PUNCH_MAX

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

        org NEW_DISPLAY_KO_SP
        clr.l   ($FFFFFC94).w
        move.w  $4C(A2),d1
        subq.w  #1,d1
        bmi.s   loc_790E

loc_78F2:                ; CODE XREF: Display_KO_Enemy_Kill+24j
        move    #4,ccr
        move.w  #2,d0
        lea     ($FFFFFC97).w,a0
        lea     (BYTE_7957).l,a1

loc_7904:                ; CODE XREF: Display_KO_Enemy_Kill+20j
        abcd    -(a1),-(a0)
        dbf     d0,loc_7904
        dbf     d1,loc_78F2

loc_790E:                ; CODE XREF: Display_KO_Enemy_Kill+Aj
        lea     ($FFFFFC94).w,a0
        move.l  d3,d1
        jsr     sub_8F2C
        move.w  #$3A,d0    ; '*'
        add.w   ($FFFFFC12).w,d0
        move.w  d0,(a1)
        move.w  $C0(A2),D0
        addi.b  #$30,D0    ; '0'
        add.w   ($FFFFFC12).w,d0
        move.w  d0,(a1)
        clr.l   ($FFFFFC94).w
        move.w  $4E(a2),d1
        subq.w  #1,d1
        bmi.s   loc_794A

loc_792E:                ; CODE XREF: Display_KO_Enemy_Kill+60j
        move    #4,ccr
        move.w  #2,d0
        lea     ($FFFFFC97).w,a0
        lea     (BYTE_7957).l,a1

loc_7940:                ; CODE XREF: Display_KO_Enemy_Kill+5Cj
        abcd    -(a1),-(a0)
        dbf     d0,loc_7940
        dbf     d1,loc_792E

loc_794A:                ; CODE XREF: Display_KO_Enemy_Kill+46j
        lea     ($FFFFFC94).w,a0
        move.l  d2,d1
        jsr     sub_8F2C
        move.w  #$2F,d0    ; '/'
        add.w   ($FFFFFC12).w,d0
        move.w  d0,(a1)
        rts
