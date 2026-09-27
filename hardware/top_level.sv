module top_level ( input clk, reset,
	output logic done);

	parameter D = 12, A = 3; // PC width, ALUOp width
	wire[D-1:0] offset, pc;

	// Datapath
	wire[7:0] datA; // Register A output
	wire[7:0] datB; // Register B output
	wire[2:0] muxA; // Choose Register A input (RSize)
	wire[7:0] muxC; // Choose ALUsrc1
	wire[7:0] muxD; // Choose ALUsrc2
	wire muxE; // Choose PCSrc
	logic[7:0] muxF; // Choose Mem2Reg
	wire[7:0] ALUrslt; // ALU output
	wire[D-1:0] BALUrslt; // ALU output
	logic PCSrc;
	logic N, Z, V, C; // ALU flags
	logic ALUHighBLT;
	logic ALUHighBNE;

	// Control
	logic RegSize,
		  RegWrite,
		  ALUSrc1,
		  ALUSrc2,
		  Branch,
		  MemWrite;
	logic[1:0] Mem2Reg;
	logic[A-1:0] ALUOp;

	// Instruction Mem

	wire[8:0] mc;
	
	// Broken up machine code options
	wire[3:0] OPCode; // instr[8:5]
	wire[2:0] Reg1; // instr[5:3] OR instr[4:3]
	wire[2:0] Reg2; // instr[2:0] -- Write Register/Register 2
	wire[7:0] Imm; // instr[5:3]

	// Data Memory
	wire[7:0] data;

// Program Counter
PC #(.D(D)) pc1 (.reset(reset),
				 .clk(clk),
				 .offset(offset),
				 .PCSrc(muxE),
				 .pc(pc));

// Instruction Memory
instr_mem im1(.pc(pc),
			  .mc(mc));

assign OPCode = mc[8:5];

// control decoder
control ctl1(.instr(OPCode),
		     .RegSize(RegSize),
			 .RegWrite(RegWrite),
			 .ALUSrc1(ALUSrc1),
			 .ALUSrc2(ALUSrc2),
			 .Branch(Branch),
			 .MemWrite(MemWrite),
			 .Mem2Reg(Mem2Reg),
			 .ALUOp(ALUOp));

assign muxA = RegSize ? {1'b0,mc[4:3]} : mc[5:3];
assign Reg1 = muxA;
assign Reg2 = mc[2:0];
assign Imm = {{5{mc[5]}},mc[5:3]};

reg_file #(.pw(3)) rf1(.dat_in(muxF),
					   .clk(clk),
					   .wr_en(RegWrite),
					   .wr_addrB(Reg2),
					   .rd_addrA(Reg1),
					   .datA_out(datA),
					   .datB_out(datB));

assign offset = BALUrslt;

assign muxC = ALUSrc1 ? Imm : datA;
assign muxD = ALUSrc2 ? 8'b0 : datB;


flagReg flags(.clk(clk),
			  .OPCode(OPCode),
			  .N(N),
			  .Z(Z),
			  .V(V),
			  .C(C),
			  .ALUHighBLT(ALUHighBLT),
			  .ALUHighBNE(ALUHighBNE));

always_comb begin
	case(OPCode)
		4'b1110: PCSrc = Branch && ALUHighBLT;
		4'b1101: PCSrc = Branch && ALUHighBNE;
		default: PCSrc = 1'b0;
	endcase
end

assign muxE = PCSrc;

alu alu1(.ALUOp(ALUOp),
		 .inA(muxC),
		 .inB(muxD),
		 .rslt(ALUrslt),
		 .brslt(BALUrslt),
		 .N(N),
		 .Z(Z),
		 .V(V),
		 .C(C));

dat_mem dm1(.dat_in(datB),
			.clk(clk),
		    .reset(reset),
			.wr_en(MemWrite),
			.addr(ALUrslt),
			.dat_out(data));

always_comb begin
	case(Mem2Reg)
		2'b00: muxF = data;
		2'b01: muxF = 8'b00000000;
		2'b10: muxF = ALUrslt;
	endcase
end

assign done = (pc == 4095);


endmodule

