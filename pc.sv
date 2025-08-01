//-----------------------------------------------------
// File Name : pc.sv
// Function : picoMIPS Program Counter
// functions: increment, absolute and relative branches
//-----------------------------------------------------
module pc #(parameter Psize = 5) // up to 8 instructions
(input logic clk, reset, PCincr,PCrelbranch,
 input logic [Psize-1:0] Branchaddr,
 output logic [Psize-1 : 0]PCout
);

//------------- code starts here---------
logic[Psize-1:0] Rbranch; // temp variable for addition operand
always_comb
  if (PCincr)
       Rbranch = { {(Psize-1){1'b0}}, 1'b1}; //add 1 LSB
  else Rbranch =  Branchaddr; // add branch addr 


always_ff @ ( posedge clk or posedge reset) // async reset
  if (reset) // sync reset
     PCout <= {Psize{1'b0}};
  else if (PCincr | PCrelbranch) // increment or relative branch
     PCout <= PCout + Rbranch; // 1 adder does both
endmodule // module pc



