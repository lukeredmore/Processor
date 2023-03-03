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

function ivrunproc() {
  updatefilelist
  cwd=$(pwd)
  tb=~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/CP-4-Processor/Wrapper_tb.v
  echo $tb >> ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/FileList.txt
  tbname=Wrapper_tb
  cd ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor
  iverilog -o $cwd/ivrun.out -c ~/Library/CloudStorage/OneDrive-DukeUniversity/Spring\ 2023/ECE\ 350/Processor/FileList.txt -s $tbname -Wimplicit -P Wrapper_tb.FILE=\"`echo $1`\"
  cd $cwd
  vvp ivrun.out
  rm ivrun.out
  
}
