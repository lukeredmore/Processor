#!/bin/sh
function updatefilelist() {
  cwd=$(pwd)
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor
  realpath `find . -type f \( -iname "*.v" ! -iname "*_tb.v" ! -path "./Processor-Vivado/*" \)` > FileList.txt
  cd $cwd
}

function ivrun() {
  updatefilelist
  cwd=$(pwd)
  tb=`realpath $1`
  echo $tb >> ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/FileList.txt
  tbname=`basename $1 .v`
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor
  iverilog -o $cwd/ivrun.out -c ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/FileList.txt -s $tbname -Wimplicit
  cd $cwd
  vvp ivrun.out $2
  rm ivrun.out
}

function ivruncomp() {
  cwd2=$(pwd)
  assemblyfile=`realpath $1`
  testname=${assemblyfile:t:r}
  # echo $testname
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/CP-4-Processor
  ./Test\ Files/Assembly\ Files/assembler/asm $assemblyfile
  mv ./Test\ Files/Assembly\ Files/$testname.mem ./Test\ Files/Memory\ Files/$testname.mem
  ivrunproc $testname
  cd $cwd2
}

function ivrunall() {
  cwd3=$(pwd)
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/CP-4-Processor/
  for f in ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/CP-4-Processor/Test\ Files/Memory\ Files/**/*(.)
    do
    testname=${f:t:r}
    printf "$testname: "
    ivrunproc $testname | grep -E 'Finished [0-9]+ cycles( with [0-9]+ error(s)?)?'
  done
  cd $cwd
}

function ivrunproc() {
  updatefilelist
  cwd=$(pwd)
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/CP-4-Processor/
  tb=~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/CP-4-Processor/Wrapper_tb.v
  echo $tb >> ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/FileList.txt
  tbname=Wrapper_tb
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor
  iverilog -o $cwd/ivrun.out -c ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/FileList.txt -s $tbname -Wimplicit -P Wrapper_tb.FILE=\"`echo $1`\"
  cd $cwd
  vvp ivrun.out
  rm ivrun.out
  cd $cwd
}
