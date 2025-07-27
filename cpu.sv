//------------------------------------
// File Name   : cpu.sv
// Function    : picoMIPS CPU top level encapsulating module, version 2
// Ver 2 :  PC , prog memory, regs, ALU and decoder, no RAM
//------------------------------------

`include "alucodes.sv"
`include "opcodes.sv"

module cpu #( parameter n = 8) // data bus width
(input logic clk,  
    input logic [9:0] SW,  // 10 Switches: Reset, SW8, inputs;
    output logic[n-1:0] LED // need an output port, tentatively this will be the ALU output
);       

// declarations of local signals that connect CPU modules
// ALU
logic ALUfunc; // ALU function
logic [7:0] aluResult;

logic [1:0] flags; // ALU flags, routed to decoder

logic imm; // immediate operand signal
logic dres; // ROM read data control

logic [7:0] Alub; // output from imm MUX
//
// registers
logic [7:0] Rs_data, Rd_data, Wd_data; // Register data
logic w; // register write control
//
// Program Counter 
parameter Psize = 5; // up to 32 instructions
logic PCincr,PCrelbranch; // program counter control
logic [Psize-1 : 0]ProgAddress;

// Program Memory
parameter Isize = n+8; // Isize - instruction width
logic [Isize-1:0] I; // I - instruction code

//ROM wave data
logic [7:0] Rdata;

logic s_i;
//------------- code starts here ---------
// module instantiations
pc  #(.Psize(Psize)) progCounter (.clk(clk),.reset(SW[9]),
        .PCincr(PCincr),
        .PCrelbranch(PCrelbranch),
        .Branchaddr(I[Psize-1:0]), 
        .PCout(ProgAddress) );

prog #(.Psize(Psize),.Isize(Isize)) 
      progMemory (.address(ProgAddress),.I(I));

// bit-layout of I[15:0] is { opcode[15:13], rd[12:10], rs[9:8], imm[7:0] }
decoder  D (.opcode(I[Isize-1:Isize-3]), // bits 15:13
            .flags(flags), // ALU flags
            .PCincr(PCincr),
            .PCrelbranch(PCrelbranch),
	    .ALUfunc(ALUfunc),.imm(imm),.w(w),.s_i(s_i),.dres(dres));

// bit-layout of I[15:0] is { opcode[15:13], rd[12:10], rs[9:8], imm[7:0] }
regs   #(.n(n))  gpr(.clk(clk),.w(w),
		.s_i(s_i),
        .Wd_data(Wd_data),
	.Rd(I[12:10]),  // reg %d number
	.Rs(I[9:8]), // reg %s number
        .SW(SW),
        .Rs_data(Rs_data),
        .Rd_data(Rd_data));

alu    #(.n(n))  iu(.a(Rs_data),.b(Alub),
       .func(ALUfunc),.flags(flags),
       .result(aluResult)); // ALU result -> destination reg

ROM waveROM (
  .clk(clk),
  .address(aluResult),
  .data(Rdata)
);
// create MUX for immediate operand
assign Alub = (imm ? I[7:0] : Rd_data);

// connect ALU result to outport
assign Wd_data = (dres ? Rdata : aluResult); 

assign LED = Wd_data ;


endmodule
