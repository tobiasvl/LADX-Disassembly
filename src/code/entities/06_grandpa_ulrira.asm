GrandpaUlriraEntityHandler::
    ld   hl, wEntitiesPosYTable                   ; $5C0E: $21 $10 $C2
    add  hl, bc                                   ; $5C11: $09
    ld   a, $49                                   ; $5C12: $3E $49
    ld   [hl], a                                  ; $5C14: $77
    push bc                                       ; $5C15: $C5
    sla  c                                        ; $5C16: $CB $21
    sla  c                                        ; $5C18: $CB $21
    ld   hl, wEntitiesHitboxPositionTable         ; $5C1A: $21 $80 $D5
    add  hl, bc                                   ; $5C1D: $09
    inc  hl                                       ; $5C1E: $23
    inc  hl                                       ; $5C1F: $23
    ld   a, $08                                   ; $5C20: $3E $08
    ld   [hl], a                                  ; $5C22: $77
    inc  hl                                       ; $5C23: $23
    ld   a, $0A                                   ; $5C24: $3E $0A
    ld   [hl], a                                  ; $5C26: $77
    pop  bc                                       ; $5C27: $C1
    call func_006_5C71                            ; $5C28: $CD $71 $5C
    call ReturnIfNonInteractive_06                ; $5C2B: $CD $C6 $64
    ldh  a, [hFrameCounter]                       ; $5C2E: $F0 $E7
    rra                                           ; $5C30: $1F
    rra                                           ; $5C31: $1F
    rra                                           ; $5C32: $1F
    rra                                           ; $5C33: $1F
    rra                                           ; $5C34: $1F
    and  $01                                      ; $5C35: $E6 $01
    call SetEntitySpriteVariant                   ; $5C37: $CD $0C $3B
    call PushLinkOutOfEntity_06                   ; $5C3A: $CD $1A $64
    call CheckLinkInteractionWithEntity_06        ; $5C3D: $CD $5D $64
    ret  nc                                       ; $5C40: $D0

    ld   a, [wRichardSpokenFlag]                  ; $5C41: $FA $55 $DB
    and  a                                        ; $5C44: $A7
    jr   nz, .jr_5C4C                             ; $5C45: $20 $05

    ld   a, $01                                   ; $5C47: $3E $01
    ld   [wRichardSpokenFlag], a                  ; $5C49: $EA $55 $DB

.jr_5C4C
    jp_open_dialog Dialog140                      ; $5C4C

Data_006_5C51::
    db   $F7, $00, $70, $02, $F7, $08, $72, $02, $07, $00, $74, $02, $07, $08, $76, $02
    db   $F7, $00, $78, $02, $F7, $08, $7A, $02, $07, $00, $7C, $02, $07, $08, $7E, $02

func_006_5C71::
    ldh  a, [hActiveEntitySpriteVariant]          ; $5C71: $F0 $F1
    rla                                           ; $5C73: $17
    rla                                           ; $5C74: $17
    rla                                           ; $5C75: $17
    rla                                           ; $5C76: $17
    and  $F0                                      ; $5C77: $E6 $F0
    ld   e, a                                     ; $5C79: $5F
    ld   d, b                                     ; $5C7A: $50
    ld   hl, Data_006_5C51                        ; $5C7B: $21 $51 $5C
    add  hl, de                                   ; $5C7E: $19
    ld   c, $04                                   ; $5C7F: $0E $04
    call RenderActiveEntitySpritesRect            ; $5C81: $CD $E6 $3C
    ld   a, $04                                   ; $5C84: $3E $04
    jp   func_015_7964_trampoline                 ; $5C86: $C3 $A0 $3D
