[ANIM_JUMP]: 0x04003148
[ANIM_FRFL]: 0x04002B78
[ANIM_CTWL]: 0x04002B88

;link_animetion
.org %(0x004E5C00+0x00114420) ; Front Flip
.incbin "animations/Anim_DD50.bin"

.org %(0x004E5C00+0x00114FB0) ; Cartwheel
.incbin "animations/Anim_DD60.bin"

;gameplay_keep
.org %(0x00F5E000+0x00002B78) ; Front Flip
.half 0x000D                  ; Frame Count

.org %(0x00F5E000+0x00002B88) ; Cartwheel
.half 0x000E                  ; Frame Count


.org 0x800A3F30
jal hack
nop

.org 0x807A0400

jump:
.byte 0x00
.align

hack:
push     4, t0, t1, t2          ; Back Up Registers
or       s0, a1, r0             ; Overwritten At Hook Location
li       t0, @ANIM_JUMP         ; Load 0x04003148 into t0
bne      a2, t0, end            ; If Current Animation is not Regular Jump, End Routine
nop
lbu      t0, jump               ; Load Jump Byte into t0
ori      t2, r0, 0x0003
beql     t0, t2, anim           ; If Jump = 0x03, Reset to 0x00
mov      t0, r0
anim:
li       t1, @ANIM_JUMP
beqi     t0, 0x0000, storeanim  ; If Jump Byte = 0x00
nop
li       t1, @ANIM_FRFL
beqi     t0, 0x0001, storeanim  ; If Jump Byte = 0x01
nop
li       t1, @ANIM_CTWL
beqi     t0, 0x0002, storeanim  ; If Jump Byte = 0x02
nop
li       t1, @ANIM_JUMP         ; Else Regular Jump
storeanim:
mov      a2, t1                 ; Store Jump Animation to a2
addiu    t0, t0, 0x0001         ; Add 0x01 to Jump
sb       t0, jump
end:
pop      4, t0, t1, t2
jr       ra
or       s1, a2, r0
