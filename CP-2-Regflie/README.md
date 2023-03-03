# Project Checkpoint 2 (Register File)
Luke Redmore (lr197)&emsp;|&emsp;ECE 350&emsp;|&emsp;Spring 2023

This register file contains 32 32-bit registers. It has one write port and two read ports on the data path and a write enable, write destination, read A source, and read B source, and (asynchronous) reset on the control path.

Each register is made from 32 D-Flip-Flops and is set on the rising clock edge when its write is enabled. They also have an asynchronous clear input which immediately resets its value to 0, regardless of where the clock is or if write enable is HI.

The output of each register is connected to two tri-state enables, one for out_A and one for out_B. Three decoders, implemented with a left shift of a single HI bit, are used to enable the write, read A and read B for the correct register.

