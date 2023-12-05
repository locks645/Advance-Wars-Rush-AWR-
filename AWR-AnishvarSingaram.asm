# Author:	Anishvar Singaram
# Date:		March 20, 2023
# Description:	A basic, modified version of Advance Wars

.data

# characters that need to be compared to
R: .byte 'R' # recon or road
T: .byte 'T' # tank
A: .byte 'A' # anti-air or attack
C: .byte 'C' # battle-copter, city, or COP
F: .byte 'F' # forest
B: .byte 'B' # base or build
X: .byte 'X' # enemy hq
Y: .byte 'Y' # allied hq
P: .byte 'P' # plains 
M: .byte 'M' # move
O: .byte '0' # empty

# horizontal bar, newline, and space for better formatting
HorizontalBar: .asciiz "\n---------------------------------------------\n\n"
NewLine:       .asciiz "\n" 
Space:         .asciiz " "

# all prompts for all functions
SelectThemeSongPrompt:      .asciiz "To begin, please select a theme song from the following list: Jake, Grit, Kanbei, Jess, Sturm\n"
SelectThemeSongSelected:    .asciiz "Theme song selected\n"
SelectThemeSongPromptError: .asciiz "Please enter a valid theme song from the list:\n" 

UpdateFundsError: .asciiz "\nInvalid unit entered\n" 

CalcDamageTerrainError: .asciiz "Invalid terrain selected\n"

BuildUnitBasePrompt:      .asciiz "\nPlease choose a base to build from: (3,0) or (9,2)\n"
BuildUnitBasePromptError: .asciiz "Please input valid base coordinates:\n"
BuildUnitUnitPrompt:      .asciiz "Please select a unit to build from the following list: R, T, A, C\n"
BuildUnitUnitPromptError: .asciiz "\nPlease build a valid unit from the list:\n"
BuildUnitFundsError:      .asciiz "\nInsufficient funds\n\n"

MoveUnitCoordinatesPrompt: .asciiz "\nPlease enter the coordinates of a unit to move and where to move it: (Ex: (3,0),(4,2))\n"
MoveUnitBoundsError:       .asciiz "\nCoordinates are out of bounds\n\n"
MoveUnitStartUnitError:    .asciiz "Illegal unit or empty tile selected\n"
MoveUnitEndUnitError:      .asciiz "Illegal destination tile\n"
MoveUnitRangeError:        .asciiz "Illegal movement range\n"

AttackUnitCoordinatesPrompt: .asciiz "\nPlease enter the coordinates of the attacking and defending units: (Ex: (8,0),(9,2))\n"
AttackUnitBoundsError:       .asciiz "Coordinates are out of bounds\n"
AttackUnitRangeError:        .asciiz "Attack not in range\n"
AttackUnitUnitError:         .asciiz "Illegal units or empty tile selected\n"
AttackUnitWon:               .asciiz "You win\n"
AttackUnitTotalMoves:        .asciiz "Total moves taken: "

ActivateCOPNotEnough:  .asciiz "Not enough charge\n"
ActivateCOPHperRepair: .asciiz "Hyper Repair (All of your units gain +2 HP)\n"

PromptPlayerPrompt:       .asciiz "Please select an action to take from the following list: B(Build), M(Move), A(Attack), (C)COP\n"
PromptPlayerErrorPrompt:  .asciiz "\nPlease input a valid command from the list:\n"

PrintCOBoxAndMapCO:     .asciiz "CO: Andy\n"
PrintCOBoxAndMapFunds:  .asciiz "Funds: "
PrintCOBoxAndMapMoves:  .asciiz "Moves: "
PrintCOBoxAndMapMeter1: .asciiz "CO Meter: " 
PrintCOBoxAndMapMeter2: .asciiz "/20000\n" 

# the 5 2D global arrays that make up the map tiles
tileHP:      .word 0,0,0,100,0,0,0,0,0,0   # for tileHP, the doubles are stored as integers
	     .word 0,0,0,0,0,0,0,0,100,100 # with the integers being 10 times the original double
	     .word 0,0,0,0,0,0,100,0,0,0   # value in the C array
	     .word 0,0,0,0,0,0,100,0,0,0
	     .word 0,0,0,0,0,0,0,0,0,0
	     .word 0,0,0,0,100,0,0,0,0,0
	     .word 0,0,0,0,0,0,0,0,0,0
	     .word 0,0,0,0,0,0,100,0,0,0
	     .word 0,0,0,0,0,0,0,100,0,0
	     .word 0,0,0,0,0,0,0,0,0,0

tileTerrain: .ascii  "PPPFRPPPCX" # constant array
	     .ascii  "PPPPPPPPCF" 
	     .ascii  "PPPPPCRRRR"
	     .ascii  "BPPPPRPCPP"
	     .ascii  "PPPPPPFPPP"
	     .ascii  "PPPRCCPPPP"
	     .ascii  "PPPPPPFCPP"
	     .ascii  "PPPPPPCCPP"
	     .ascii  "PPPPPPPRRP"
	     .asciiz "YPBPPPPRPP"

tileArmy:    .ascii  "000X000000"
	     .ascii  "00000000XX"
	     .ascii  "000000X000"
	     .ascii  "000000X000"
	     .ascii  "0000000000"
	     .ascii  "0000X00000"
	     .ascii  "0000000000"
	     .ascii  "000000X000"
	     .ascii  "0000000X00"
	     .asciiz "0000000000"

tileUnit:    .ascii  "000R000000"
	     .ascii  "00000000AT"
	     .ascii  "000000C000"
	     .ascii  "000000A000"
	     .ascii  "0000000000"
	     .ascii  "0000T00000"
	     .ascii  "0000000000"
	     .ascii  "000000R000"
	     .ascii  "0000000C00"
	     .asciiz "0000000000"
	     
checkAlive:  .word 0,0,0,1,0,0,0,0,0,0
             .word 0,0,0,0,0,0,0,0,1,1
             .word 0,0,0,0,0,0,1,0,0,0
             .word 0,0,0,0,0,0,1,0,0,0
             .word 0,0,0,0,0,0,0,0,0,0
             .word 0,0,0,0,1,0,0,0,0,0
             .word 0,0,0,0,0,0,0,0,0,0
             .word 0,0,0,0,0,0,1,0,0,0
             .word 0,0,0,0,0,0,0,1,0,0
             .word 0,0,0,0,0,0,0,0,0,0
    
# global variables        
moves:       .word 0            
funds:       .word 24000
powerCharge: .word 0

