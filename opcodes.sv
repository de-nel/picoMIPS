// opcodes.sv
//-----------------------------------------------------
// File Name   : opcodes.sv
// Function    : picoMIPS opcode definitions 

//-----------------------------------------------------

// NOP
`define NOP  3'b000
// ADD %d, %s;  %d = %d+%s
`define ADD  3'b001
// MUL %d, %s;  %d = %d * %s
`define MULI 3'b010
// BNE %d, %s, imm; PC = (%d!=%s? PC+ imm : PC+1)
`define BNE  3'b011
// BEQ %d, %s
`define BEQ  3'b100
// LW %d, %s, imm; %d = mem[%s+imm]
`define LWD  3'b101

