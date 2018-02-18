.defineLabel MARIO_STRUCT, 0x8033B170

; See this wiki page for a list of Mario's actions: http://wiki.origami64.net/sm64:actions
.defineLabel ACTION_DIVE, 0x0188088A 
.defineLabel ACTION_SLIDE, 0x00880456
.defineLabel ACTION_SLIDERECOVER, 0x00000386
.defineLabel ACTION_SLOPESLIDE, 0x00880453

; begin function
.orga 0x7CC6C0 ; Set ROM address, we are overwritting a useless loop function as our hook.
.area 0xB4 ; Set data import limit to 0xB4 bytes
addiu sp, sp, -0x18
sw ra, 0x14 (sp)

; check if the player pressed B on this frame
.f_testInput BUTTON_B, BUTTON_PRESSED, proc802CB1C0_end
nop

; check if mario is in the dive slide state, the slope slide state, or the slide recover state
li t0, MARIO_STRUCT
lw t1, 0x0C(t0) ; get mario's current action
li t2, ACTION_SLIDE
sub t3, t1, t2
li t2, ACTION_SLIDERECOVER
sub t4, t1, t2
li t2, ACTION_SLOPESLIDE
and t6, t3, t4
sub t5, t1, t2
and t6, t6, t5
bne t6, $zero, proc802CB1C0_end
nop

; perform the dive hop
li t1, ACTION_DIVE
sw t1, 0x0C(t0) ; Set mario's action to diving
li t1, 30.0
mtc1 t1, f2
swc1 f2, 0x4C(t0) ; Set mario's y-speed to 30.0

; end function
proc802CB1C0_end:
lw ra, 0x14 (sp)
jr ra
addiu sp, sp, 0x18
.endarea