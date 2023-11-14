; define sprite variants by selecting tile n° and setting OAM attributes (palette + flags) in a list
GoriyaSpriteVariants::
.variant0
    db $60, $01
    db $62, $01
.variant1
    db $62, $21
    db $60, $21
.variant2
    db $64, $01
    db $66, $01
.variant3
    db $66, $21
    db $64, $21
.variant4
    db $68, $01
    db $6A, $01
.variant5
    db $6C, $01
    db $6E, $01
.variant6
    db $6A, $21
    db $68, $21
.variant7
    db $6E, $21
    db $6C, $21

; Note that the Goriya entity is called from the masked mimic code.
GoriyaEntityHandler::
    ld   hl, wEntitiesPhysicsFlagsTable           ; $45E4: $21 $40 $C3
    add  hl, bc                                   ; $45E7: $09
    set  ENTITY_PHYSICS_B_PROJECTILE_NOCLIP, [hl] ; $45E8: $CB $F6
    set  ENTITY_PHYSICS_B_HARMLESS, [hl]          ; $45EA: $CB $FE
    ld   a, [wTradeSequenceItem]                  ; $45EC: $FA $0E $DB
    cp   TRADING_ITEM_MAGNIFYING_LENS             ; $45EF: $FE $0E
    jp   nz, ClearEntityStatus_19                 ; $45F1: $C2 $61 $7E

    ld   a, [wExchangingTradeSequenceItem]        ; $45F4: $FA $7F $DB
    and  a                                        ; $45F7: $A7
    jp   nz, ClearEntityStatus_19                 ; $45F8: $C2 $61 $7E

    ld   hl, wEntitiesPosXTable                   ; $45FB: $21 $00 $C2
    add  hl, bc                                   ; $45FE: $09
    ld   [hl], $50                                ; $45FF: $36 $50
    ld   de, GoriyaSpriteVariants                 ; $4601: $11 $C4 $45
    call RenderActiveEntitySpritesPair            ; $4604: $CD $C0 $3B
    call func_019_7CD4                            ; $4607: $CD $D4 $7C
    ldh  a, [hFrameCounter]                       ; $460A: $F0 $E7
    and  $3F                                      ; $460C: $E6 $3F
    jr   nz, .jr_4618                             ; $460E: $20 $08

    call func_019_7E3A                            ; $4610: $CD $3A $7E
    ld   hl, wEntitiesDirectionTable              ; $4613: $21 $80 $C3
    add  hl, bc                                   ; $4616: $09
    ld   [hl], e                                  ; $4617: $73

.jr_4618
    call PushLinkOutOfEntity_19                   ; $4618: $CD $A2 $7C
    ldh  a, [hActiveEntityState]                  ; $461B: $F0 $F0
    JP_TABLE                                      ; $461D
._00 dw GoriyaState0Handler
._01 dw GoriyaState1Handler
._02 dw GoriyaState2Handler
._03 dw GoriyaState3Handler

GoriyaState0Handler::
    call ReturnIfNonInteractive_19                ; $4626: $CD $3D $7D
    ld   e, b                                     ; $4629: $58
    ldh  a, [hLinkPositionY]                      ; $462A: $F0 $99
    ld   hl, hActiveEntityPosY                    ; $462C: $21 $EF $FF
    sub  [hl]                                     ; $462F: $96
    add  $26                                      ; $4630: $C6 $26
    cp   $4C                                      ; $4632: $FE $4C
Data_019_4634::
    call func_019_7CFB                            ; $4634: $CD $FB $7C
    ret  nc                                       ; $4637: $D0

    ld   a, [wBoomerangTradedItem]                ; $4638: $FA $7D $DB
    cp   $00                                      ; $463B: $FE $00
    jr   z, .jr_4643                              ; $463D: $28 $04

    cp   $0D                                      ; $463F: $FE $0D
    jr   nz, jr_019_4663                          ; $4641: $20 $20

.jr_4643
    call_open_dialog Dialog221                    ; $4643
    jp   IncrementEntityState                     ; $4648: $C3 $12 $3B

; Unused data
Data_019_454B::
    db   $F3, $51, $67, $28, $F3, $51, $67, $28, $D9, $11, $CE, $10, $17, $14, $08, $10
    db   $D9, $11, $CE, $10, $F3, $51, $67, $28

jr_019_4663:
    call_open_dialog Dialog225                    ; $4663: $3E $25 $CD $7C $23
    ld   a, [wBoomerangTradedItem]                ; $4668: $FA $7D $DB
    sla  a                                        ; $466B: $CB $27
    sla  a                                        ; $466D: $CB $27
    ld   e, a                                     ; $466F: $5F
    ld   d, $00                                   ; $4670: $16 $00
    ld   hl, Data_019_4634 - 1                    ; $4672: $21 $33 $46
    add  hl, de                                   ; $4675: $19
    ld   e, l                                     ; $4676: $5D
    ld   d, h                                     ; $4677: $54
    ld   hl, wObjPal8 + 1*2                       ; $4678: $21 $8A $DC

