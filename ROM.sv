//-----------------------------------------------------
// File Name : eROM.sv
// Function : Waveform ROM - 256 x 8-bit, reads from file wave.hex
//-----------------------------------------------------
module ROM
(
  input logic clk,
  input logic [7:0] address,        // 8-bit address (256 entries)
  output logic [7:0] data           // 8-bit waveform sample
);

// waveform ROM declaration
logic [7:0] progMem[255:0];

initial
  $readmemh("wave.hex", progMem);

  
always_ff@(posedge clk)
begin
	data <= progMem[address];
// load waveform values from file
end
endmodule // end of module waveROM
