// lookup table
// deep 
// 9 bits wide; as deep as you wish
module instr_mem #(parameter D=12)(
  input       [D-1:0] pc,    // prog_ctr	  address pointer
  output logic[ 8:0] mc);

  logic[8:0] core[2**D];
  initial							    // load the program
    $readmemb("mach_code.txt",core);

  always_comb  mc = core[pc];

endmodule


/*
sample mach_code.txt:

001111110		 // ADD r0 r1 r0
001100110
001111010
111011110
101111110
001101110
001000010
111011110
*/