.loop_467B
    ld   a, [de]                                  ; $467B: $1A
    ld   [hl+], a                                 ; $467C: $22
    inc  de                                       ; $467D: $13
    ld   a, l                                     ; $467E: $7D
    and  $0F                                      ; $467F: $E6 $0F
    cp   $0E                                      ; $4681: $FE $0E
    jr   nz, .loop_467B                           ; $4683: $20 $F6

    ld   a, $02                                   ; $4685: $3E $02
    ld   [wPaletteDataFlags], a                   ; $4687: $EA $D1 $DD
    call IncrementEntityState                     ; $468A: $CD $12 $3B
    ld   [hl], $03                                ; $468D: $36 $03
    ret                                           ; $468F: $C9

GoriyaState1Handler::
    call ReturnIfNonInteractive_19                ; $4690: $CD $3D $7D
    call IncrementEntityState                     ; $4693: $CD $12 $3B
    ld   a, [wDialogAskSelectionIndex]            ; $4696: $FA $77 $C1
    and  a                                        ; $4699: $A7
    jr   nz, jr_019_46DB                          ; $469A: $20 $3F

    ld   a, [wInventoryItems.BButtonSlot]         ; $469C: $FA $00 $DB
    and  a                                        ; $469F: $A7
    jr   z, jr_019_46DB                           ; $46A0: $28 $39

.jr_46A2
    cp   INVENTORY_SWORD                          ; $46A2: $FE $01
    jr   z, jr_019_46E1                           ; $46A4: $28 $3B

    cp   INVENTORY_SHIELD                         ; $46A6: $FE $04
    jr   z, jr_019_46E1                           ; $46A8: $28 $37

    cp   INVENTORY_POWER_BRACELET                 ; $46AA: $FE $03
    jr   z, jr_019_46E1                           ; $46AC: $28 $33

    cp   INVENTORY_BOMBS                          ; $46AE: $FE $02
    jr   z, jr_019_46E1                           ; $46B0: $28 $2F

    cp   INVENTORY_OCARINA                        ; $46B2: $FE $09
    jr   z, jr_019_46E1                           ; $46B4: $28 $2B

    cp   INVENTORY_MAGIC_POWDER                   ; $46B6: $FE $0C
    jr   z, jr_019_46E1                           ; $46B8: $28 $27

    cp   INVENTORY_BOW                            ; $46BA: $FE $05
    jr   z, jr_019_46E1                           ; $46BC: $28 $23

    ld   [wBoomerangTradedItem], a                ; $46BE: $EA $7D $DB
    ld   a, INVENTORY_BOOMERANG                   ; $46C1: $3E $0D
    ld   [wInventoryItems.BButtonSlot], a         ; $46C3: $EA $00 $DB
    ld   hl, wEntitiesPrivateState1Table          ; $46C6: $21 $B0 $C2
    add  hl, bc                                   ; $46C9: $09
    ld   [hl], a                                  ; $46CA: $77
    call GetEntityTransitionCountdown             ; $46CB: $CD $05 $0C
    ld   [hl], $80                                ; $46CE: $36 $80
    ld   a, $01                                   ; $46D0: $3E $01
    ld   [wC167], a                               ; $46D2: $EA $67 $C1
    ld   a, MUSIC_OBTAIN_ITEM                     ; $46D5: $3E $10
    ld   [wMusicTrackToPlay], a                   ; $46D7: $EA $68 $D3
    ret                                           ; $46DA: $C9

jr_019_46DB:
    ld   [hl], b                                  ; $46DB: $70
    jp_open_dialog Dialog223                      ; $46DC

jr_019_46E1:
    ld   [hl], b                                  ; $46E1: $70
    jp_open_dialog Dialog227                      ; $46E2

GoriyaState3Handler::
    call ReturnIfNonInteractive_19                ; $46E7: $CD $3D $7D
    call IncrementEntityState                     ; $46EA: $CD $12 $3B
    ld   [hl], $02                                ; $46ED: $36 $02
    ld   a, [wDialogAskSelectionIndex]            ; $46EF: $FA $77 $C1
    and  a                                        ; $46F2: $A7
    jr   nz, jr_019_4725                          ; $46F3: $20 $30

    ld   hl, wInventoryItems.BButtonSlot          ; $46F5: $21 $00 $DB
    ld   de, $0000                                ; $46F8: $11 $00 $00

