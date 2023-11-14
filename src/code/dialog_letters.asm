; Configure a wDrawCommand to write pixels for a black tile to the VRAM of the next letter.
ClearLetterPixels::
    ld   a, [wDialogCharacterIndex]               ; $49F1: $FA $70 $C1
    and  %00011111                                ; $49F4: $E6 $1F
    ld   e, a                                     ; $49F6: $5F
    ld   d, $00                                   ; $49F7: $16 $00
    ld   c, $01                                   ; $49F9: $0E $01
    ld   b, $00                                   ; $49FB: $06 $00
    ld   hl, DialogCharacterYTable                ; $49FD: $21 $81 $45
    add  hl, de                                   ; $4A00: $19
    ld   a, [hl]                                  ; $4A01: $7E

    ld   hl, wDrawCommandsSize                    ; $4A02: $21 $00 $D6
    add  hl, bc                                   ; $4A05: $09
    ldi  [hl], a ; wDrawCommand.destinationHigh   ; $4A06: $22

    push hl                                       ; $4A07: $E5
    ld   hl, DialogCharacterXTable                ; $4A08: $21 $61 $45
    add  hl, de                                   ; $4A0B: $19
    ld   a, [hl]                                  ; $4A0C: $7E
    pop  hl                                       ; $4A0D: $E1
    ldi  [hl], a ; wDrawCommand.destinationLow    ; $4A0E: $22

    ; Fill all the tile data with the same byte repeated
    ld   a, (TILE_SIZE - 1) | DC_FILL_ROW         ; $4A0F: $3E $4F
    ldi  [hl], a ; wDrawCommand.length            ; $4A11: $22

    ; Set the tile pixels (all black)
    ld   a, $FF                                   ; $4A12: $3E $FF
    ldi  [hl], a   ; wDrawCommand.data + 0        ; $4A14: $22

    ; End of wDrawCommand
    ld   [hl], $00 ; wDrawCommand.data + 1        ; $4A15: $36 $00
    ret                                           ; $4A17: $C9

Data_01C_4A18::
    db   $61, $41, $81, $21, $A1, $81, $61, $A1, $41, $C1

Data_01C_4A22::
    db   $98, $98, $98, $98, $98, $99, $99, $99, $99, $99

DialogOpenAnimationEnd::
    ld   a, [wDialogState]                        ; $4A2C: $FA $9F $C1
    ld   c, a                                     ; $4A2F: $4F
    ld   a, [wDialogOpenCloseAnimationFrame]      ; $4A30: $FA $6F $C1
    cp   $05                                      ; $4A33: $FE $05
    jr   z, func_01C_4A71                         ; $4A35: $28 $3A

    bit  DIALOG_BOX_BOTTOM_BIT, c                 ; $4A37: $CB $79
    jr   z, func_01C_4A3D                         ; $4A39: $28 $02

    add  $05                                      ; $4A3B: $C6 $05

func_01C_4A3D::
    ld   c, a                                     ; $4A3D: $4F
    ld   b, $00                                   ; $4A3E: $06 $00
    ld   e, $01                                   ; $4A40: $1E $01
    ld   d, $00                                   ; $4A42: $16 $00
    ld   a, [wBGOriginHigh]                       ; $4A44: $FA $2E $C1
    ld   hl, Data_01C_4A22                        ; $4A47: $21 $22 $4A
    add  hl, bc                                   ; $4A4A: $09
    add  [hl]                                     ; $4A4B: $86
    ld   hl, wDrawCommandsSize                    ; $4A4C: $21 $00 $D6
    add  hl, de                                   ; $4A4F: $19
    ldi  [hl], a                                  ; $4A50: $22
    push hl                                       ; $4A51: $E5
    ld   a, [wBGOriginLow]                        ; $4A52: $FA $2F $C1
    ld   hl, Data_01C_4A18                        ; $4A55: $21 $18 $4A
    add  hl, bc                                   ; $4A58: $09
    add  [hl]                                     ; $4A59: $86
    pop  hl                                       ; $4A5A: $E1
    ldi  [hl], a                                  ; $4A5B: $22
    ld   a, $51                                   ; $4A5C: $3E $51
    ldi  [hl], a                                  ; $4A5E: $22
    ldh  a, [hMultiPurposeG]                      ; $4A5F: $F0 $E8
    ldi  [hl], a                                  ; $4A61: $22
    ld   [hl], $00                                ; $4A62: $36 $00
    ldh  a, [hIsGBC]                              ; $4A64: $F0 $FE
    and  a                                        ; $4A66: $A7
    jr   z, func_01C_4A6C                         ; $4A67: $28 $03

    call func_01C_4A76                            ; $4A69: $CD $76 $4A

