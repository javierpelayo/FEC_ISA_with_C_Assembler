// combinational -- no clock
module alu(
  input[2:0] ALUOp,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path (SSS, DDD)
  // input      sc_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic[11:0] brslt,
  output logic N, Z, V, C); // negative, zero, overflow, carry, parity respectively.

// NOTE: what changes in the block is what gets recalculated
always_comb begin
	 N = rslt[7];
	 Z = !rslt;
	 V = 'b0; // pos + pos = neg OR neg + neg = pos
	 C = 'b0; // carry out
	 // P = 'b0;
	 case(ALUOp)
		3'b000: begin // ADD
			{C,rslt} = inB + inA;
			if(inA > 0 && inB > 0 && rslt < 0)
				V = 'b1;
			if(inA < 0 && inB < 0 && rslt > 0)
				V = 'b1;
	 		N = rslt[7];
	 		Z = !rslt;
		end
		3'b001: begin // SUB - CMP
			{C,rslt} = inB - inA;
			if (inA > 0 && inB < 0 && rslt < 0)
				V = 'b1;
			if (inA < 0 && inB > 0 && rslt > 0)
				V = 'b1;
	 		N = rslt[7];
	 		Z = !rslt;
		end
		3'b010: begin // AND
			rslt = inB & inA;
		end
		3'b011: begin // EOR
			rslt = inB ^ inA;
		end
		3'b100: begin // ROT (rotates right by 1)
			rslt = {inB[0],inB[7:1]};
		end
		3'b101: begin // reduction XOR
			rslt = ^inB;
		end
		3'b110: begin // NOTHING - passthrough input A
			rslt = inA;
		end
		3'b111: begin
			brslt = {{2{inB[7]}},inB[7:0],2'b00} + {{4{inA[7]}},inA};
		end
   	 endcase
end

// DEFAULT
// always_comb begin 
//   rslt = 'b0;
//   sc_o = 'b0;
//   zero = !rslt;
//   pari = ^rslt;
//   case(alu_cmd)
//     3'b000: // add 2 8-bit unsigned; automatically makes carry-out
//       {sc_o,rslt} = inA + inB + sc_i;
// 	3'b001: // left_shift
// 	  {sc_o,rslt} = {inA, sc_i};
//       /*begin
// 		rslt[7:1] = ina[6:0];
// 		rslt[0]   = sc_i;
// 		sc_o      = ina[7];
//       end*/
//     3'b010: // right shift (alternative syntax -- works like left shift
// 	  {rslt,sc_o} = {sc_i,inA};
//     3'b011: // bitwise XOR
// 	  rslt = inA ^ inB;
// 	3'b100: // bitwise AND (mask)
// 	  rslt = inA & inB;
// 	3'b101: // left rotate
// 	  rslt = {inA[6:0],inA[7]};
// 	3'b110: // subtract
// 	  {sc_o,rslt} = inA - inB + sc_i;
// 	3'b111: // pass A
// 	  rslt = inA;
//   endcase
// end
// // END DEFAULT
   
endmodule
