#set text(font:"calibri")


= 2025-10-23 - Microcomputers

== Volatile
- Any variable can be declared volatile.
    - ``` volatile int c```
    - ``` volatile int *pc;```
- Tells C compiler never to trust recently-accessed value for the variable; always re-read memory to get latest value.

Ex.

``` d = a + b * c + b / c;```
- Most compilers only read 'b' from memory once on any subsequent appearances for the variable 'b'
- When 'c' is declared volatile, C compiler must read the value of 'c' from memory every time it apears in the program; it is not allowed to re-use a recently obtained value.

== SimpleCpu ISA
3 types of instructions

*Arithmetic:*
```
ADD rA, rB
SUB rA, rB
MUL rA, rB
AND rA, rB
```

*Data Movement:*
```
MOV rA, rB // rA = rB
MOV rA, IMM // rA = IMM
```
$"IMM" in {-1, 1}$

*Memory access and Output*
```
LOAD rA, [rB] // rA = Mem[rB]
STORE rA, [rB] // Mem[rB] = rA, destination of rB assigned to rA  
```

$0 - 127 -> "memory"$\
$ >=128 -> "output reg (hex display)"$

Hardware:

$"[1:0] Data" -> "ALU" ("SW[4:3] to control operations") -> "LED[5:0]", "outputs"$\ \
SW[4:3]:
- 00 $->$ +
- 01 $->$ -
- 10 $->$ $*$
- 11 $->$ &

LED[5:0]:
- 

#pagebreak()

Register file:

SW[9]: wA (decoder / enabler)
- 0: write to memory, do not write to any Register
- 1: write to register, designated by rA 
SW[8:7]: rA \
SW[6:5]: rB 

Mux:
SW[1:0]: Display result
- 01: for arithmetic operations




ex. ``` MUL r0, r3```

- SW[9]: 1 
- SW[8:7]: 00 
- SW[6:5]: 11
- SW[4:3]: 10 (ALUop)
- SW[1:0]: 01

*Instruction Sequence*
- Given a starting address and load signal
- Address sent to Instruction Memroy 
Instruction memory stores "instruction words" ie. bits that control the CPU circuit (controls SW[9:0])
- Next instruction is stored at "PC+1"
- User counter to generate PC, PC+1, PC+2 

If/else:
- Branches
    - ``` Bxx LOCATION```
    - Bxx = branch on condition xx, one of ${C, B, V A, V S, N, Z}$
- Jumps
    - ``` JMP LOCATION //always go to location```

#pagebreak()

= 2025-10-23 - RISC-V ISA 


#image("images/20251023154017.png")

- For input select = [1, 1, 1], move to next instruction. (Next state = [x,x,x,x])
- For state 1, if overflow = 1, next state -> 3. Else + 1 (next state -> 2)
- For state 2, we want it only to go to next state -> 4

== Chapter 6 - RISC-V ISA

- To negate $a$, it is essentially $0 - a$, so most instructions only provide subtraction instructions, not negation.

*Architecture*: Programmer's view of computer (defined by instructions, operand locations).

*Microarchitecture*: How to implement an architecture in hardware.

*Assembly Language*: Human-readable (perhaps) format of computer instructions.

*Machine Language*: Computer-readable format (binary)


RISC-V Assembly:

Addition:
```yasm
# s0 = a, s1 = b, s2 = c
add a, b, c # b and c are operated on, a is the result.
```
Subtraction:
```yasm
sub a, b, c
```

*Simplicity favors regularity*
- Consistent instruction format.
- Same number of operands (two sources, one destination)
- Easier to encode and handle in hardware

#pagebreak()

Ex. ``` a = b + c - d```

In assembly:
```yasm
add t, b, c # t = b + c
sub a, t, d # a = t - d
```

== Operands 

*Operand location:* Physical location on hardware ie Registers, memory, constants.

Registers are faster than memory.

"32-bit architecture": Uses 32-bit registers, operates on 32-bit data.


#image("images/20251023161953.png")

- x0 is always 0 
- Jump instruction can only write to x1 

*Registers*
- Can use name (``` ra, zero``` or ``` x0, x1```, etc.)
- Convention:
    - ``` s0 - s11```: holds variables
    - `t0 - t6`: hold temporary variables

Can use immediate instructions. 

ex. addi 

```yasm
# s0 = a, s1 = b 
addi s0, s1, 6
```

*Memory*

- Much slower than registers.
- Too much data to fit into 32 registers 
- Commonly used variables kept in registers 
- Cache: faster memory with smaller size in between memory and register speed

Word-addressable memory:
- Each 32-bit data word has a unique address


#image("images/20251023163128.png")

- To read from memory, call "load word" = `lw`

```yasm
lw t1, 5(s0)
lw destination, offset(base)
```

