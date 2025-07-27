module picoMIPS (
  input  logic       clk,
  input  logic [9:0] SW,
  output logic [7:0] LED
);

  cpu #(.n(8)) u_cpu (
    .clk(clk),
    .SW(SW),
    .LED(LED)
  );

endmodule