func_01C_4A6C::
    ld   hl, wDialogOpenCloseAnimationFrame       ; $4A6C: $21 $6F $C1
    inc  [hl]                                     ; $4A6F: $34
    ret                                           ; $4A70: $C9

func_01C_4A71::
    ld   hl, wDialogState                         ; $4A71: $21 $9F $C1
    inc  [hl]                                     ; $4A74: $34
    ret                                           ; $4A75: $C9

func_01C_4A76::
    ld   hl, wDrawCommandsAltSize                 ; $4A76: $21 $90 $DC
    ld   de, wDrawCommandsSize                    ; $4A79: $11 $00 $D6
    ld   b, $04                                   ; $4A7C: $06 $04
.loop_4A7E_1C
    ld   a, [de]                                  ; $4A7E: $1A
    ldi  [hl], a                                  ; $4A7F: $22
    inc  de                                       ; $4A80: $13
    dec  b                                        ; $4A81: $05
    jr   nz, .loop_4A7E_1C                        ; $4A82: $20 $FA

    ld   a, $01                                   ; $4A84: $3E $01
    ldi  [hl], a                                  ; $4A86: $22
    xor  a                                        ; $4A87: $AF
    ld   [hl], a                                  ; $4A88: $77
    ret                                           ; $4A89: $C9

; Where to ultimately write the saved BG tilemap in VRAM.
; Indexed by animation frame.
DialogRestoreBGMapLocationTable::
.low
    db   LOW(vBGMap0 + $00A1)
    db   LOW(vBGMap0 + $0021)
    db   LOW(vBGMap0 + $0081)
    db   LOW(vBGMap0 + $0041)
    db   LOW(vBGMap0 + $0061)
    db   LOW(vBGMap0 + $01C1)
    db   LOW(vBGMap0 + $0141)
    db   LOW(vBGMap0 + $01A1)
    db   LOW(vBGMap0 + $0161)
    db   LOW(vBGMap0 + $0181)
.high
    db   HIGH(vBGMap0 + $00A1)
    db   HIGH(vBGMap0 + $0021)
    db   HIGH(vBGMap0 + $0081)
    db   HIGH(vBGMap0 + $0041)
    db   HIGH(vBGMap0 + $0061)
    db   HIGH(vBGMap0 + $01C1)
    db   HIGH(vBGMap0 + $0141)
    db   HIGH(vBGMap0 + $01A1)
    db   HIGH(vBGMap0 + $0161)
    db   HIGH(vBGMap0 + $0181)

; Where to read the saved BG tilemap depending on the frame,
; as an offset to wD500.
DialogSavedBGMapOffsetTable::
    db   $48                                    ; $4A9E
    db   $00                                    ; $4A9F
    db   $36                                    ; $4AA0
    db   $12                                    ; $4AA1
    db   $24                                    ; $4AA2
    db   $48                                    ; $4AA3
    db   $00                                    ; $4AA3
    db   $36                                    ; $4AA5
    db   $12                                    ; $4AA6
    db   $24                                    ; $4AA7

; Restore BG tiles under the dialog box, line by line, during 5 frames
AnimateDialogClosing::
    ld   a, [wDialogState]                        ; $4AA8: $FA $9F $C1
    ld   c, a                                     ; $4AAB: $4F

    ld   a, [wDialogOpenCloseAnimationFrame]      ; $4AAC: $FA $6F $C1
    cp   $05                                      ; $4AAF: $FE $05
    jr   z, func_01C_4A71                         ; $4AB1: $28 $BE

    bit  7, c                                     ; $4AB3: $CB $79
    jr   z, .cEnd                                 ; $4AB5: $28 $02
    add  $05                                      ; $4AB7: $C6 $05
 .cEnd

    ; bc = animation frame index
    ; (goes from 0->4 for top of the dialog, and 5->9 for the bottom?)
    ld   c, a                                     ; $4AB9: $4F
    ld   b, $00                                   ; $4ABA: $06 $00

    ; de = 0001
    ld   e, $01                                   ; $4ABC: $1E $01
    ld   d, $00                                   ; $4ABE: $16 $00

    ; Set wDrawCommand.destinationHigh
    ; a = [wBGOriginHigh] + DialogRestoreBGMapHighTable[frame index]
    ld   a, [wBGOriginHigh]                       ; $4AC0: $FA $2E $C1
    ld   hl, DialogRestoreBGMapLocationTable.high ; $4AC3: $21 $94 $4A
    add  hl, bc                                   ; $4AC6: $09
    add  [hl]                                     ; $4AC7: $86
    ld   hl, wDrawCommandsSize                    ; $4AC8: $21 $00 $D6
    add  hl, de                                   ; $4ACB: $19
    ldi  [hl], a ; wDrawCommand.destinationHigh     ; $4ACC: $22
    push hl                                       ; $4ACD: $E5

    ; Set wDrawCommand.destinationLow
    ld   a, [wBGOriginLow]                        ; $4ACE: $FA $2F $C1
    ld   hl, DialogRestoreBGMapLocationTable.low  ; $4AD1: $21 $8A $4A
    add  hl, bc                                   ; $4AD4: $09
    add  [hl]                                     ; $4AD5: $86
    pop  hl                                       ; $4AD6: $E1
    ldi  [hl], a ; ; wDrawCommand.destinationLow   ; $4AD7: $22

    ; Set wDrawCommand.length
    ld   a, $11                                   ; $4AD8: $3E $11
    ldi  [hl], a ; wDrawCommand.length              ; $4ADA: $22
    push hl                                       ; $4ADB: $E5

    ; Configure where to read the saved BG map from
    ld   hl, DialogSavedBGMapOffsetTable          ; $4ADC: $21 $9E $4A
    add  hl, bc                                   ; $4ADF: $09
    ld   a, [hl]                                  ; $4AE0: $7E
    ld   c, a                                     ; $4AE1: $4F
    ld   b, $00                                   ; $4AE2: $06 $00
    ld   hl, wD500                                ; $4AE4: $21 $00 $D5
    add  hl, bc                                   ; $4AE7: $09
