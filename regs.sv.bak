//-----------------------------------------------------
// File Name : regs.sv
// Function : picoMIPS 32 x n registers, %0 == 0
//-----------------------------------------------------
module regs #(parameter n = 8) // n - data bus width
(input logic clk, w, // clk and write control
 input logic s_i,
 input logic [n-1:0] Wd_data,// write data
 input logic [2:0] Rd,// 3-bit addresses for 8 registers
 input logic [1:0] Rs,// 2-bit addresses for 4 registers
 input  logic [9:0] SW,        // slide-switch inputs (%1)
 output logic [n-1:0] Rs_data, Rd_data); // read data outputs


  // Declare 4 general-purpose n-bit registers
	logic [n-1:0] gpr [4:0];

	
	// write process, dest reg is Rd
	always_ff @ (posedge clk or posedge SW[9])
	begin
	if (SW[9]) begin
      for (int i = 0; i < 5; i++)  // clear all 6 registers on reset
        gpr[i] <= '0;
      end
	else if (w) begin
      gpr[Rd] <= Wd_data;
    end
	end

	// read process, output 0 if %0 is selected
	always_comb 
	begin
	// ---- Port A ----
	case (Rs)
		2'd0: Rs_data = 8'b0;                // %0 → zero
		2'd2: Rs_data = {7'b0, SW[8]};        // %2 → the single go-flag
		default: Rs_data = gpr[Rs];      // %3 (and beyond) → real register
	endcase

	// ---- Port B ----
	case (Rd)
		2'd0: Rd_data = 8'b0;
		2'd1: Rd_data = SW[7:0];// %1 → the 8 switch bits
		2'd2: Rd_data = {7'b0, SW[8]};
		default: Rd_data = gpr[Rd];
	endcase

 	if(SW[8] && s_i)
		Rd_data = gpr[4];
		
 	if(SW[9])begin
		Rd_data = 0;
		Rs_data = 0;
	end
	end
		

endmodule // module regs


