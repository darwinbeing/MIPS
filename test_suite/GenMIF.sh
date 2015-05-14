#!/bin/bash

#----------------------------------------------------------------------
# The shell script creates a directory whose name is the same
# as the MIPS assembly file name. Then it converts
# the assembly program into FPGA memory ROM and RAM MIF files.
# 
# Check the file error.log in the "generated test program directory"
# if there is any error.
# 
#UTILS_PATH=/usr/local/3rdparty/csce611/CPU_support_files/utils
#
# Error report: jinz@email.sc.edu
#----------------------------------------------------------------------


#ROOT_PATH=/acct/s1/jinz/CSCE611/MIPS
ROOT_PATH=/share/jinz/MIPS
DSN_PATH=$ROOT_PATH/mips_sram_s3
TST_PATH=$ROOT_PATH/test_suite
UTILS_PATH=$TST_PATH/utils
SIM_PATH=$DSN_PATH/simulation
MIF_PATH=$DSN_PATH/test_data
cc_gcc=mips-r2000-linux-gnu-gcc
cc_as=mips-r2000-linux-gnu-as
cc_ld=mips-r2000-linux-gnu-ld
cc_strip=mips-r2000-linux-gnu-strip
cc_objdump=mips-r2000-linux-gnu-objdump

Fatal()
{
  filename=$1
  msg=$2

  if [ -s $filename ]
  then
    echo "$msg See error.log"
    exit
  fi
}

if [ "$1" != "" ]
then
  echo "Reading file $1.c"
else
  echo "Usage: $0 filename."
  exit
fi

#
if [ -d $1 ]
then
  rm -r $1
fi


echo "Compiling C file..."
# startup codes
$cc_as -mips1 ./init/init.s -o ./init/init.o
if [ $? != 0 ]; then
 exit
fi

# create a test directory named after the test program name
mkdir $1
cp ./c_programs/$1.c $1/
if [ $? != 0 ]; then
  exit
fi
cd $1

$cc_gcc -O0 -Wall -S $1.c -o $1.s 
if [ $? != 0 ]; then
  exit
fi

sed -i '/\<reorder\>/ d' $1.s
$cc_as -mips1 -xgot $1.s -o $1.o
$cc_ld -N -S -nostartfiles -nodefaultlibs -T $UTILS_PATH/script.x  ../init/init.o $1.o -o ld_$1
$cc_objdump -Dz ld_$1 > ld_$1.dis
$cc_strip -s -R .reginfo -R .pdr -R .comment ld_$1 -o strip_$1
$cc_objdump -Dz strip_$1 > $1.dis 

echo "Generating memory.code and memory.asm"
perl $UTILS_PATH/asm2hex.pl $1.dis 

tclsh $UTILS_PATH/GenerateDAT.tcl memory.code 2> error.log
Fatal error.log "Error in generating sliced memory data."

echo "Generating MIF files..."
tclsh $UTILS_PATH/GenerateMIF.tcl 2> error.log 
Fatal error.log "Error in generating .mif files."

echo "MIF file generation successful."

echo "Copy memory files..."
cp memory.code $SIM_PATH/RAM.dat
cp *.mif $MIF_PATH/

echo "Creating Do files..."
file="$SIM_PATH/mips_test.do"
if [ -e $file ]
then
  cp $file $SIM_PATH/mips_test.do.bak
fi
tclsh $UTILS_PATH/GenerateDoFile.tcl $SIM_PATH mips_test.do ld_$1.dis 2> error.log
Fatal error.log "Error in generating Modelsim Do file."

echo "Compiling source files..."
cd $SIM_PATH
vsim -c -do mips_test.do 
