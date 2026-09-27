module flagReg(
	input clk,
	input logic[3:0] OPCode,
	input logic N,Z,V,C,
	output logic ALUHighBLT,
	output logic ALUHighBNE);

always_ff @(posedge clk) begin
	ALUHighBLT <= N != V;
	ALUHighBNE <= !Z;
end

endmodule