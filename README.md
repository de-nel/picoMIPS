--------------------------------------------------------

picoMIPS – Gaussian Smoothing Processor
--------------------------------------------------------



--------------------------------------------------------

Summary
--------------------------------------------------------

This project implements an 8-bit processor (picoMIPS) designed to perform 1D Gaussian smoothing on a 256-sample waveform.
The processor is written in SystemVerilog, tested in ModelSim, and synthesized on a Cyclone V FPGA using Intel Quartus.

--------------------------------------------------------

Gaussian Smoothing Kernel used:
--------------------------------------------------------

[17, 29, 35, 29, 17]


--------------------------------------------------------

Computation:
--------------------------------------------------------

S[i] = W[i−2]*17 + W[i−1]*29 + W[i]*35 + W[i+1]*29 + W[i+2]*17

Only bits [14:7] of the 16-bit multiplication result are used to fit the 8-bit output.

--------------------------------------------------------

Instruction Set:
--------------------------------------------------------

NOP (000): No operation

ADD (001): Add two registers

MULI (010): Multiply register by immediate

BNE (011): Branch if not equal

BEQ (100): Branch if equal

LWD (101): Load from ROM

--------------------------------------------------------

Execution Flow
--------------------------------------------------------

Wait for SW8 = 1

Read index from SW[7:0]

Perform convolution

Output result to LEDs

Wait for SW8 = 0, then repeat

--------------------------------------------------------

FPGA Resource Usage
--------------------------------------------------------

ALMs: 56

Memory bits: 2048

DSP blocks: 1

Total cost: 116

