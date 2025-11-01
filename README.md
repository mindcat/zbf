### Zig compiler for BrainF*ck

## usage
```bash
zbf -f <filename> -i <interpreter> -v <visual verbosity> -s <speed> -c <cell size> -a <array size>
```
filename (string): path to .bf file being ran
interpeter (flag true, default false): if called, instead of exiting after running all the bf commands within the file, it returns to a prompt (interpreter) where the user can intermittently provide more commands and input.
visual verbosity (int 0-3, default 0): if on (at massive performance cost) displays the cells as they are operated on. 
e.g. v=3
```
op count: 0
++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++[.]
n 0 1 2  3   4  5  6  7 8 9     30k
| 0 0 72 100 87 33 10 0 0 0 ... |
out: Hello World!
in: 
```
speed (int -1->10,000): if -1, prompts for # of clock cycles it should run. if 0, runs at full speed (no sleeping). if 1-10,000, sleeps for a portion after each operation as to match the cycle clock of the int in hz (actual operations are negligible).
cell size (8, 16, 32, 64, 128 bit, default 8 bit): cell size in bits
array size (int, default 30k): size of cell array

# compiler behavior


1. First, it will initialize (and allocate) an array (size a) of cells (bit len c).
2. If a filename is declared, pass it's instructions into brnfk to process it.

# language properties
