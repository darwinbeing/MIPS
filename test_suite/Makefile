######################## init file generation ##############################
init.o : init.s Makefile
	./cc_as -mips1 init.s -o init.o


########################  loop test ###########################
loop.o : loop.c Makefile 
	cc_gcc -O0 -Wall -S loop.c -o loop.s 
	sed -i '/\<reorder\>/ d' loop.s
	cc_as -mips1 -xgot loop.s -o loop.o

ld_loop: init.o loop.o script.x
	#cc_ld -N -S -nostartfiles -T ./script.x  init.o loop.o -o ld_loop -lc
	cc_ld -N -S -nostartfiles -nodefaultlibs -T ./script.x  init.o loop.o -o ld_loop
	cc_objdump -Dz ld_loop > ld_loop.dis

strip_loop: ld_loop
	cc_strip -s -R .reginfo -R .pdr -R .comment ld_loop -o strip_loop

loop.dis: strip_loop
	cc_objdump -Dz strip_loop > loop.dis 

loop: loop.dis
	perl asm2hex.pl loop.dis 

########################  sort test ###########################
sort.o : sort.c Makefile 
	cc_gcc -O0 -Wall -S sort.c -o sort.s 
	sed -i '/\<reorder\>/ d' sort.s
	cc_as -mips1 -xgot sort.s -o sort.o

ld_sort: init.o sort.o script.x
	#cc_ld -N -S -nostartfiles -T ./script.x  init.o sort.o -o ld_sort -lc
	cc_ld -N -S -nostartfiles -nodefaultlibs -T ./script.x  init.o sort.o -o ld_sort
	cc_objdump -Dz ld_sort > ld_sort.dis

strip_sort: ld_sort
	cc_strip -s -R .reginfo -R .pdr -R .comment ld_sort -o strip_sort

sort.dis: strip_sort
	cc_objdump -Dz strip_sort > sort.dis 

sort: sort.dis
	perl asm2hex.pl sort.dis 
	tclsh memory_split.tcl
#	cp inst_mem.code ../sim
#	cp data_mem.data ../sim
#	cp inst_mem_init.v ../src
#	cp data_mem_init.v ../src


########################  laplace test ###########################
laplace.o : laplace.c Makefile 
	cc_gcc -O0 -Wall -S laplace.c -o laplace.s 
	sed -i '/\<reorder\>/ d' laplace.s
	cc_as -mips1 -xgot laplace.s -o laplace.o

ld_laplace: init.o laplace.o script.x
	cc_ld -N -S -nostartfiles -nodefaultlibs -T ./script.x  init.o laplace.o -o ld_laplace
	cc_objdump -Dz ld_laplace > ld_laplace.dis

strip_laplace: ld_laplace
	cc_strip -s -R .reginfo -R .pdr -R .comment ld_laplace -o strip_laplace

laplace.dis: strip_laplace
	cc_objdump -Dz strip_laplace > laplace.dis 

laplace: laplace.dis
	perl asm2hex.pl laplace.dis 
	tclsh memory_split.tcl


########################  Fibonacci test ###########################
Fibonacci.o : Fibonacci.c Makefile 
	cc_gcc -O0 -Wall -S Fibonacci.c -o Fibonacci.s 
	sed -i '/\<reorder\>/ d' Fibonacci.s
	cc_as -mips1 -xgot Fibonacci.s -o Fibonacci.o

ld_Fibonacci: init.o Fibonacci.o script.x
	cc_ld -N -S -nostartfiles -nodefaultlibs -T ./script.x  init.o Fibonacci.o -o ld_Fibonacci
	cc_objdump -Dz ld_Fibonacci > ld_Fibonacci.dis

strip_Fibonacci: ld_Fibonacci
	cc_strip -s -R .reginfo -R .pdr -R .comment ld_Fibonacci -o strip_Fibonacci

Fibonacci.dis: strip_Fibonacci
	cc_objdump -Dz strip_Fibonacci > Fibonacci.dis 

Fibonacci: Fibonacci.dis
	perl asm2hex.pl Fibonacci.dis 
	tclsh memory_split.tcl

