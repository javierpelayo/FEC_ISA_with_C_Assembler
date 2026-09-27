// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=12)(
  input reset,					// synchronous reset
        clk,
  input logic[D-1:0] offset,
  input logic PCSrc,
  output logic[D-1:0] pc
);

  always_ff @(posedge clk)
    if(reset)
	  pc <= '0;
	else if(PCSrc)
	  pc <= pc + offset;
	else
	  pc <= pc + 'b1;

endmodule
