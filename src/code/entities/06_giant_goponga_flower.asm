GiantGopongaFlowerEntityHandler::
    call func_006_6376                            ; $62B3: $CD $76 $63
    call ReturnIfNonInteractive_06                ; $62B6: $CD $C6 $64
    call DecrementEntityIgnoreHitsCountdown       ; $62B9: $CD $56 $0C
    call label_3B70                               ; $62BC: $CD $70 $3B
    call PushLinkOutOfEntity_06                   ; $62BF: $CD $1A $64
    ldh  a, [hActiveEntityState]                  ; $62C2: $F0 $F0
    JP_TABLE                                      ; $62C4
._00 dw GiantGopongaState0Handler
._01 dw GiantGopongaState1Handler
._02 dw GiantGopongaState2Handler

GiantGopongaState0Handler::
    call GetEntityTransitionCountdown             ; $62CB: $CD $05 $0C
    ld   [hl], $C0                                ; $62CE: $36 $C0
    jp   IncrementEntityState                     ; $62D0: $C3 $12 $3B

GiantGopongaState1Handler::
    call GetEntityTransitionCountdown             ; $62D3: $CD $05 $0C
    jr   nz, .jr_62DD                             ; $62D6: $20 $05

    ld   [hl], $50                                ; $62D8: $36 $50
    call IncrementEntityState                     ; $62DA: $CD $12 $3B

.jr_62DD
    rra                                           ; $62DD: $1F
    rra                                           ; $62DE: $1F
    rra                                           ; $62DF: $1F
    rra                                           ; $62E0: $1F
    and  $01                                      ; $62E1: $E6 $01
    jp   SetEntitySpriteVariant                   ; $62E3: $C3 $0C $3B

GiantGopongaState2Handler::
    call GetEntityTransitionCountdown             ; $62E6: $CD $05 $0C
    jr   nz, .jr_62EF                             ; $62E9: $20 $04

    call IncrementEntityState                     ; $62EB: $CD $12 $3B
    ld   [hl], b                                  ; $62EE: $70

.jr_62EF
    cp   $4A                                      ; $62EF: $FE $4A
    jr   nz, .jr_6311                             ; $62F1: $20 $1E

    ld   a, ENTITY_GOPONGA_FLOWER_PROJECTILE      ; $62F3: $3E $7D
    call SpawnNewEntity_trampoline                ; $62F5: $CD $86 $3B
    jr   c, .jr_6311                              ; $62F8: $38 $17

    ldh  a, [hMultiPurpose0]                      ; $62FA: $F0 $D7
    ld   hl, wEntitiesPosXTable                   ; $62FC: $21 $00 $C2
    add  hl, de                                   ; $62FF: $19
    ld   [hl], a                                  ; $6300: $77
    ldh  a, [hMultiPurpose1]                      ; $6301: $F0 $D8
    ld   hl, wEntitiesPosYTable                   ; $6303: $21 $10 $C2
    add  hl, de                                   ; $6306: $19
    ld   [hl], a                                  ; $6307: $77
    push bc                                       ; $6308: $C5
    ld   c, e                                     ; $6309: $4B
    ld   b, d                                     ; $630A: $42
    ld   a, $0C                                   ; $630B: $3E $0C
    call ApplyVectorTowardsLink_trampoline        ; $630D: $CD $AA $3B
    pop  bc                                       ; $6310: $C1

.jr_6311
    ld   a, $02                                   ; $6311: $3E $02
    jp   SetEntitySpriteVariant                   ; $6313: $C3 $0C $3B

Data_006_6316::
    db   $F8, $F8, $70, $02, $F8, $00, $72, $02, $F8, $08, $72, $22, $F8, $10, $70, $22
    db   $08, $F8, $74, $02, $08, $00, $76, $02, $08, $08, $76, $22, $08, $10, $74, $22
    db   $F9, $F9, $70, $02, $F9, $01, $72, $02, $F9, $07, $72, $22, $F9, $0F, $70, $22
    db   $07, $F9, $74, $02, $07, $01, $76, $02, $07, $07, $76, $22, $07, $0F, $74, $22
    db   $F8, $F8, $78, $02, $F8, $00, $7A, $02, $F8, $08, $7A, $22, $F8, $10, $78, $22
    db   $08, $F8, $7C, $02, $08, $00, $7E, $02, $08, $08, $7E, $22, $08, $10, $7C, $22

func_006_6376::
    ldh  a, [hActiveEntitySpriteVariant]          ; $6376: $F0 $F1
    rla                                           ; $6378: $17
    rla                                           ; $6379: $17
    rla                                           ; $637A: $17
    rla                                           ; $637B: $17
    rla                                           ; $637C: $17
    and  $E0                                      ; $637D: $E6 $E0
    ld   e, a                                     ; $637F: $5F
    ld   d, b                                     ; $6380: $50
    ld   hl, Data_006_6316                        ; $6381: $21 $16 $63
    add  hl, de                                   ; $6384: $19
    ld   c, $08                                   ; $6385: $0E $08
    call RenderActiveEntitySpritesRect            ; $6387: $CD $E6 $3C
    ld   a, $08                                   ; $638A: $3E $08
    jp   func_015_7964_trampoline                 ; $638C: $C3 $A0 $3D
