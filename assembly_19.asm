lookup 6		#acc = 127 mem&. TODO: change syntax of key
put r11		#returnReg = 127 mem&
lookup 1
add r11		#acc = 128 mem&
put r5		#i = r5 = acc = 128 mem&
lookup 2
add r11		#acc = 129 mem&
put r6			#j = r6 = acc
lookup 0
put r2			#r2 = acc = biggestHamDist
put r4			#r4 = byte = acc = 0

                                #for loop from i=0 to 18 (19 times not 20)
	Binomial:		#for loop from j=i+1 to 19
		load r5		#acc = mem[i]
		put r7			#r7 = acc = mem[i]
		load r6		#acc = mem[j]
		put r8			#r8 = acc = mem[j]
		take r7		#acc = mem[i]
		xor r8			#acc = mem[i] ^ mem[j]
		put r9			#dist = acc = mem[i] ^ mem[j]
		lookup 0
		put r3			#currHamDist = acc = 0

		CheckLSB:		#for loop from byte = 0 to 7 (8bits)
			lookup 1		#mask.
			nand r9		#acc = !(dist & mask)
            		nand r0                #acc = !(acc & acc) = dist & mask
			put r10		#temp r10 = dist & mask
			lookup 1
			eql r10		#if acc == temp, acc = 1
			b0 NoMatch		#branch if acc == 0, acc != temp
			lookup 1
			add r3			#acc = r3 + 1 = currHamDist + 1
			put r3			#currHamDist++
			take r2		#acc = r2 = biggestHamDist
			lsn r3			#if acc=r2 < r3, if biggestHamDist < currHamDist, acc = 1
			b0 NoMatch		#branch if !(biggestHamDist < currHamDist)
			take r3		#acc = r3 = currHamDist
			put r2			#r2 = acc = r3, biggestHamDist = currHamDist
			lookup 8
			eql r2			#if acc == r2, if biggestHamDist == 8, acc = 1
			b0 NoMatch
			lookup 0
			b0 ReturnResult
			
			NoMatch:		#here if my if statement checks fail
			lookup 1
			put r10		#temp = r10 = 1
			take r9		#acc = r9 = dist
			shr r10		#acc = r9 >> 1 = dist >> 1
			lookup 1
			add r4			#acc = byte+1
			put r4			#r4 = byte = acc = byte+1, byte++
			lookup 8
			put r10		#temp = 8
			take r4		#acc = r4 = byte
			lsn r10		#if acc < 8, acc = 1
			put r10		#temp = acc
			lookup 0
			eql r10		#if acc == temp, temp == 0, acc = 1
			b0 CheckLSB		#byte < 8, acc = 0
		lookup 1
		add r11		#acc = 1+127
		put r10		#temp = 128
		take r5		#acc = i
		sub r10		#acc = i - 128
		add r6			#acc = i - 128 + j
		put r10		#temp = i - 128 + j
		lookup 1
		add r10		#acc = i-128+j+1
		put r6			#j = r6 = acc = i-128+j+1, c code: j=j+i+1
		lookup 2
		add r11		#acc = 2+127
		put r10		#temp = 129
		take r6		#acc = j
		sub r10		#acc = j-129
		put r10		#temp = j-129
		lookup 7      		#acc = 20
		put r7			#temp2 = 20
		take r10		#acc = temp = j-129
		lsn r7			#if acc < temp2=20, acc = 1
		put r10		#temp = acc
		lookup 0
		eql r10		#if acc == temp, temp == 0, !(j<20), acc = 1
		b0 Binomial		#(j < 20)
	
	lookup 1
	add r5			#acc = i + 1
	put r5			#i++
	lookup 1
    	add r11        	#acc = 1 + 127 = 128
	put r10		#temp = 128
	take r5		#acc = i
	sub r10		#acc = i - temp = i - 128
	put r10
	lookup 1
	put r7			#temp2 = 1
    	lookup 7		#acc =20
    	sub r7         	#acc = 19
    	put r7         	#temp2 = 19
	take r10		#acc= temp = i-128
	lsn r7			#if acc < 19, acc = 1
	put r10		#temp = acc
	lookup 0
	eql r10		#if acc == temp, temp == 0, !(j<20), acc = 1
	b0 Binomial		#branch to Binomial1 if i < 19
ReturnResult:
take r2		#acc = r2 = biggestHamDist
store r11		#mem[127] = acc = biggestHamDist