########################  bubble_sort test ###########################
bubble_sort.o : bubble_sort.c Makefile 
	cc_gcc -O0 -Wall -S bubble_sort.c -o bubble_sort.s 
	sed -i '/\<reorder\>/ d' bubble_sort.s
	cc_as -mips1 -xgot bubble_sort.s -o bubble_sort.o

ld_bubble_sort: init.o bubble_sort.o script.x
	cc_ld -N -S -nostartfiles -nodefaultlibs -T ./script.x  init.o bubble_sort.o -o ld_bubble_sort
	cc_objdump -Dz ld_bubble_sort > ld_bubble_sort.dis

strip_bubble_sort: ld_bubble_sort
	cc_strip -s -R .reginfo -R .pdr -R .comment ld_bubble_sort -o strip_bubble_sort

bubble_sort.dis: strip_bubble_sort
	cc_objdump -Dz strip_bubble_sort > bubble_sort.dis 

bubble_sort: bubble_sort.dis
	perl asm2hex.pl bubble_sort.dis 
	tclsh memory_split.tcl

########################  binarySearch test ###########################
binarySearch.o : binarySearch.c Makefile 
	cc_gcc -O0 -Wall -S binarySearch.c -o binarySearch.s 
	sed -i '/\<reorder\>/ d' binarySearch.s
	cc_as -mips3 -xgot binarySearch.s -o binarySearch.o

ld_binarySearch: init.o binarySearch.o script.x
	cc_ld -N -S -nostartfiles -nodefaultlibs -T ./script.x  init.o binarySearch.o -o ld_binarySearch
	cc_objdump -Dz ld_binarySearch > ld_binarySearch.dis

strip_binarySearch: ld_binarySearch
	cc_strip -s -R .reginfo -R .pdr -R .comment ld_binarySearch -o strip_binarySearch

binarySearch.dis: strip_binarySearch
	cc_objdump -Dz strip_binarySearch > binarySearch.dis 

binarySearch: binarySearch.dis
	perl asm2hex.pl binarySearch.dis 
	tclsh memory_split.tcl

########################  cache instruction test ###########################
cache_test.o : cache_test.c Makefile 
	cc_gcc -O0 -Wall -S cache_test.c -o cache_test.s 
	sed -i '/\<reorder\>/ d' cache_test.s
	cc_as -mips3 -xgot cache_test.s -o cache_test.o

ld_cache_test: init.o cache_test.o script.x
	cc_ld -N -S -nostartfiles -nodefaultlibs -T ./script.x  init.o cache_test.o -o ld_cache_test
	cc_objdump -Dz ld_cache_test > ld_cache_test.dis

strip_cache_test: ld_cache_test
	cc_strip -s -R .reginfo -R .pdr -R .comment ld_cache_test -o strip_cache_test

cache_test.dis: strip_cache_test
	cc_objdump -Dz strip_cache_test > cache_test.dis 

cache_test: cache_test.dis
	perl asm2hex.pl cache_test.dis 

######################## ALU test vectors generation ##############################
ALU_test.o : ALU_test.c Makefile 
	cc_gcc -O2 -Wall -S ALU_test.c -o ALU_test.s 
	sed -i '/\<reorder\>/ d' ALU_test.s
	cc_as -mips1 -xgot ALU_test.s -o ALU_test.o

ld_ALU_test: init.o ALU_test.o script.x
	#cc_ld -N -S -nostartfiles -T ./script.x  init.o ALU_test.o -o ld_ALU_test -lc
	cc_ld -N -S -nostartfiles -nodefaultlibs -T ./script.x  init.o ALU_test.o -o ld_ALU_test
	cc_objdump -Dz ld_ALU_test > ld_ALU_test.dis

strip_ALU_test: ld_ALU_test
	cc_strip -s -R .reginfo -R .pdr -R .comment ld_ALU_test -o strip_ALU_test

ALU_test.dis: strip_ALU_test
	cc_objdump -Dz strip_ALU_test > ALU_test.dis 

################### Clean #######################
clean:
	rm *.o 
