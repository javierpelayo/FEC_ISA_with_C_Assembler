// 8-bit wide, 256-word (byte) deep memory array
module dat_mem (
  input[7:0] dat_in,
  input      clk,
  input		 reset,
  input      wr_en,	          // write enable
  input[7:0] addr,		      // address pointer
  output logic[7:0] dat_out);

  logic[7:0] core[256];       // 2-dim array  8 wide  256 deep

// NOTE: mem[0:29] - decoded
//       mem[30:59] - encoded
//       mem[60:69] - branch offsets
//       mem[70:74] - parity bit recieved program 2 --> p8 p4 p2 p1 p0
//       mem[75] - syndrome prog 2
//       mem[76] - loop counter prog 2
//       
//       mem[82] - outer loop counter program 1
//       mem[83:255] - whatever

// reads are combinational; no enable or clock required
  assign dat_out = core[addr];

// writes are sequential (clocked) -- occur on stores or pushes 
  always_ff @(posedge clk) begin
	if(reset) begin // branching offsets
		core[60] <= -56; // outer loop shifted offset -- program 1
		core[61] <= -2; // outer loop offset -- program 1
		core[62] <= -19; // << 2, branch offset p4 sX loop - program 2 -- offset = -18*4+2
		core[63] <= -31; // branch offset p2 sX loop - program 2 -- offset = -30*4+3
		core[64] <= -43; // branch offset p1 sX loop - program 2 -- offset = -41*4-4
		core[65] <= 0; // counter for sX loop - program 2
		core[66] <= -115; // shifted branch offset for outer loop - program 2
		core[67] <= -21; // branch offset for outer loop - program 2
		core[68] <= 0;
		core[69] <= 0;
		core[75] <= 0;
		core[76] <= 2; // cond p4 for sX loop - program 2
		core[77] <= 3; // cond p2 for sX loop - program 2
		core[78] <= 4; // cond p1 for sX loop - program 2
		core[79] <= 0;
		core[82] <= 0; // outer loop counter for program 2
		core[83] <= 0; // decoded address pointer (e.g. &mem[0])
		core[84] <= 0; // encoded address pointer (e.g. &mem[30])
	end

    if(wr_en)				  // wr_en usually = 0; = 1 		
      core[addr] <= dat_in; 
  end
endmodule
