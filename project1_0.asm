add $zero, $zero, $zero # bullshit!
initial:
addi $s0, $zero, 0x1000 # device
addi $s1, $zero, 0x1010 # keyboard
addi $s2, $zero, 0x104c # color & location
pen_init:
lw $s3, 0($s2)         # player_x
lw $s4, 4($s2)         # player_y
lw $s6, 8($s2)          # paper color
lw $s5, 12($s2)          # black ink

wait_start:
lw $t1, 8($s0)		    # keyboard
lw $t2, 0($t1)		    # read input from keyboard
lw $t3, 16($s1)		    # enter
beq $t2, $t3, bg_color_init	    # ==enter, play
j wait_start

bg_color_init:
add $t1, $zero, $zero	# x
add $t2, $zero, $zero	# y
addi $t3, $zero, 640	# col
addi $t4, $zero, 480	# row
lw $t5, 12($s0)		    # vram

bg_color:
sw $s6, 0($t5)
addi $t5, $t5, 1
addi $t1, $t1, 1
bne $t1, $t3, bg_color
add $t1, $zero, $zero
addi $t2, $t2, 1
bne $t2, $t4, bg_color

pen_loc_init:
addi $t3, $zero, 10	    # col-limit
addi $t4, $zero, 10	    # row-limit
lw $t5, 12($s0)		    # vram
add $t1, $s3, $s3		# *640
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t1, $t1, $t1
add $t2, $t1, $zero     # 128
add $t1, $t1, $t1
add $t1, $t1, $t1       # 512
add $t1, $t1, $t2       # 640
add $t1, $t1, $s4		# + y
add $t5, $t1, $t5		# + base vram

pen_draw:
sw 	$s5, 0($t5)
addi $t5, $t5, 1
addi $t3, $t3, -1
bne $t3, $zero, pen_draw
addi $t5, $t5, 630
addi $t3, $t3, 10
addi $t4, $t4, -1
bne $t4, $zero, pen_draw

wait_act:
lw $t1, 8($s0)		    # keyboard
lw $t2, 0($t1)		    # read input from keyboard
lw $t3, 0($s1)		    # up
beq $t2, $t3, up	    # go up
lw $t3, 4($s1)		    # down
beq $t2, $t3, down	    # go down
lw $t3, 8($s1)		    # left
beq $t2, $t3, left	    # go left
lw $t3, 12($s1)		    # right
beq $t2, $t3, right	    # go right
lw $t3, 16($s1)		    # enter
beq $t2, $t3, refresh   # go enter

lw $t3, 20($s1)		    # 0
beq $t2, $t3, c0	    # go 0
lw $t3, 24($s1)		    # 1
beq $t2, $t3, c1	    # go 1
lw $t3, 28($s1)		    # 2
beq $t2, $t3, c2	    # go 2
lw $t3, 32($s1)		    # 3
beq $t2, $t3, c3	    # go 3
lw $t3, 36($s1)		    # 4
beq $t2, $t3, c4   # go 4
lw $t3, 40($s1)		    # 5
beq $t2, $t3, c5	    # go 5
lw $t3, 44($s1)		    # 6
beq $t2, $t3, c6	    # go 6
lw $t3, 48($s1)		    # 7
beq $t2, $t3, c7	    # go 7
lw $t3, 52($s1)		    # 8
beq $t2, $t3, c8	    # go 8
lw $t3, 56($s1)		    # 9
beq $t2, $t3, c9   # go 9
j wait_act

up:
addi $s3, $s3, -1
j wait_view
down:
addi $s3, $s3, 1
j wait_view
left:
addi $s4, $s4, -1
j wait_view
right:
addi $s4, $s4, 1
j wait_view

refresh:
j initial

c0:
lw $s5, 8($s2)
j pen_loc_init
c1:
lw $s5, 12($s2)
j pen_loc_init
c2:
lw $s5, 16($s2)
j pen_loc_init
c3:
lw $s5, 20($s2)
j pen_loc_init
c4:
lw $s5, 24($s2)
j pen_loc_init
c5:
lw $s5, 28($s2)
j pen_loc_init
c6:
lw $s5, 32($s2)
j pen_loc_init
c7:
lw $s5, 36($s2)
j pen_loc_init
c8:
lw $s5, 40($s2)
j pen_loc_init
c9:
lw $s5, 44($s2)
j pen_loc_init

wait_view:
add $t1, $zero, $zero       # i
addi $t2, $zero, 0x0fff     # n

wait_loop:
addi $t1, $t1, 1            # i++
beq $t1, $t2, pen_loc_init  # i == n
add $zero, $zero, $zero     # wait
add $zero, $zero, $zero     # wait

j wait_loop


.data 0x00001000		# d4096
# s0-device
led_cntr:	.word 0xf0000000	
seg7:	    .word 0xe0000000	
kb:	        .word 0xd0000000	
vram:	    .word 0xc0000000	

# s1-keyboard
kbup: 	    .word 629	# up
kbdown:	    .word 626	# down
kbleft:	    .word 619	# left
kbright:	.word 628	# right
kbenter:	.word 90	# enter
k0:         .word 0x70  # 0
k1:         .word 0x69  # 1
k2:         .word 0x72  # 2
k3:         .word 0x7a  # 3
k4:         .word 0x6b  # 4
k5:         .word 0x73  # 5
k6:         .word 0x74  # 6
k7:         .word 0x6c  # 7
k8:         .word 0x75  # 8
k9:         .word 0x7d  # 9


# s2-color&loc
init_x: .word 230       # init_x
init_y: .word 310       # init_y
white:	.word 0xfff	   
black:	.word 0x000	   
gray1:	.word 0x333
gray2:	.word 0x666
red:	.word 0xccf
green:	.word 0xcfc
blue:	.word 0xfcc
yellow: .word 0xcff
purple: .word 0xfcf
orange: .word 0xffc