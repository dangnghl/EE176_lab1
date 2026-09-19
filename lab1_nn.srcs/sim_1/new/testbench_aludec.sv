module testbench_aludec();
  logic        clk, reset;
  logic        opb5;
  logic [2:0]  funct3;
  logic        funct7b5; 
  logic [1:0]  ALUOp;
  logic [2:0]  ALUControl, ALUControlexpected;
  logic [31:0] vectornum, errors;
  logic [9:0]  testvectors[10000:0];

  // instantiate device under test
  aludec dut(opb5, funct3, funct7b5, ALUOp, ALUControl);

  // generate clock
  always 
    begin
      clk = 1; #5; clk = 0; #5;
    end

  // at start of test, load vectors
  // and pulse reset
  initial
    begin
      $readmemb("aludec.tv", testvectors);
      vectornum = 0; errors = 0;
      reset = 1; #22; reset = 0;
    end

  // apply test vectors on rising edge of clk
  always @(posedge clk)
    begin
      #1; {ALUOp, funct3, opb5, funct7b5, ALUControlexpected} = testvectors[vectornum];
    end

  // check results on falling edge of clk
  always @(negedge clk)
    if (~reset) begin // skip during reset
      if (ALUControl !== ALUControlexpected) begin  // check result
        $display("Error: inputs = %b, %b, %b, %b", ALUOp, funct3, opb5, funct7b5);
        $display("  outputs = %b (%b expected)",ALUControl, ALUControlexpected);
        errors = errors + 1;
      end
      vectornum = vectornum + 1;
      if (testvectors[vectornum] === 10'bx) begin 
        $display("%d tests completed with %d errors", 
	           vectornum, errors);
        $stop;
      end
    end
endmodule