- Add base address (s0) to the offset (5)
- address = (s0 + 5)
- t1 holds the data value at address (s0 + 5)
- _any register_ may be used as base address

ex. Read word of data at memory address 1 into s3.

`lw s3, 1(zero) # read memory word 1 into s3`

- To write to memory, call "store" = `sw`

ex. Write value in t4 to memory address 3

```yasm
sw t4, 0x3(zero) # write value in t4 to memory word 3
```

- Add base address (zero) to offset (0x3)
- Address: (0 + 0x3) = 3
- Result: Writes the

Byte-addressable Memory 
- Each data byte has unique address
- Load/store words or single bytes: load byte `lb` and store byte `sb`
- 32-bit word = 4 bytes, so word address _increments by 4_ 

#image("images/20251023163851.png")

#image("images/20251023163926.png")

#image("images/20251023163942.png")

== Constants 
12-bit signed constants (immediates) using addi:

Assembly:
```yasm
# so = a, s1 = b 
addi s0, zero, -372
addi s1, s0, 6
```
C:
```c
// int is a 32-bit signed word
int a = -372;
int b = a + 6;
```

However, for assembly this does not work for values over 12 bits.

For these cases, use `lui` and addi.
- `lui` puts an immediate in the upper 20 bits of destination and 0s in lower 12 bits

Assembly:
```yasm
# s0 = a 
lui s0, 0xFEDC8
addi s0, s0, 0x765
```

C:
```c
int a = 0xFEDC8765;
```

#image("images/20251023165048.png")

== Logic/Shift instructions 
- and: useful for bit masking. ex.
    - 0xF234012F AND 0X000000FF = 0x0000002F
    - masks the last 2 bytes 
- or: useful for combining bit fields
    - Combine 0xF2340000 with 0x000012BC:
    - 0xF2340000 OR 0X000012BC = 0XF23412BC
- xor: uesful for invergin bits:
    - A XOR -1 = NOT A (-1 = 0xFFFFFFFF)
- sll: shift left logical
    - slli: immediate (`slli t0, t1, 23` $==>$ t0 = t1 << 23)
- srl: shift right logical (Inserts zeroes)
    - srli: immediate
- sra: shift right arithmetic (Preserves sign bit)
    - srai: immediate

_for non-immediate shifts, ie `sll t0, t1, t2` only takes the least 5 significant bits of t2._

== Multiplication and Division

32 x 32 multiplication $->$ 64 bit result 
```yasm
mul s3, s1, s2 # s3 = lower 32 bits of result
```

```yasm
mulh s4, s1, s2 # s4 = higher 32 bits of result
```

32-bit division $->$ 32 bit quotient and remainder

- div s3, s1, s2
- rem s4, s1, s2


== Branching
Conditional branches:
- beq: branch if equal
- bne: branch if not equal
- blt: branch if less than
- bge: branch if greater than or equal 

Unconditional:
- j: jump
- jr: jump register
- jal: jump and link 
- jalr: jump and link register

#image("images/20251023170828.png")

#image("images/20251023171059.png")

#pagebreak()

== Conditional Statements and Loops

*If statement:*

C:
```c
if (i == j) {
    f = g + h;
}
f = f - i;
```

RISC-V assembly:
```yasm
# s0 = f, s1 = g, s2 = h, s3 = i, s4 = j 
bne s3, s4, L1
add s0, s1, s2

L1:
    sub s0, s0, s3
```

*If else*\
C:
```c
if (i == j) {
    f = g + h;
} else {
    f = f - i;
}
```
Assembly:
```yasm
# s0 = f, s1 = g, s2 = h, s3 = i, s4 = j 
bne s3, s4, L1
add s0, s1, s2
j done

L1:
    sub s0, s0, s3
done:
```

*While loop*\
C:
```c
int pow = 1;
int x = 0;

while (pow != 128) {
    pow = pow * 2;
    x = x + 1;
}
```
Assembly:
```yasm
#s0 = pow, s1 = x

addi s0, zero, 1 
add s1, zero, zero 
addi t0, zero, 128 

while: 
    beq s0, t0, done
    slli s0, s0, 1 
    addi s1, s1, 1 
    j while
done:
```

*For loop*
for (initialization; condition; loop operation) {
statement
}

C:
```c
int sum = 0;
int i;

for (i = 0; i != 10; i++) {
    sum += i;
}
```

Assembly:
```yasm
# s0 = i, s1 = sum
    addi s1, zero, 0 
    add s0, zero, zero 
    addi t0, zero, 10 
for:
    beq s0, t0, done
    add s1, s1, s0
    addi s0, s0, 1 
    j for 
done:
```

*Less Than*

#image("images/20251023172047.png")

