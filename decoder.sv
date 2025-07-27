//---------------------------------------------------------
// File Name   : decoder.sv
// Function    : picoMIPS instruction decoder 
//---------------------------------------------------------

`include "alucodes.sv"
`include "opcodes.sv"
//---------------------------------------------------------
module decoder( 
input logic [2:0] opcode, // top 3 bits of instruction  I[15:13]
input [1:0] flags, // ALU for 2 flags
output logic PCincr,PCrelbranch, //    PC control
output logic ALUfunc, //    ALU control 8 differennt instructions
output logic imm,// imm mux control
output logic w, //   register file control
output logic s_i,
output logic dres // ROM read data control

  );
   
//------------- code starts here ---------
// instruction decoder
logic takeBranch; // temp variable to control conditional branching
always_comb 
begin
  // set default output signal values for NOP instruction
  PCincr = 1'b1; // PC increments by default
  PCrelbranch = 1'b0;
  ALUfunc = 1'b0; 
  imm=1'b0; 
  w=1'b0; 
  takeBranch =  1'b0; 
  dres = 1'b0;
  s_i= 1'b0;
  case(opcode)
    `NOP: ;

    `ADD: begin // register-register
      w = 1'b1; // write result to dest register
      ALUfunc = `RADD;
    end

    `MULI: begin
      w = 1'b1;
      imm = 1'b1;
      ALUfunc = `RMUL;
    end

    `LWD: begin
      w = 1'b1;
      imm = 1'b1;
      dres = 1'b1;
      ALUfunc = `RADD; // or pass-through operand A
    end
	 	  
    // relativ conditional branches
    `BEQ: begin 
	  w = 1'b0;
      takeBranch = flags[0]; // branch if Z==1
      ALUfunc = `RADD;
    end
    `BNE: begin
	  w = 1'b0;
      s_i = 1'b1;
      takeBranch = ~flags[0]; // branch if Z==0
      ALUfunc = `RADD;
    end
    // `BGE: takeBranch = ~flags[2]; // branch if N==0
    // `BLO: takeBranch = flags[0]; // branch if C==1
	default:
	    $error("unimplemented opcode %h",opcode);
 
  endcase // opcode
  
   if(takeBranch) // branch condition is true;
   begin
      PCincr = 1'b0;
	    PCrelbranch = 1'b1; 
   end


end // always_comb


endmodule 
