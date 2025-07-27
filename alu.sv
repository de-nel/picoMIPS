//-----------------------------------------------------
// File Name   : alu.sv
// Function    : ALU module for picoMIPS
//-----------------------------------------------------

`include "alucodes.sv"  
module alu #(parameter n =8) (
   input logic [n-1:0] a, b, // ALU operands
   input logic  func, // ALU function code (2 in total)
   output logic [1:0] flags, // ALU flags only Z,N used
   output logic [n-1:0] result // ALU result
);       
//------------- code starts here ---------

// create an n-bit adder 
// and then build the ALU around the adder
logic signed [n*2-1:0] mul;
signed_mult multiplier(.result(mul), .a(a), .b(b));

logic[n-1:0] ar; // temp signals
always_comb
   ar = a+b; // n-bit adder
   
// create the ALU, use signal ar in arithmetic operations
always_comb
begin
  //default output values; prevent latches 
  flags = 1'b0;
  case(func)

   `RADD: result = ar; 
   `RMUL: result = mul[14:7];
   default: result = a;
   endcase

    // calculate flags Z and N
  flags[0] = result == {n{1'b0}}; // Z
  flags[1] = result[n-1]; // N
 
 end //always_comb
endmodule

//not used
  	// `RA   : result = a;
	// `RB   : result = b;
// arithmetic addition
      // // V
      // flags[3] = a[7] & b[7] & ~result[7] |  ~a[7] & ~b[7] 
      //             &  result[7];
      // // C
      // flags[0] = a[7] & b[7]  |  a[7] & ~result[7] | b[7] 
      //             & ~result[7];