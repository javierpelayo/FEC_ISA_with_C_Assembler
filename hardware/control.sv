// control decoder
// opwidth is for ALUControl, mcodebits is for Control
module control #(parameter opwidth = 3, mcodebits = 4)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic RegSize,
     		   RegWrite, 
			   ALUSrc1, 
			   ALUSrc2, 
			   Branch,
			   MemWrite,
  output logic[1:0] Mem2Reg,
  output logic[opwidth-1:0] ALUOp);	   // for up to 8 ALU operations

// DEFAULT
// always_comb begin
// // defaults
//   RegDst 	=   'b0;   // 1: not in place  just leave 0
//   Branch 	=   'b0;   // 1: branch (jump)
//   MemWrite  =	'b0;   // 1: store to memory
//   ALUSrc 	=	'b0;   // 1: immediate  0: second reg file output
//   RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
//   MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
//   ALUOp	    =   'b111; // y = a+0;
// // sample values only -- use what you need
// case(instr)    // override defaults with exceptions
//   'b0000:  begin					// store operation
//                MemWrite = 'b1;      // write to data mem
//                RegWrite = 'b0;      // typically don't also load reg_file
// 			 end
//   'b00001:  ALUOp      = 'b000;  // add:  y = a+b
//   'b00010:  begin				  // load
// 			   MemtoReg = 'b1;    // 
//              end
// // ...
// endcase
// end
// END DEFAULT
	

always_comb begin
	RegSize		= 1'b0;
   	RegWrite 	= 1'b0;
	ALUSrc1 	= 1'b0;
	ALUSrc2 	= 1'b0;
	Branch 		= 1'b0;
	MemWrite 	= 1'b0;
    Mem2Reg 	= 2'b01;
    ALUOp 		= 3'b101;
case(instr)
// M-Type (extra bit added since 4 bits are required altho OPCode may be just 3 bits)
		4'b0000,4'b0001: begin // MOV X1,X2
			RegSize		= 1'b0;
   			RegWrite 	= 1'b1;
			ALUSrc1 	= 1'b0;
			ALUSrc2 	= 1'b1;
			Branch 		= 1'b0;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b10;
    		ALUOp 		= 3'b110;
		end
		4'b0010,4'b0011: begin  // ADDI X1,#Imm (3 bit, range: [-4,3])
			RegSize		= 1'b?;
   			RegWrite 	= 1'b1;
			ALUSrc1 	= 1'b1;
			ALUSrc2 	= 1'b0;
			Branch 		= 1'b0;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b10;
    		ALUOp 		= 3'b000;
		end
		4'b0100,4'b0101: begin  // STR X1,X2
			RegSize		= 1'b0;
   			RegWrite 	= 1'b0;
			ALUSrc1 	= 1'b0;
			ALUSrc2 	= 1'b1;
			Branch 		= 1'b0;
			MemWrite 	= 1'b1;
    		Mem2Reg 	= 2'b??;
    		ALUOp 		= 3'b110;

		end
		4'b0110,4'b0111: begin  // LDR X1,X2
			RegSize		= 1'b0;
   			RegWrite 	= 1'b1;
			ALUSrc1 	= 1'b0;
			ALUSrc2 	= 1'b1;
			Branch 		= 1'b0;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b00;
    		ALUOp 		= 3'b110;
		end

// AL-Type

		4'b1000: begin  // PAR X1,X2
			RegSize		= 1'b1;
   			RegWrite 	= 1'b1;
			ALUSrc1 	= 1'b?;
			ALUSrc2 	= 1'b0;
			Branch 		= 1'b0;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b10;
    		ALUOp 		= 3'b101;
		end
		4'b1001: begin  // AND X1,X2
			RegSize		= 1'b1;
   			RegWrite 	= 1'b1;
			ALUSrc1 	= 1'b0;
			ALUSrc2 	= 1'b0;
			Branch 		= 1'b0;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b10;
    		ALUOp 		= 3'b010;
		end
		4'b1010: begin  // EOR X1,X2
			RegSize		= 1'b1;
   			RegWrite 	= 1'b1;
			ALUSrc1 	= 1'b0;
			ALUSrc2 	= 1'b0;
			Branch 		= 1'b0;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b10;
    		ALUOp 		= 3'b011;
		end
		4'b1011: begin  // ROT X1,NP
			RegSize		= 1'b?;
   			RegWrite 	= 1'b1;
			ALUSrc1 	= 1'b?;
			ALUSrc2 	= 1'b0;
			Branch 		= 1'b0;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b10;
    		ALUOp 		= 3'b100;
		end

// Imm-Type

		4'b1100: begin  // CMP X1,X2
			RegSize		= 1'b0;
   			RegWrite 	= 1'b0;
			ALUSrc1 	= 1'b0;
			ALUSrc2 	= 1'b0;
			Branch 		= 1'b0;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b??;
    		ALUOp 		= 3'b001;
		end

// B-Type

		4'b1101: begin  // BNE X0,X1
			RegSize		= 1'b1;
   			RegWrite 	= 1'b0;
			ALUSrc1 	= 1'b0;
			ALUSrc2 	= 1'b0;
			Branch 		= 1'b1;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b??;
    		ALUOp 		= 3'b111;
		end
		4'b1110: begin  // BLT X0,X1
			RegSize		= 1'b1;
   			RegWrite 	= 1'b0;
			ALUSrc1 	= 1'b0;
			ALUSrc2 	= 1'b0;
			Branch 		= 1'b1;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b??;
    		ALUOp 		= 3'b111;
		end
		4'b1111: begin  // RST X1,NP
			RegSize		= 1'b?;
   			RegWrite 	= 1'b1;
			ALUSrc1 	= 1'b?;
			ALUSrc2 	= 1'b?;
			Branch 		= 1'b0;
			MemWrite 	= 1'b0;
    		Mem2Reg 	= 2'b01;
    		ALUOp 		= 3'b???;
		end
endcase

end

endmodule
