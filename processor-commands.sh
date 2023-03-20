#!/bin/sh
function updatefilelist() {
  cwd=$(pwd)
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor
  realpath `find . -type f \( -iname "*.v" ! -iname "*_tb.v" ! -path "./Processor-Vivado/*" \)` > FileList.txt
  cd $cwd
}

function ivrun() {
  updatefilelist
  cwd=$(pwd)
  tb=`realpath $1`
  echo $tb >> ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor/FileList.txt
  tbname=`basename $1 .v`
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor
  iverilog -o $cwd/ivrun.out -c ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor/FileList.txt -s $tbname -Wimplicit
  cd $cwd
  vvp ivrun.out $2
  rm ivrun.out
}

function ivruncomp() {
  cwd2=$(pwd)
  assemblyfile=`realpath $1`
  testname=${assemblyfile:t:r}
  # echo $testname
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor/CP-4-Processor
  ./Test\ Files/Assembly\ Files/assembler/asm $assemblyfile
  mv ./Test\ Files/Assembly\ Files/$testname.mem ./Test\ Files/Memory\ Files/$testname.mem
  ivrunproc $testname
  cd $cwd2
}

function ivrunall() {
  cwd3=$(pwd)
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor/CP-4-Processor/
  printf "cycles\terrors\ttest\n"
  for f in ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor/CP-4-Processor/Test\ Files/Memory\ Files/**/*(.)
    do
    testname=${f:t:r}
    # printf "$testname\t"
    str=`ivrunproc $testname | grep -E 'Finished [0-9]+ cycles( with [0-9]+ error(s)?)?'`
    N=${str#Finished }      # remove "Finished " from the beginning of $str
    N=${N%% cycles*}        # remove " cycles" and everything after it from the end of $N
    M=${str##*with }        # remove everything before "with " from the beginning of $str
    M=${M%% errors*}        # remove " errors" and everything after it from the end of $M
    if [[ $M -eq 0 ]]; then
      M=" "
    fi
    printf "$N\t$M\t$testname\n"
    # column -t -s "|" <<< "$N|$M|$testname"
  done
  cd $cwd
}

function ivrunproc() {
  updatefilelist
  cwd=$(pwd)
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor/CP-4-Processor/
  tb=~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor/CP-4-Processor/Wrapper_tb.v
  echo $tb >> ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor/FileList.txt
  tbname=Wrapper_tb
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor
  iverilog -o $cwd/ivrun.out -c ~/Library/CloudStorage/OneDrive-DukeUniversity/ECE\ 350/Processor/FileList.txt -s $tbname -Wimplicit -P Wrapper_tb.FILE=\"`echo $1`\"
  cd $cwd
  vvp ivrun.out
  rm ivrun.out
  cd $cwd
}