IF __OPTIMIZATIONS_2__
    ld   c, l
    ld   b, h
ELSE
    push hl                                       ; $4AE8: $E5
    pop  bc                                       ; $4AE9: $C1
ENDC
    pop  hl                                       ; $4AEA: $E1

    ; Loop from 12 to 1…
    ld   e, $12                                   ; $4AEB: $1E $12
.loop
    ; Copy a byte from BG map to restore to wDrawCommand.data
    ld   a, [bc]                                  ; $4AED: $0A
    inc  bc                                       ; $4AEE: $03
    ldi  [hl], a                                  ; $4AEF: $22
    dec  e                                        ; $4AF0: $1D
    jr   nz, .loop                                ; $4AF1: $20 $FA

    ; Write the END byte of wDrawCommand.data
    ld   [hl], $00                                ; $4AF3: $36 $00

    ldh  a, [hIsGBC]                              ; $4AF5: $F0 $FE
    and  a                                        ; $4AF7: $A7
    jr   z, .gbcEnd                               ; $4AF8: $28 $03
    call AnimateDialogClosingAttrs                ; $4AFA: $CD $02 $4B
.gbcEnd

    ld   hl, wDialogOpenCloseAnimationFrame       ; $4AFD: $21 $6F $C1
    inc  [hl]                                     ; $4B00: $34
    ret                                           ; $4B01: $C9

; Restore BG tile attributes under the dialog box, line by line, during 5 frames
; (CGB only)
AnimateDialogClosingAttrs::
    push bc                                       ; $4B02: $C5
    ld   hl, wDrawCommandsAltSize                 ; $4B03: $21 $90 $DC
    ld   de, wDrawCommandsSize                    ; $4B06: $11 $00 $D6
    ld   b, $04                                   ; $4B09: $06 $04
.loop_4B0B_1C
    ld   a, [de]                                  ; $4B0B: $1A
    ldi  [hl], a                                  ; $4B0C: $22
    inc  de                                       ; $4B0D: $13
    dec  b                                        ; $4B0E: $05
    jr   nz, .loop_4B0B_1C                        ; $4B0F: $20 $FA

    pop  bc                                       ; $4B11: $C1
    ld   a, c                                     ; $4B12: $79
    sub  $12                                      ; $4B13: $D6 $12
    ld   c, a                                     ; $4B15: $4F
    ld   e, $12                                   ; $4B16: $1E $12
.loop_4B18_1C
    ld   a, $02                                   ; $4B18: $3E $02
    ld   [rSVBK], a                               ; $4B1A: $E0 $70
    ld   a, [bc]                                  ; $4B1C: $0A
    ld   d, a                                     ; $4B1D: $57
    xor  a                                        ; $4B1E: $AF
    ld   [rSVBK], a                               ; $4B1F: $E0 $70
    ld   a, d                                     ; $4B21: $7A
    ldi  [hl], a                                  ; $4B22: $22
    inc  bc                                       ; $4B23: $03
    dec  e                                        ; $4B24: $1D
    jr   nz, .loop_4B18_1C                        ; $4B25: $20 $F1

    ld   [hl], $00                                ; $4B27: $36 $00
    ret                                           ; $4B29: $C9