.text
	
	# main fucntion
	main:
		
		# load all global variables into registers for easy access
		# used a lot, so placed in $a1-3 registers
		lw $a1, moves
		lw $a2, funds
		lw $a3, powerCharge
	
				jal PrintCOBoxAndMap # print the CO box and map
			
			# print a HorizontalBar
			li $v0, 4
			la $a0, HorizontalBar
			syscall
			
				j PromptPlayer # jump to PromptPlayer function 
	
		# end program
		li $v0, 10
		syscall
	
	
		
	# void function	
	# prompts player to either B(build), M(move), A(attack), or activate their C(COP)
	# commands are now chars instead of strings for easy comparison
	PromptPlayer:
		
		# print PromptPlayerPrompt
		li $v0, 4
		la $a0, PromptPlayerPrompt
		syscall
		
		PPscan: # get playerCommand = $s0
			li $v0, 12 
			syscall
			move $s0, $v0
		
		# if statements checking if legal player command
			
			# take if playerCommand is B
			lb $s1, B
			bne $s0, $s1, PPafterB
				j BuildUnit
			PPafterB: # continue with code
		
			# take if playerCommand is M
			lb $s1, M
			bne $s0, $s1, PPafterM
				j MoveUnit
			PPafterM: # continue with code
			
			# take if playerCommand is A
			lb $s1, A
			bne $s0, $s1, PPafterA
				j AttackUnit
			PPafterA: # continue with code
			
			# take if playerCommand is C
			# lb $s1, C
			# bne $s0, $s1, PPafterC
				# j ActivateCOP
			# PPafterC: # continue with code
			
			# take if playerCommand is illegal
				
				# print error/prompt message
				li $v0, 4
				la $a0, PromptPlayerErrorPrompt
				syscall
				
				# scan a new playerCommand
				j PPscan 
			
		# end of if statements checking if legal player command
		
		# jump back to previous function
		# PPend: jr $ra
		# no need to jump back since it's a self-contained function
	
	
	
	# void function
	# prints the CO box and map in 4x4 squares
	PrintCOBoxAndMap:
	 
		# print out the CO box first
		
			# print out the commanding CO
			li $v0, 4
			la $a0, PrintCOBoxAndMapCO
			syscall
		
			# print out the funds prompt
			li $v0, 4
			la $a0, PrintCOBoxAndMapFunds
			syscall
			
			# print out the current funds
			li $v0, 1
	       		addi $a0, $a2, 0
			syscall
			
			# print a NewLine
			li $v0, 4
			la $a0, NewLine
			syscall
		
			# print out the moves prompt
			li $v0, 4
			la $a0, PrintCOBoxAndMapMoves
			syscall
		
			# print out the total moves
			li $v0, 1
			addi $a0, $a1, 0
			syscall
		
			# print a NewLine
			li $v0, 4
			la $a0, NewLine
			syscall
		
			# print out the first CO meter prompt
			li $v0, 4
			la $a0, PrintCOBoxAndMapMeter1
			syscall
		
			# print out the current powerCharge
			li $v0, 1
			addi $a0, $a3, 0
			syscall
	
			# print out the second CO meter prompt
			li $v0, 4
			la $a0, PrintCOBoxAndMapMeter2
			syscall
			
		# end of printing CO box
			
		# print a HorizontalBar
		li $v0, 4
		la $a0, HorizontalBar
		syscall
		
		# print out the map 
		
	 		addi $s1, $zero, 0 # $s1 = 0 = i
	 		addi $s2, $zero, 0 # $s2 = 0 = j
	 		addi $s3, $zero, 0 # $s3 = 0 = k
	 		
	 		PCBMfor:  
	 			PCBMfori: bge $s1, 10, PCBMafteri # take this for-loop if i < 10
	 				          addi $s2, $zero, 0 # reset $s2 = j to 0
	 				PCBMforj: bge $s2, 10, PCBMafterj # take this for-loop if j < 10 
	 					
	 			        	# get and round tileHP
	 						
	 						# $t0 = tileHP base address
	 						la $t0, tileHP  
	 						
	 						# $t1 = current address of tileHP[i][j]
	 						mul $t1, $s1, 10 # 10*i
	 						add $t1, $t1, $s2 # (10*i)+j
	 						mul $t1, $t1, 4 # 4*(j+(10*x))
	 						add $t1, $t0, $t1 # base + 4*(j+(10*x))
	 						
	 						# $t0 = tileHP[i][j]
	 						lw $t0 ($t1)
	 						
	 						# round $t0 = tileHP[i][j]
	 						div $t0, $t0, 10
	 						mfhi $s0 # $s0 = remainder
	 						ble $s0, 0, PCBMrounddown
	 							addi $t0, $t0, 1 # round up tileHP[i][j]
	 						PCBMrounddown: # continue with code
	 						
	 					# end of getting and rounding tileHP
	 					
	 					# get tileTerrain
	 					
	 						# $t1 = tileTerrain base address
	 						la $t1, tileTerrain
	 						
	 						# $t2 = current tileTerrain[i][j] address
	 						mul $t2, $s1, 10 # 10*i
	 						add $t2, $t2, $s2 # (10*i)+j
	 						mul $t2, $t2, 1 # 1*(j+(10*x))
	 						add $t2, $t1, $t2 # base + 1*(j+(10*x))
	 						
	 						# $t1 = tileTerrain[i][j]
	 						lb $t1, ($t2)
	 					
	 					# end of getting tileTerrain
	 				
	 					# if-else statements for print formatting
	 					
	 						# take if $t0 = 10 (double digit HP)
	 						bne $t0, 10, PCBMdoublespace
	 							
	 							# print out $t0 = tileHP[i][j]
								li $v0, 1
								addi $a0, $t0, 0
								syscall
						
								# print out $t1 = tileTerrain[i][j]
								li $v0, 11
								addi $a0, $t1, 0
								syscall
	 				
	 							# print a Space
								li $v0, 4
								la $a0, Space
								syscall
							
								j PCBMafterspacing
							
							# take if $t0 != 10 (single digit HP)
							PCBMdoublespace: # print out $t0 = tileHP[i][j]
								         li $v0, 1
								         addi $a0, $t0, 0
								         syscall
						
									 # print out $t1 = tileTerrain[i][j]
									 li $v0, 11
									 addi $a0, $t1, 0
									 syscall
	 				
	 								 # print a Space
								         li $v0, 4
								         la $a0, Space
								         syscall
								         
								         # print a Space
								         li $v0, 4
								         la $a0, Space
								         syscall
								         
							PCBMafterspacing: # continue with code
						
						# end of if-else statments for print formatting
	 				
	 				# j++ and jump back to PCBMforj:
	 				addi $s2, $s2, 1
	 				j PCBMforj
	 				
	 				# end of j for-loop, continue with code
	 				PCBMafterj: # print a NewLine
					            li $v0, 4
					            la $a0, NewLine
					            syscall
					
						          addi $s3, $zero, 0 # reset $s3 = k to 0
						PCBMfork: bge $s3, 10, PCBMafterk # take this for-loop if k < 10
						
							# get tileArmy and tileUnit
							
								# $t0 = tileArmy base address
								la $t0, tileArmy
								
								# $t1 = current address of tileArmy[i][j]
	 							mul $t1, $s1, 10 # 10*i
	 							add $t1, $t1, $s3 # (10*i)+k
	 							mul $t1, $t1, 1 # 1*(k+(10*x))
	 							add $t1, $t0, $t1 # base + 1*(k+(10*x))
	 							
	 							# $t0 = tileArmy[i][k]
	 							lb $t0, ($t1) 
	 							
	 							# $t1 = tileUnit base address (overwrite)
	 							la $t1, tileUnit
	 							
	 							# $t2 = current address of tileUnit[i][k]
	 							mul $t2, $s1, 10 # 10*i
	 							add $t2, $t2, $s3 # k+(10*i)
	 							mul $t2, $t2, 1 # 1*(k+(10*i))
	 							add $t2, $t2, $t1 # base + 1*(k+(10*i))
	 							
	 							# $t1 = tileUnit[i][k]
	 							lb $t1, ($t2)
							
							# end of getting tileArmy and tileUnit
							
							# print $t0 = tileArmy[i][k]
							li $v0, 11
							addi $a0, $t0, 0
							syscall
							
							# print $t1 = tileUnit[i][k]
							li $v0, 11
							addi $a0, $t1, 0
							syscall
							
							# print a Space
							li $v0, 4
						        la $a0, Space
						        syscall
						        
						        # print a Space
							li $v0, 4
						        la $a0, Space
						        syscall
							
						# k++ and jump back to PCBMfork
						addi $s3, $s3, 1
						j PCBMfork
						
						# end of k for-loop, continue with code	
						PCBMafterk: # print a NewLine
							    li $v0, 4
						            la $a0, NewLine
						            syscall
						            
						            # print a NewLine
							    li $v0, 4
						            la $a0, NewLine
					           	    syscall
	 				
	 		        # i++ and jump back to PCBMfori
	 		       	addi $s1, $s1, 1
	 			j PCBMfori
	 			
	 		# take if i == 10, end of all for-loops
	 		PCBMafteri: # continue with code
	 	
	 	# end of printing out map
	 	
	 	# jump back to previous function
	 	jr $ra
	
	
	
	# void function
	# Each of the players units gain +2 HP (HP caps off at 10)
	ActivateCOP:
	
		# not implemented
	
	
	# void function
	# prompts player to build R, T, A, or C units on base tile and updates funds
	BuildUnit:
	
		addi $t0, $zero, 0 # $t0 = check
	
		# print BuildUnitBasePrompt
		li $v0, 4
		la $a0, BuildUnitBasePrompt
		syscall
		
		BUscanXY: # $s1 = playerX coordinate
			  li $v0, 5
		          syscall
		          move $s1, $v0
		
		          # $s2 = playerY coordinate
			  li $v0, 5
		          syscall
		          move $s2, $v0
		
		# while-loop to check if valid coordinates
		
			BUwhile1: bne $t0, 0, BUafterwhile1 # enter loop if $t0 = check != 1
			
				BUif30: # take if x == 3 and y == 0
					bne $s1, 3, BUif92
					bne $s2, 0, BUif92
						addi $t0, $zero, 1
						j BUwhile1
						
				BUif92: # take if x == 9 and y == 2
					bne $s1, 9, BUbaseerror
					bne $s2, 2, BUbaseerror
						addi $t0, $zero, 1
						j BUwhile1
						
				BUbaseerror: # take if above statements are false
					    
					      # print BuildUnitBasePromptError
					     li $v0, 4
					     la $a0, BuildUnitBasePromptError
					     syscall
					     
					     # jump back to scan new player coordinates
					     j BUscanXY
					
			# taken if check == 1
			BUafterwhile1: # continue with code	
		
		# end of while-loop to check if valid coordinates 
		
		# print BuildUnitUnitPrompt
		li $v0, 4
		la $a0, BuildUnitUnitPrompt
		syscall
		
		BUscanunit: # $s3 = playerUnit to build
			    li $v0, 12
			    syscall
			    move $s3, $v0
		
		# while-loop to check if valid unit
		
			 # take while-loop if $s3 = unit != R, T, A, or C
			 BUwhile2: # $s0 unit to compare to
				   lb $s0, R # $s0 = R
			           beq $s3, $s0, BUafterwhile2
			           lb $s0, T # $s0 = T
			           beq $s3, $s0, BUafterwhile2
			           lb $s0, A # s0 = A
			           beq $s3, $s0, BUafterwhile2
			           lb $s0, C # s0 = C
			           beq $s3, $s0, BUafterwhile2
			           
			           	 # print BuildUnitUnitPromptError
			           	 li $v0, 4
			           	 la $a0, BuildUnitUnitPromptError
			           	 syscall
			           	 
			           	 # jump back to scan new player unit
			           	 j BUscanunit
			           
			 BUafterwhile2: # continue with code
		
		# end of while-loop to check if valid unit 
		
		# if statement checking if player has enough funds
		
			# $s0 = unit to compare to 
			lb $s0, R # s0 = R
			bne $s3, $s0, BUifT
			bge $a2, 4000, BUafterif
			BUifT: lb $s0, T # s0 = T
			       bne $s3, $s0, BUifA
			       bge $a2, 7000, BUafterif
			BUifA: lb $s0, A # s0 = A
			       bne $s3, $s0, BUifC
			       bge $a2, 8000, BUafterif
			BUifC: lb $s0, C # s0 = C
			       bne $s3, $s0, BUfundserror
			       bge $a2, 4000, BUafterif
			       
			       BUfundserror: # print BuildUnitFundsError
			     		     li $v0, 4
			     		     la $a0, BuildUnitFundsError
			     		     syscall
			     		       
			     		     # jump back to PromptPlayer function
			     		     j PromptPlayer 
			
			BUafterif: # continue with code
		
		# end of if statement checking if player has enough funds
		
		# play music
		
			# store global variables on stack
			addi $sp, $sp, -4
			sw $a1, 0($sp) # $a1 = moves
			addi $sp, $sp, -4
			sw $a2, 0($sp) # $a2 = funds
			addi $sp, $sp, -4
			sw $a3, 0($sp) # a3 = powerCharge
			
				# play 2 notes in step
				li $v0, 33
				addi $a0, $zero, 70
		 		addi $a1, $zero, 1000
				addi $a2, $zero, 96
				addi $a3, $zero, 127
				syscall
		 
				li $v0, 33
				addi $a0, $zero, 72
				addi $a1, $zero, 1000
				addi $a2, $zero, 96
				addi $a3, $zero, 127
				syscall
			
			# restore golobal variables from stack
			lw $a3, 0($sp) # $a3 = powerCharge
			addi $sp, $sp, 4
			lw $a2, 0($sp) # $a2 = funds
			addi $sp, $sp, 4
			lw $a1, 0($sp) # $a1 = moves
			addi $sp, $sp, 4
		
		# end of playing music
		
		# store $s1 = baseX, $s2 = baseY, and $s3 = player's unit to stack
		addi $sp, $sp, -4 
		sw $s1, 0($sp) 
		addi $sp, $sp, -4 
		sw $s2, 0($sp)
		addi $sp, $sp, -4 
		sw $s3, 0($sp)
		
			move $t0, $s3 # $t0 = player unit also
		
			# jump to UpdateFunds
			# subtract unit cost from current funds
			jal UpdateFunds
			
		# restore BU's $s1, $s2, and $s3
		lw $s3, 0($sp) # $s3 = player's unit
		addi $sp, $sp, 4
		lw $s2, 0($sp) # $s2 = baseY
		addi $sp, $sp, 4
		lw $s1, 0($sp) # $s1 = baseX
		addi $sp, $sp, 4
		
		# get and build on tileArmy, tileUnit, and tileHP (x,y) values
		
			la $t0, tileArmy # $t0 = tileArmy baseAddress (overwrite)
			# $t1 = tileArmy[x][y] address
			mul $t1, $s1, 10 # 10*x
			add $t1, $t1, $s2 # (10*x)+y
			mul $t1, $t1, 1 # 1*((10*x)+y)
			add $t1, $t1, $t0 # base + 1*((10*x)+y)
			
			la $t0, tileUnit # $t0 = tileUnit baseAddress (overwrite)
			# $t2 = tileUnit[x][y] address
			mul $t2, $s1, 10 # 10*x
			add $t2, $t2, $s2 # (10*x)+y
			mul $t2, $t2, 1 # 1*((10*x)+y)
			add $t2, $t2, $t0 # base + 1*((10*x)+y)
			
			la $t0, tileHP # $t0 = tileHP baseAddress (overwrite)
			# $t3 = tileHP[x][y] address
			mul $t3, $s1, 10 # 10*x
			add $t3, $t3, $s2 # (10*x)+y
			mul $t3, $t3, 4 # 4*((10*x)+y)
			add $t3, $t3, $t0 # base + 4*((10*x)+y)
			
			# get and store new values
			lb $t0, Y # $t4 = X
			sb $t0, ($t1) # tileArmy[x][y] = Y
			addi $t0, $zero, 100 # $t0 = 100
			sw $t0, ($t3) # tileHP[x][y] = 100
			sb $s3, ($t2) # tileUnit = $s3 = playerUnit  
		
		# end of getting and building on tileArmy, tileUnit, and tileHP (x,y) values
		
		# print a Horizontalbar
		li $v0, 4
		la $a0, HorizontalBar
		syscall
		
			# jump to PrintCOBoxAndMap function
			# print out CO box and map
			jal PrintCOBoxAndMap
		
		# print a Horizontalbar
		li $v0, 4
		la $a0, HorizontalBar
		syscall
		
		# jump back to PromptPlayer function
		j PromptPlayer
		
		
	
	# void function
	# prompts player to move one of their units if the conditions are met
	MoveUnit:

		# print MoveUnitCoordinatesPrompt
		li $v0, 4
		la $a0, MoveUnitCoordinatesPrompt
		syscall
		
		# get player's move coordinates
		
			# $s1 = begX
			li $v0, 5 
			syscall
			move $s1, $v0
			
			# $s2 = begY
			li $v0, 5 
			syscall
			move $s2, $v0
			
			# $s3 = endX
			li $v0, 5 
			syscall
			move $s3, $v0
			
			# $s4 = endY
			li $v0, 5 
			syscall
			move $s4, $v0
		
		# end of getting player's move coordinates
		
		# if statements checking if legal coordinates (don't need else-if)
		
			# if statement checking if coordinates are in map
			blt $s1, 0, MUboundserror # if any coordinate is > 9 or < 0, error
			bgt $s1, 9, MUboundserror
			blt $s2, 0, MUboundserror
			bgt $s2, 9, MUboundserror
			blt $s3, 0, MUboundserror
			bgt $s3, 9, MUboundserror
			blt $s4, 0, MUboundserror
			bgt $s4, 9, MUboundserror
				j MUinbounds # jump to end of if statement
			
				MUboundserror: # print MoveUnitBoundsError
					       li $v0, 4
				               la $a0, MoveUnitBoundsError
				               syscall
				
				               # jump back to PromptPlayer function
				               j PromptPlayer
			
			MUinbounds: # continue with code
		
			# get tileArmy[begX][begY] and tileArmy[endX][endY] values
			
				la $t0, tileArmy # $t0 = tileArmy base address
				
				# $t3 = tileArmy[begX][begY] address
				mul $t3, $s1, 10 # $t1 = 10*begX
				add $t3, $t3, $s2 # $t1 = begY+(10*begX)
				add $t3, $t0, $t3 # $t1 = base + 1*(begY+(10*begX))
				
				lb $t1, ($t3) # $t1 = tileArmy[begX][begY] value 
				
				# $t4 = tileArmy[endX][endY] address
				mul $t4, $s3, 10 # $t2 = 10*endX
				add $t4, $t4, $s4 # $t2 = endY+(10*endX)
				add $t4, $t0, $t4 # $t2 = base + 1*(endY+(10*endX))
				
				lb $t2, ($t4) # $t2 = tileArmy[endX][endY] value
			
			# end of getting tileArmy[begX][begY] and tileArmy[endX][endY] values
		
			# if statement checking illegal begininning tile
			lb $s0, Y # $s0 = tile to compare to
			beq $t1, $s0, MUafteremptycheck
				
				# print MoveUnitStartUnitError
				li $v0, 4
				la $a0, MoveUnitStartUnitError
				syscall
				
				j PromptPlayer # jump back to PromptPlayer function
				
			MUafteremptycheck: # continue with code
			
			# if statement checking illegal end tile
			lb $s0, X # $s0 = tile to compare to
			beq $t2, $s0, MUenderror
			lb $s0, Y # $s0 = Y
			beq $t2, $s0, MUenderror
				j MUafterendcheck
				
				MUenderror: # print MoveUnitEndUnitError
					    li $v0, 4
				            la $a0, MoveUnitEndUnitError
				            syscall
				
				            j PromptPlayer # jump back to PromptPlayer function
			
			MUafterendcheck: # continue with code 
			
			# calculate abs(endX-begX)+abs(endY-begY)
			
				sub $t5, $s3, $s1 # $t5 = endX-begX
				sub $t6, $s4, $s2 # $t6 = endY-begY
				
				# make $t5 and $t6 positive
				bge $t5, $zero, MUalreadypositive1
					mul $t5, $t5, -1 # make $t5 positive by mulitplying it by -1
				MUalreadypositive1: # continue with code
				
				bge $t6, $zero, MUalreadypositive2
					mul $t6, $t6, -1 # make $t6 positive by mulitplying it by -1
				MUalreadypositive2: # continue with code
				
				add $t5, $t5, $t6 # $t5 = abs(endX-begX)+abs(endY-begY)
			
			# end of calculating abs(endX-begX)+abs(endY-begY) 
			
			# if statement checking if legal movement range
			ble $t5, 4, MUinrange
				
				# print MoveUnitRangeError
				li $v0, 4
				la $a0, MoveUnitRangeError
				syscall
				
				j PromptPlayer # jump back to PromptPlayer function
				
			MUinrange: 
		
		# end of if statements checking if legal coordinates
		
		# play music
		
			# store global variables on stack
			addi $sp, $sp, -4
			sw $a1, 0($sp) # $a1 = moves
			addi $sp, $sp, -4
			sw $a2, 0($sp) # $a2 = funds
			addi $sp, $sp, -4
			sw $a3, 0($sp) # a3 = powerCharge
			
				# play 2 notes in step
				li $v0, 33
				addi $a0, $zero, 70
		 		addi $a1, $zero, 1000
				addi $a2, $zero, 96
				addi $a3, $zero, 127
				syscall
		 
				li $v0, 33
				addi $a0, $zero, 75
				addi $a1, $zero, 1000
				addi $a2, $zero, 96
				addi $a3, $zero, 127
				syscall
			
			# restore golobal variables from stack
			lw $a3, 0($sp) # $a3 = powerCharge
			addi $sp, $sp, 4
			lw $a2, 0($sp) # $a2 = funds
			addi $sp, $sp, 4
			lw $a1, 0($sp) # $a1 = moves
			addi $sp, $sp, 4
		
		# end of playing music
		
		# moves++
		addi $a1, $a1, 1
		
		# change tileArmy values
		lb $s0, Y # $s0 = Y
		sb $s0, ($t4) # tileArmy[endX][endY] = Y
		lb $s0, O # $s0 = 0
		sb $s0, ($t3) # tileArmy[begX][begY] = 0
		
		# calculate and change tileUnit values
		
			la $t0, tileUnit # $t0 = tileUnit base address
			
			# $t5 = tileUnit[begX][begY] address
			mul $t5, $s1, 10 # 10*begX
			add $t5, $t5, $s2 # begY+(10*begX)
			add $t5, $t0, $t5 # base + 1*(begY+(10*begX))
			
			lb $t6, ($t5) # $t6 = tileUnit[begX][begY] value (unit)
			
			# $t7 = tileUnit[endX][endY] address
			mul $t7, $s3, 10 # 10*endX
			add $t7, $t7, $s4 # endY+(10*endX)
			add $t7, $t0, $t7 # base + 1*(endY+(10*endX))
			
			# start changing tileUnit values
			sb $t6, ($t7) # tileUnit[endX][endY] = tileUnit[begX][begY]
			lb $s0, O # $s0 = 0
			sb $s0, ($t5) # tileUnit[begX][begY] = 0
		
		# end of calculating and changing tileUnit values 
		
		# calculate and change tileHP values
		
			la $t0, tileHP # $t0 = tileHP base address
			
			# $t1 = tileHP[begX][begY] address
			mul $t1, $s1, 10 # 10*begX
			add $t1, $t1, $s2 # begY+(10*begX)
			mul $t1, $t1, 4 # 4*(begY+(10*begX))
			add $t1, $t0, $t1 # base + 4*(begY+(10*begX))
			
			lw $t2, ($t1) # $t2 = tileHP[begX][begY] value
			
			# $t3 = tileHP[endX][endY] address
			mul $t3, $s3, 10 # 10*endX
			add $t3, $t3, $s4 # endY+(10*endX)
			mul $t3, $t3, 4 # 4*(endY+(10*endX))
			add $t3, $t0, $t3 # base + 4*(endY+(10*endX))
			
			# change tileHP values
			sw $t2, ($t3) # tileHP[endX][endY] = tileHP[begX][begY]
			addi $s0, $zero, 0 # $s0 = 0
			sw $s0, ($t1) # tileHP[begX][begY] = 0
		
		# end of calculating and changing tileHP values
		
		# print a Horizontalbar
		li $v0, 4
		la $a0, HorizontalBar
		syscall
		
			# jump to PrintCOBoxAndMap function
			# print out CO box and map
			jal PrintCOBoxAndMap
		
		# print a Horizontalbar
		li $v0, 4
		la $a0, HorizontalBar
		syscall
		
		# jump back to PromptPlayer function
		j PromptPlayer
		

	
	# void function
	# prompts player to attack an enemy unit and update damage if the conditions are met
	AttackUnit:
	
		# print AttackUnitCoordinatesPrompt
		li $v0, 4
		la $a0, AttackUnitCoordinatesPrompt
		syscall
		
		# get and store player's coordinates
		
			# $s1 = aX
			li $v0, 5
			syscall
			move $s1, $v0
			
			# $s2 = aY
			li $v0, 5
			syscall
			move $s2, $v0
			
			# $s3 = dX
			li $v0, 5
			syscall
			move $s3, $v0
			
			# $s4 = dY
			li $v0, 5
			syscall
			move $s4, $v0
		
		# end of getting and storing player's coordinates
		
		# if statements checking if player's coordinates are legal
		
			# if statement checking if coordinates are within map limits
			blt $s1, 0, AUboundserror # if any coordinate is > 9 or < 0, error
			bgt $s1, 9, AUboundserror
			blt $s2, 0, AUboundserror
			bgt $s2, 9, AUboundserror
			blt $s3, 0, AUboundserror
			bgt $s3, 9, AUboundserror
			blt $s4, 0, AUboundserror
			bgt $s4, 9, AUboundserror
				j AUinbounds # jump to end of if statement
			
				AUboundserror: # print AttackUnitBoundsError
					       li $v0, 4
				               la $a0, AttackUnitBoundsError
				               syscall
				
				               # jump back to PromptPlayer function
				               j PromptPlayer
			
			AUinbounds: # continue with code
			
			# calculate abs(dX-aX) and abs(dY-aY)
			
				sub $t0, $s3, $s1 # $t0 = dX-aX
				sub $t1, $s4, $s2 # $t1 = dY-aY
				
				# make $t0 and $t1 positive (by multiplying with -1)
				bge $t0, 0, AUalreadypositive1
					mul $t0, $t0, -1
				AUalreadypositive1: # continue with code
				
				bge $t1, 0, AUalreadypositive2
					mul $t1, $t1, -1
				AUalreadypositive2: # continue with code
				
				# $t0 = abs(dX-aX), $t1 = abs(dY-aY)
			
			# end of calculating abs(aX-dX) and abs(aY-dY)
		
			# if statement checking if both units are net to each other
			bne $t0, 1, AUverticala 
			bne $t1, 0, AUverticala
				j AUinrange
			AUverticala: bne $t0, 0, AUrangeerror
				     bne $t1, 1, AUrangeerror
				     	j AUinrange
			
				AUrangeerror: # print AttackUnitRangeError
				              li $v0, 4
				              la $a0, AttackUnitRangeError
				              syscall
			
				              j PromptPlayer # jump back to PromptPlayer function
			
			AUinrange: # continue with code
			
			# get tileArmy for attacker and defender (also store address)
			
				la $t0, tileArmy # $t0 = tileArmy base address
				
				# $t1 = tileArmy[aX][aY] address
				mul $t1, $s1, 10 # 10*aX
				add $t1, $t1, $s2 # aY+(10*aX)
				add $t1, $t0, $t1 # base + 1*(aY+(10*aX))
				
				lb $t8, ($t1) # $t8 = tileArmy[aX][aY] value
				
				# $t2 = tileArmy[dX][dY] address
				mul $t2, $s3, 10 # 10*dX
				add $t2, $t2, $s4 # dY+(10*dX)
				add $t2, $t0, $t2 # base + 1*(aY+(10*dX))
				
				lb $t9, ($t2) # $t9 = tileArmy[dX][dY] value
			
			# end of getting tileArmy for attacker and defender (also store address)
			
			# if statement checking if attacker and defender are the right armies
			lb $s0, Y # $s0 = army to compare to 
			bne $t8, $s0, AUuniterror
			lb $s0, X # $s0 = X
			bne $t9, $s0, AUuniterror
				j AUrightarmies
				
				AUuniterror: # print AttackUnitUnitError
					     li $v0, 4
					     la $a0, AttackUnitUnitError
					     syscall 
					     
					     j PromptPlayer # jump back to PromptPlayer function
			
			AUrightarmies: # continue with code
		
		# end of if statements checking if player's coordinates are legal
		
		# play music
		
			# store global variables on stack
			addi $sp, $sp, -4
			sw $a1, 0($sp) # $a1 = moves
			addi $sp, $sp, -4
			sw $a2, 0($sp) # $a2 = funds
			addi $sp, $sp, -4
			sw $a3, 0($sp) # a3 = powerCharge
			
				# play 3 notes in step
				li $v0, 33
				addi $a0, $zero, 70
		 		addi $a1, $zero, 1000
				addi $a2, $zero, 96
				addi $a3, $zero, 127
				syscall
		 
				li $v0, 33
				addi $a0, $zero, 75
				addi $a1, $zero, 1000
				addi $a2, $zero, 96
				addi $a3, $zero, 127
				syscall
				
				li $v0, 33
				addi $a0, $zero, 70
				addi $a1, $zero, 1000
				addi $a2, $zero, 96
				addi $a3, $zero, 127
				syscall
			
			# restore golobal variables from stack
			lw $a3, 0($sp) # $a3 = powerCharge
			addi $sp, $sp, 4
			lw $a2, 0($sp) # $a2 = funds
			addi $sp, $sp, 4
			lw $a1, 0($sp) # $a1 = moves
			addi $sp, $sp, 4
		
		# end of playing music
		
		# registers in use: $s1-4 (coordinates), $t1-2 (tileArmy addresses)
		# $a1 = moves++
		addi $a1, $a1, 1
		
		# calculate and store aoHP and doHP values
		
			la $t0, tileHP # $t0 = tileHP base address
			
			# $t3 = tileHP[aX][aY] address
			mul $t3, $s1, 10 # 10*aX
			add $t3, $t3, $s2 # aY+(10*aX)
			mul $t3, $t3, 4  # 4*(aY+(10*aX))
			add $t3, $t0, $t3 # base + 4*(aY+(10*aX))
			
		 	lw $t4, ($t3) # $t4 = aoHP 
			
			# $t5 = tileHP[dX][dY] address
			mul $t5, $s3, 10 # 10*dX
			add $t5, $t5, $s4 # dY+(10*dX)
			mul $t5, $t5, 4  # 4*(dY+(10*dX))
			add $t5, $t0, $t5 # base + 4*(dY+(10*dX))
			
			lw $t6, ($t5) # $t6 = doHP 
		
		# end of calculating and storing aoHP and doHP values
		
		# calculate damage with child function and store into tileHP[dX][dY]
		# tileHP[dX][dY] -= CalcDamage(aX, aY, dX, dY)
		
			# store all variables onto stack before child function call
			addi $sp, $sp, -4
			sw $s1, 0($sp) # $s1 = aX
			addi $sp, $sp, -4
			sw $s2, 0($sp) # $s2 = aY
			addi $sp, $sp, -4
			sw $s3, 0($sp) # $s3 = dX
			addi $sp, $sp, -4
			sw $s4, 0($sp) # $s4 = dY
			addi $sp, $sp, -4
			sw $t1, 0($sp) # $t1 = tileArmy[aX][aY] address
			addi $sp, $sp, -4
			sw $t2, 0($sp) # $t2 = tileArmy[dX][dY] address
			addi $sp, $sp, -4
			sw $t3, 0($sp) # $t3 = tileHP[aX][aY] address 
			addi $sp, $sp, -4
			sw $t4, 0($sp) # $t4 = aoHP
			addi $sp, $sp, -4
			sw $t5, 0($sp) # $t5 = tileHP[dX][dY] address
			addi $sp, $sp, -4
			sw $t6, 0($sp) # $t6 = doHP
			
				# load inputs to child function in correct registers
				addi $t0, $s1, 0 # $t0 = aX
				addi $t1, $s2, 0 # $t1 = aY
				addi $t2, $s3, 0 # $t2 = dX
				addi $t3, $s4, 0 # $t3 = dY
			
				 jal CalcDamage # jump to CalcDamage child function
				 # $s0 = totalDamage (from CalcDamage)
				 
			# get variables back from stack
			lw $t6, 0($sp) # $t6 = doHP
			addi $sp, $sp, 4
			lw $t5, 0($sp) # $t5 = tileHP[dX][dY] address
			addi $sp, $sp, 4
			lw $t4, 0($sp) # $t4 = aoHP
			addi $sp, $sp, 4
			lw $t3, 0($sp) # $t3 = tileHP[aX][aY] address
			addi $sp, $sp, 4
			lw $t2, 0($sp) # $t2 = tileArmy[dX][dY] address
			addi $sp, $sp, 4
			lw $t1, 0($sp) # $t1 = tileArmy[aX][aY] address
			addi $sp, $sp, 4
			lw $s4, 0($sp) # $s4 = dY
			addi $sp, $sp, 4
			lw $s3, 0($sp) # $s3 = dX
			addi $sp, $sp, 4
			lw $s2, 0($sp) # $s2 = aY
			addi $sp, $sp, 4
			lw $s1, 0($sp) # $s1 = aX
			addi $sp, $sp, 4
			
			# tileHP[defendX][defendY] -= $s0 (totalDamage)
			sub $t7, $t6, $s0 # $t7 = $t6 (doHP) - totalDamage
			sw $t7, ($t5) # tileHP[dX][dY] = $t7 = $t6 (tileHP[dX][dY] value) - totalDamage
		
		# end of calculating damage with child function and store into tileHP[dX][dY]
		
		# if-else statements to check if defending unit is destroyed
		
			# get tileUnit[aX][aY] and tileUnit[dX][dY] adresses and values
			
				la $t0, tileUnit # $t0 = tileUnit base address
				
				# $t7 = tileUnit[aX][aY] address
				mul $t7, $s1, 10
				add $t7, $t7, $s2
				add $t7, $t0, $t7 # base + 1*(aY+(10*aX))
				
				lb $t8, ($t7) # $t8 = tileUnit[aX][aY] value
				
				# $t9 = tileUnit[dX][dY] address
				mul $t9, $s3, 10
				add $t9, $t9, $s4 
				add $t9, $t0, $t9 # base + 1*(dY+(10*dX))
				
				lb $t0, ($t9) # $t0 = tileUnit[dX][dY] value  
			
			# end of getting tileUnit[aX][aY] and tileUnit[dX][dY] adesses and values
		
			lw $s7, ($t5) # $s7 = tileHP[dX][dY] value (from address)
			
			# if statement checking if defender is alive or not
			bgt $s7, 0, AUdefenderalive 
				
				# change tileUnit, tileHP, and tileArmy values for defender
				lb $s7, O # $s0 = 0 (char)
				sb $s7, ($t9) # tileUnit[dX][dY] = '0'
				sb $s7, ($t2) # tileArmy[dX][dY] = '0'
				addi $s7, $zero, 0 # $s7 = 0 (int)
				sw $s7, ($t5) # tileHP[dX][dY] = 0
				
				j AUprintstuff # jump to printing out the map
			
			AUdefenderalive: # continue with first else statement code
			
				# tileHP[aX][aY] -= CalcDamage(dX, dY, aX, aY)
				# store variables on stack before CalcDamage call
				addi $sp, $sp, -4
				sw $s1, 0($sp) # $s1 = aX
				addi $sp, $sp, -4
				sw $s2, 0($sp) # $s2 = aY
				addi $sp, $sp, -4
				sw $s3, 0($sp) # $s3 = dX
				addi $sp, $sp, -4
				sw $s4, 0($sp) # $s4 = dY
				addi $sp, $sp, -4
				sw $t0, 0($sp) # $t0 = tileUnit[dX][dY] value
				addi $sp, $sp, -4
				sw $t1, 0($sp) # $t1 = tileArmy[aX][aY] address
				addi $sp, $sp, -4
				sw $t2, 0($sp) # $t2 = tileArmy[dX][dY] address
				addi $sp, $sp, -4
				sw $t3, 0($sp) # $t3 = tileHP[aX][aY] address
				addi $sp, $sp, -4
				sw $t4, 0($sp) # $t4 = aoHP
				addi $sp, $sp, -4
				sw $t5, 0($sp) # $t5 = tileHP[dX][dY] address
				addi $sp, $sp, -4
				sw $t6, 0($sp) # $t6  doHP
				addi $sp, $sp, -4
				sw $t7, 0($sp) # $t7 = tileUnit[aX][aY] address
				addi $sp, $sp, -4
				sw $t8, 0($sp) # $t8 = tileUnit[aX][aY] value
				addi $sp, $sp, -4
				sw $t9, 0($sp) # $t9 = tileUnit[dX][dY] address
				
					# load CalcDamage inputs to correct register
					addi $t0, $s3, 0 # $t0 = dX
					addi $t1, $s4, 0 # $t1 = dY
					addi $t2, $s1, 0 # $t2 = aX
					addi $t3, $s2, 0 # $t4 = aY
					
					jal CalcDamage # jump to CalcDamage function
					# $s0 = totalDamage (from CalcDamage)
					
				# return variables from stack after CalcDamage call
				lw $t9, 0($sp) # $t9 = tileUnit[dX][dY] address
				addi $sp, $sp, 4
				lw $t8, 0($sp) # $t8 = tileUnit[aX][aY] value
				addi $sp, $sp, 4
			        lw $t7, 0($sp) # $t7 = tileUnit[aX][aY] address
				addi $sp, $sp, 4
				lw $t6, 0($sp) # $t6 = doHP
				addi $sp, $sp, 4
				lw $t5, 0($sp) # $t5 = tileHP[dX][dY] address
				addi $sp, $sp, 4
				lw $t4, 0($sp) # $t4 = aoHP
				addi $sp, $sp, 4
				lw $t3, 0($sp) # $t3 = tileHP[aX][aY] address
				addi $sp, $sp, 4
				lw $t2, 0($sp) # $t2 = tileArmy[dX][dY] address
				addi $sp, $sp, 4
				lw $t1, 0($sp) # $t1 = tileArmy[aX][aY] address
				addi $sp, $sp, 4
				lw $t0, 0($sp) # $t0 = tileUnit[dX][dY] value
				addi $sp, $sp, 4
				lw $s4, 0($sp) # $s4 = dY
				addi $sp, $sp, 4
				lw $s3, 0($sp) # $s3 = dX
				addi $sp, $sp, 4
				lw $s2, 0($sp) # $s2 = aY
				addi $sp, $sp, 4
				lw $s1, 0($sp) # $s1 = aX
				addi $sp, $sp, 4
				
				# tileHP[attackX][attackY] -= $s0 (totalDamage)
				sub $s7, $t4, $s0 # $s7 = $t4 (aoHP) - totalDamage
				sw $s7, ($t3) # tileHP[aX][aY] = $t7 = $t3 (tileHP[aX][aY] value) - totalDamage
				
				# if statement checking if attacker is alive or not
				lw $s7, ($t3) # $s7 = tileHP[aX][aY] value (overwrite)
				bgt $s7, 0, AUattackeralive
					
					# change tileUnit, tileArmy, and tileHP vlaues for attacker
					lb $s7, O # $s7 = 0
					sb $s7, ($t7) # tileUnit[aX][aY] = '0'
					sb $s7, ($t1) # tileArmy[aX][aY] = '0'
					addi $s7, $zero, 0 # $s7 = 0
					sw $s7, ($t3) # tileHP[aX][aY] = 0
					
					j AUprintstuff # jump to priniting out the map
					
				AUattackeralive: # continue with code
				
		# end of if-else statements checking if defending unit is destroyed
		
		AUprintstuff: # print a HorizonatalBar
			      li $v0, 4
		              la $a0, HorizontalBar
		              syscall
		
		      	      jal PrintCOBoxAndMap # jump to PrintCOBoxAndMap function 		
		
		              # print a HorizontalBar
		              li $v0, 4
		              la $a0, HorizontalBar
		              syscall
		
		# jump back to PromptPlayer function
		j PromptPlayer
	
	
	
	# "double" (actually an int) function
	# calculates attacking battle damage and returns amount of damage to deal "(0.0-10.0)", actually (0-100) 
	# called for both attacking and counterattacking
	CalcDamage: 
		
		# store $a1 = moves on stack to use $a1 for luck
		addi $sp, $sp, -4 # allocate room on stack
		sw $a1, 0($sp) # store $a1 = moves on stack
		
		# generate a random number for luck (0-9)
		li $v0, 42
		addi $a1, $zero, 9
		syscall
		
		move $t4, $a0 # $t4 = luck
		
		# restore $a1 = moves from stack
		lw $a1, 0($sp) # restore $a1 = moves
		addi $sp, $sp, 4 # deallocate room on stack 
		
		# calculating and rounding tileHP for aHP and dHP
		# make roudning and address a subroutine!!!
		
			# $t5 = tileHP base address
			la $t5, tileHP
			
			# $t6 = attacking tileHP address
			mul $t6, $t0, 10  # 10*x
			add $t6, $t6, $t1 # (10*x) + y
			sll $t6, $t6, 2   # 4*((10*x)+y)
			add $t6, $t6, $t5 # base + 4*((10*x)+y)
			
			# $t7 = defending tileHP address
			mul $t7, $t2, 10  # 10*x
			add $t7, $t7, $t3 # (10*x) + y
			sll $t7, $t7, 2   # 4*((10*x)+y)
			add $t7, $t7, $t5 # base + 4*((10*x)+y)
			
			# $t5 = attacking tileHP (overwrite)
			# $t6 = defending tileHP
			lw $t5, ($t6)
			lw $t6, ($t7)
			
			# $t5 = rounded aHP
			div $t5, $t5, 10
			mfhi $s0 # remainder
			ble $s0, 0, CDrounddown1
				addi $t5, $t5, 1 
			CDrounddown1: # continue with code
			
			# $t6 = rounded dHP
			div $t6, $t6, 10
			mfhi $s0 # remainder
			ble $s0, 0, CDrounddown2
				addi $t6, $t6, 1 
			CDrounddown2: # continue with code
			
		# end of calculating and rounding aHP and dHP
		
		# get tile of the defender (from tileTerrain)
		
			# $t7 = tileTerrain base address
			la $t7, tileTerrain
			
			# $t8 = defending tileTerrain address
			mul $t8, $t2, 10  # 10*x
			add $t8, $t8, $t3 # (10*x) + y
		        mul $t8, $t8, 1   # 1*((10*x)+y)
			add $t8, $t8, $t7 # base + 1*((10*x)+y)
			
			# $t7 = tileTerrain[defendX][defendY]
			lb $t7, ($t8)
		
		# end of getting tile of defender (from tileTerrain)
		
		# get unit of the defender (from tileUnit)
		
			# $t8 = tileUnit base address
			la $t8, tileUnit
			
			# $t9 = defending tileUnit address
			mul $t9, $t2, 10  # 10*x
			add $t9, $t9, $t3 # (10*x) + y
		        mul $t9, $t9, 1   # 1*((10*x)+y)
			add $t9, $t9, $t8 # base + 1*((10*x)+y)
			
			# $t8 = tileUnit[defendX][defendY]
			lb $t8, ($t9)
			
		# end of getting the unit of the defender (from tileUnit)
		
		# if-else statments setting terrrainBonus
		# converst tileTerrain to terrainBonus
		
			# take if tileUnit[defendX][defendY] == R || T || A
			# $t9 = terrainBonus
			# $s0 = unit char to compare
			lb $s0, R # $s0 = R (overwrite)
			bne $t8, $s0, CDifT
				j CDdefenseXY
		        CDifT: lb $s0, T # $s0 = T
			       bne $t8, $s0, CDifA
			       	j CDdefenseXY
			CDifA: lb $s0, A # s0 = A
			       bne $t8, $s0, CDnodefense
			       	j CDdefenseXY
			
				# take if tileTerrain[defendX][defendY] == X || Y
				CDdefenseXY: lb $s0, X # $s0 = X
				             bne $t7, $s0, CDifY
				             	j CDisXY
				             CDifY: lb $s0, Y # $s0 = Y
				                    bne $t7, $s0, CDdefenseCB
				                    	j CDisXY
				               		CDisXY: addi $t9, $zero, 4 # terrainBonus = 4
				       			        j CDafter1
				# take if tileTerrain[defendX][defendY] == C || B
				CDdefenseCB: lb $s0, C # $s0 = C
				             bne $t7, $s0, CDifB
				             	j CDisCB
				             CDifB: lb $s0, B # $s0 = B
				                    bne $t7, $s0, CDdefenseF
				                    	j CDisCB
				               		CDisCB: addi $t9, $zero, 3 # terrainBonus = 3
				       				j CDafter1
				# take if tileTerrain[defendX][defendY] == F
				CDdefenseF: lb $s0, F # $s0 = F
				            bne $t7, $s0, CDdefenseP
				            	addi $t9, $zero, 2 # terrainBonus = 2
				            	j CDafter1
				# take if tileTerrain[defendX][defendY] == P
				CDdefenseP: lb $s0, P # $s0 = P
				            bne $t7, $s0, CDdefenseR
				            	addi $t9, $zero, 1 # terrainBonus = 1
				            	j CDafter1
				# take if tileTerrain[defendX][defendY] == R
				CDdefenseR: lb $s0, R # $s0 = R
				            bne $t7, $s0, CDerror1
				            	addi $t9, $zero, 0 # terrainBonus = 0
				            	j CDafter1
			
			# take if tileUnit[defenseX][defenseY] == C
			CDnodefense: lb $s0, C # $s0 = C
			             bne $t8, $s0, CDerror1
			              	addi $t9, $zero, 0
			              	j CDafter1
			# take if no legal units are selected
			CDerror1: # print out CalcDamageTerrainError
			          li $v0, 4
			          la $a0, CalcDamageTerrainError
			          syscall
			          addi $t9, $zero, -1
			CDafter1: # continue with code 
		
		# end of if-else statements setting terrainBonus
		
		# get unit that is attacking (from tileUnit)
		
			# $s7 = tileUnit base address
			la $t7, tileUnit # (overwrite tileTerrain)
			
			# $s0 = attacking tileUnit address (overwrite)
			mul $s0, $t0, 10  # 10*x
			add $s0, $s0, $t1 # (10*x) + y
		        mul $s0, $s0, 1   # 1*((10*x)+y)
			add $s0, $s0, $t7 # base + 1*((10*x)+y)
			
			# $t7 = tileUnit[attackX][attackY]
			# $t8 = tileUnit[defendX][defendY]
			lb $t7, ($s0) 
		
		# end of getting unit that is attacking (from tileUnit)
		
		# subroutine calls that calculates the baseDamage
		
			# store CD $ra to stack before subroutine call
			addi $sp, $sp, -4 # make room on stack
			sw $ra, ($sp) # store on stack
		
			# subroutine initalization if attacker = R
			lb $s0, R # R = attacking unit compared
			addi $s1, $zero, 35 # R baseDamage
			addi $s2, $zero, 6 # T baseDamage
			addi $s3, $zero, 4 # A baseDamage
			addi $s4, $zero, 12 # C baseDamage
				
				# jump to subroutine CalcBaseDamage
				jal CalcBaseDamage
				
			# subroutine initalization if attacker = T
			lb $s0, T # T = attacking unit compared
			addi $s1, $zero, 85 # R baseDamage
			addi $s2, $zero, 55 # T baseDamage
			addi $s3, $zero, 65 # A baseDamage
			addi $s4, $zero, 10 # C baseDamage
			
				# jump to subroutine CalcBaseDamage
				jal CalcBaseDamage
				
			# subroutine initalization if attacker = A
			lb $s0, A # A = attacking unit compared
			addi $s1, $zero, 60 # R baseDamage
			addi $s2, $zero, 25 # T baseDamage
			addi $s3, $zero, 45 # A baseDamage
			addi $s4, $zero, 120 # C baseDamage
			
				# jump to subroutine CalcBaseDamage
				jal CalcBaseDamage
				
			# subroutine initalization if attacker = C
			lb $s0, C # C = attacking unit compared
			addi $s1, $zero, 55 # R baseDamage
			addi $s2, $zero, 55 # T baseDamage
			addi $s3, $zero, 25 # A baseDamage
			addi $s4, $zero, 65 # C baseDamage
			
				# jump to subroutine CalcBaseDamage
				jal CalcBaseDamage
			
			# bring back CD $ra from stack after subroutine call	
			lw $ra, ($sp) # replace with CD $ra
			addi $sp, $sp, 4 # deallocate stack to empty
		
		# end of subroutine calls that calculate baseDamage 
		
		# calculating the totalDamage
		
			# recap: 
			# $t4 = luck, $t5 = aHP, $t6 = dHP, $s5 = baseDamage, $t9 = terrainBonus
			# $s0 = totalDamage (overwrite)
			
			# load all variables into $f registers
		
				# $f2 = luck = $t4
				mtc1.d $t4, $f2 
				cvt.d.w $f2, $f2
		
				# $f4 = aHP = $t5 
				mtc1.d $t5, $f4 
				cvt.d.w $f4, $f4
		 
				# $f6 = dHP = $t6 
				mtc1.d $t6, $f6 
				cvt.d.w $f6, $f6
		
				# $f8 = baseDamage = $s5
				mtc1.d $s5, $f8 
				cvt.d.w $f8, $f8
		
				# $f10 = terrainBonus = $t9
				mtc1.d $t9, $f10 
				cvt.d.w $f10, $f10
		
				# $f14 = 100 = $s1 
				addi $s1, $zero, 100
				mtc1.d $s1, $f14 
				cvt.d.w $f14, $f14
		
				# $f16 = 200 = $s2 
				addi $s2, $zero, 200
				mtc1.d $s2, $f16 
				cvt.d.w $f16, $f16
		
				# $f18 = 10 = $s3 
				addi $s3, $zero, 10
				mtc1.d $s3, $f18 
				cvt.d.w $f18, $f18
			
			# end of loading all varibales into $f registers
			
			# equations for totalDamage
		
				add.d $f8, $f8, $f2 # $f8 = (baseDamage + luck)
				div.d $f4, $f4, $f18 # $f4 = (aHP / 10) or (aHP * 0.1)
			
				# $f10 = large calculation
				mul.d $f10, $f10, $f6 # terrainBonus * dHP
				add.d $f10, $f10, $f14 # 100 + (terrainBonus * dHP)
				sub.d $f10, $f16, $f10 # 200 - (100 + (terrainBonus * dHP))
				div.d $f10, $f10, $f14 # (200 - (100 + (terrainBonus * dHP))) / 100
			
				# multiply all 3 terms together, $f20 = (double) totalDamage
				mul.d $f20, $f8, $f4 # (baseDamage + luck) * (aHP / 10)
				mul.d $f20, $f20, $f10 # (baseDamage + luck) * (aHP / 10) * ((200 - (100 + (terrainBonus * dHP))) / 100)  
		
			# end of equations for totalDamage
			
			# convert $f20 into an int, store into $s0 (output)
			cvt.w.d $f20, $f20
			mfc1.d $s0, $f20
 		
		# end of calculating the totalDamage
		
		# jump back to AttackUnit function
		jr $ra
	
	# int subroutine function for CalcDamage
	# calculates the base damage from the attacking and defending units	
	CalcBaseDamage:
	
		# if-else statements calculating baseDamage if attacking unit is $s0
	
			# taken if attacking unit is $s0
			# $s5 = baseDamage
			bne $t7, $s0, CBDafter 
			
				# taken if defending unit is R
				lb $s0, R # $s0 = R
				bne $t8, $s0, CBDelse1
					addi $s5, $s1, 0 # baseDamage = $s1 
					j CBDafter
				# taken if defending unit is T
				CBDelse1: lb $s0, T # $s0 = T
				          bne $t8, $s0, CBDelse2
					   	addi $s5, $s2, 0 # baseDamage = $s2
						j CBDafter
				# taken if defending unit is A
				CBDelse2: lb $s0, A # $s0 = A
				          bne $t8, $s0, CBDelse3
					   	addi $s5, $s3, 0 # baseDamage = $s3
						j CBDafter
				# taken if defending unit is C
				CBDelse3: lb $s0, C # $s0 = C
				          bne $t8, $s0, CBDafter
					   	addi $s5, $s4, 0 # baseDamage = $s4
			
			CBDafter: # contiue with code
			
		# end of if-else statements calculating baseDamage if attacking unit is $s0 
	
		# jump back to CalcDamage
		jr $ra	
	
	# void function
	# calculates and updates powerCharge based on how much damage in funds was dealt
	CalcPowerCharge:
	
		# rounding all the HPs first, then creating aHPLost and dHPLost
			
			# divide all HPs by 10 (to get range from 1-10)
			# values rounded up if remainder >= 5, else rounds down (stays the same)
			# $s0 = remainder (initially stored in HI)
		
			# $t6 = rounded aoHP
			div $t6, $t1, 10
			mfhi $s0
			ble $s0, 0, CPCrounddown1
				add $t6, $t6, 1
			CPCrounddown1: # continue with code
		
			# $t7 = rounded anHP
			div $t7, $t2, 10
			mfhi $s0
			ble $s0, 0, CPCrounddown2
				add $t7, $t7, 1
			CPCrounddown2: # continue with code
		
			# $t8 = rounded doHP
			div $t8, $t4, 10
			mfhi $s0
			ble $s0, 0, CPCrounddown3
				add $t8, $t8, 1
			CPCrounddown3: # continue with code
		
			# $t9 = rounded dnHP
			div $t9, $t5, 10
			mfhi $s0
			ble $s0, 0, CPCrounddown4
				add $t9, $t9, 1
			CPCrounddown4: # continue with code
			
			# t6 = aHPLost, $t7 = dHPLost (both overwrite)
			sub $t6, $t6, $t7
			sub $t7, $t8, $t9 
	
		# end of rounding HPs and creating aHPLost and dHPLost
		
		# if-else statements calculating powerCharge gained by aHPLost
		# uses the least amount of registers
		
			# taken if attacking unit damaged was R
			lb $s0, R # $s0 = R (overwrites)
			bne $t0, $s0, CPCelse1.1
				mul $t6, $t6, 200
				add $a3, $a3, $t6 # add to powerCharge 
				j CPCafter1
		
			# taken if attacking unit damaged was T
			CPCelse1.1: lb $s0, T # $s0 = T
			            bne $t0, $s0, CPCelse1.2
			         	mul $t6, $t6, 350
					add $a3, $a3, $t6 # add to powerCharge
			          	j CPCafter1
			          	
			# taken if attacking unit damaged was A
			CPCelse1.2: lb $s0, A # $s0 = A
			            bne $t0, $s0, CPCelse1.3
			         	mul $t6, $t6, 400
 					add $a3, $a3, $t6 # add to powerCharge
			          	j CPCafter1
			          	
			# taken if attacking unit damaged was C
			CPCelse1.3: lb $s0, C # $s0 = C
			            bne $t0, $s0, CPCafter1
			          	mul $t6, $t6, 450
					add $a3, $a3, $t6 # add to powerCharge
			          	j CPCafter1
			
			CPCafter1: # continue with code 
		
		# end of if-else statements calculating powerCharge gained by aHPLost
		
		# if-else statements calculating powerCharge gained by dHPLost
		# uses the least amount of registers
		
			# taken if defending unit damaged was R
			lb $s0, R # $s0 = R 
			bne $t3, $s0, CPCelse2.1
				mul $t7, $t7, 400
				add $a3, $a3, $t7 # add to powerCharge 
				j CPCafter2
		
			# taken if defending unit damaged was T
			CPCelse2.1: lb $s0, T # $s0 = T
			            bne $t3, $s0, CPCelse2.2
			         	mul $t7, $t7, 700
					add $a3, $a3, $t7 # add to powerCharge
			          	j CPCafter2
			          	
			# taken if defending unit damaged was A
			CPCelse2.2: lb $s0, A # $s0 = A
			            bne $t3, $s0, CPCelse2.3
			         	mul $t7, $t7, 800
 					add $a3, $a3, $t7 # add to powerCharge
			          	j CPCafter2
			          	
			# taken if defending unit damaged was C
			CPCelse2.3: lb $s0, C # $s0 = C
			            bne $t3, $s0, CPCafter2
			          	mul $t7, $t7, 900
					add $a3, $a3, $t7 # add to powerCharge
			          	j CPCafter2
			
			CPCafter2: # continue with code 
		
		# end of if-else statements calculating powerCharge gained by dHPLost
		
		# jump back to previous function
		jr $ra
	
	
	
	# void function
	# subtracts unit cost from current funds
	UpdateFunds:

		# if-else statement updating funds based on unit
			
			# $t0 = BU's player unit
			# $t1 = unit compared to
			# taken if player unit is R
			lb $t1, R # $t1 = R
			bne $t0, $t1, UFelse1
				sub $a2, $a2, 4000 # subtract the unit's cost from funds
				j UFafter
		
			# taken if player unit is T
			UFelse1: lb $t1, T # $t1 = T
			         bne $t0, $t1, UFelse2
			         	sub $a2, $a2, 7000
			          	j UFafter
			          	
			# taken if player unit is A
			UFelse2: lb $t1, A # $t1 = A
			         bne $t0, $t1, UFelse3
			          	sub $a2, $a2, 8000
			          	j UFafter
			          	
			# taken if player unit is C
			UFelse3: lb $t1, C # $t1 = C
			         bne $t0, $t1, UFelse4
			          	sub $a2, $a2, 9000
			          	j UFafter
			          	
			# error case
			UFelse4: # print out UpdateFundsError
				 li $v0, 4
				 la $a0, UpdateFundsError
				 syscall
			
			UFafter: # continue with code	
			
		# end of if-else statement updating funds
		
		# jump back to previous function
		jr $ra
	
	

	