.loop_46FB
    ld   a, [hl]                                  ; $46FB: $7E
    cp   INVENTORY_BOOMERANG                      ; $46FC: $FE $0D
    jr   z, .jr_4707                              ; $46FE: $28 $07

    inc  hl                                       ; $4700: $23
    inc  e                                        ; $4701: $1C
    ld   a, e                                     ; $4702: $7B
    cp   INVENTORY_SLOT_COUNT                     ; $4703: $FE $0C
    jr   nz, .loop_46FB                           ; $4705: $20 $F4

.jr_4707
    ld   a, [wBoomerangTradedItem]                ; $4707: $FA $7D $DB
    ld   [hl], a                                  ; $470A: $77
    ld   hl, wEntitiesPrivateState1Table          ; $470B: $21 $B0 $C2
    add  hl, bc                                   ; $470E: $09
    ld   [hl], a                                  ; $470F: $77
    ld   a, $0D                                   ; $4710: $3E $0D
    ld   [wBoomerangTradedItem], a                ; $4712: $EA $7D $DB
    call GetEntityTransitionCountdown             ; $4715: $CD $05 $0C
    ld   [hl], $80                                ; $4718: $36 $80
    ld   a, $01                                   ; $471A: $3E $01
    ld   [wC167], a                               ; $471C: $EA $67 $C1
    ld   a, MUSIC_OBTAIN_ITEM                     ; $471F: $3E $10
    ld   [wMusicTrackToPlay], a                   ; $4721: $EA $68 $D3
    ret                                           ; $4724: $C9

jr_019_4725:
    ld   [hl], b                                  ; $4725: $70
    jp_open_dialog Dialog223                      ; $4726

Data_019_472B::
    db   $00, $17, $84, $17, $80, $17, $82, $17, $86, $17, $88, $17, $8A, $14, $8C, $14
    db   $98, $17, $90, $17, $92, $17, $96, $17, $8E, $17, $A4, $14

GoriyaState2Handler::
    call GetEntityTransitionCountdown             ; $4747: $CD $05 $0C
    jr   nz, .jr_4755                             ; $474A: $20 $09

    xor  a                                        ; $474C: $AF
    ld   [wC167], a                               ; $474D: $EA $67 $C1
    call IncrementEntityState                     ; $4750: $CD $12 $3B
    ld   [hl], b                                  ; $4753: $70
    ret                                           ; $4754: $C9

.jr_4755
    cp   $08                                      ; $4755: $FE $08
    jr   nz, jr_019_476A                          ; $4757: $20 $11

    dec  [hl]                                     ; $4759: $35
    ld   hl, wEntitiesPrivateState1Table          ; $475A: $21 $B0 $C2
    add  hl, bc                                   ; $475D: $09
    ld   a, [hl]                                  ; $475E: $7E
    cp   $0D                                      ; $475F: $FE $0D
    ld_dialog_low a, Dialog224 ; "Got the Boomerang" ; $4761: $3E $24
    jr   z, .jr_4767                              ; $4763: $28 $02

    ld_dialog_low a, Dialog226 ; "The item came back to you" ; $4765: $3E $26

.jr_4767
    call OpenDialogInTable2                       ; $4767: $CD $7C $23

jr_019_476A:
    ldh  a, [hLinkPositionX]                      ; $476A: $F0 $98
    ldh  [hActiveEntityPosX], a                   ; $476C: $E0 $EE
    ldh  a, [hLinkPositionY]                      ; $476E: $F0 $99
    sub  $0C                                      ; $4770: $D6 $0C
    ldh  [hActiveEntityVisualPosY], a             ; $4772: $E0 $EC
    ldh  a, [hLinkPositionZ]                      ; $4774: $F0 $A2
    ld   hl, wEntitiesPosZTable                   ; $4776: $21 $10 $C3
    add  hl, bc                                   ; $4779: $09
    ld   [hl], a                                  ; $477A: $77
    ld   a, LINK_ANIMATION_STATE_GOT_ITEM         ; $477B: $3E $6C
    ldh  [hLinkAnimationState], a                 ; $477D: $E0 $9D
    ld   a, $02                                   ; $477F: $3E $02
    ldh  [hLinkInteractiveMotionBlocked], a       ; $4781: $E0 $A1
    call ResetSpinAttack                          ; $4783: $CD $AF $0C
    ld   hl, wEntitiesPrivateState1Table          ; $4786: $21 $B0 $C2
    add  hl, bc                                   ; $4789: $09
    ld   a, [hl]                                  ; $478A: $7E
    ldh  [hActiveEntitySpriteVariant], a          ; $478B: $E0 $F1
    ld   de, Data_019_472B                        ; $478D: $11 $2B $47
    call RenderActiveEntitySprite                 ; $4790: $CD $77 $3C
    jp   CopyEntityPositionToActivePosition       ; $4793: $C3 $8A $3D
