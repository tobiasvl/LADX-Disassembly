Bank3ETrampolineTarget:
    call MainJumpTable
    pop af
    jp SwitchBank ; switch bank and return to normal code.
MainJumpTable:
    rst  0 ; JUMP TABLE
    dw   Foo                                  ; 0

Foo:
    ret