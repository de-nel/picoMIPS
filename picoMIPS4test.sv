// synthesise to run on Altera DE0 for testing and demo
module picoMIPS4test(
  input logic fastclk,  // 50MHz Altera DE0 clock
  input logic [9:0]   SW, // Switches SW0..SW9
  output logic [7:0]  LED,
  output logic [6:0]  HEX0,     // 7-segment digit 0
  output logic [6:0]  HEX1      // 7-segment digit 1
  ); // LEDs
  
  logic clk; // slow clock, about 10Hz
  
  counter c (.fastclk(fastclk),.clk(clk)); // slow clk from counter
  
  // to obtain the cost figure, synthesise your design without the counter 
  // and the picoMIPS4test module using Cyclone IV E as target
  // and make a note of the synthesis statistics
  picoMIPS myDesign (.clk(clk), .SW(SW),.LED(LED));
  
  
  
  // decode low nibble → HEX0
  sevenseg dec_lo (
    .value    (LED[3:0]), // bits 3–0
    .segments (HEX0)      // drives a,b,c,d,e,f,g of digit 0
  );

  // decode high nibble → HEX1
  sevenseg dec_hi (
    .value    (LED[7:4]), // bits 7–4
    .segments (HEX1)      // drives a,b,c,d,e,f,g of digit 1
  );
  
  endmodule  