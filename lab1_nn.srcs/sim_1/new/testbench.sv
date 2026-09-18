`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2026 10:10:05 PM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench();
    logic clk, reset;
    logic a,b,cin,s,cout,sexpected,coutexpected;
    
    logic [31:0] vectornum, errors;
    logic [4:0] testvectors[10000:0];
    
    fulladder dut(a,b,cin,s,cout);
    
    //create loop in another thread
    always
        begin
            clk = 1; #5;
            clk = 0; #5;
        end
    
    // begin test
    initial      
        begin
            //read file
            $readmemb("fulladder.tv", testvectors);
            
            //init vars
            vectornum=0;
            errors=0;
            
            reset=1; #22;
            reset=0;
        end
    
    //Create loop in another thread, only execute when rising eadge of clk logic
    always @(posedge clk)       
        begin     
            #1;
            
            {a,b,cin,coutexpected,sexpected} = testvectors[vectornum];
        end

    //Create loop in another thread, only execute when rising eadge of clk logic
    always @(negedge clk)        
        if(~reset) begin
            if (s !== sexpected || cout !== coutexpected) begin
                $display("Error: inputs = %b", {a, b, cin});
                $display(" outputs = %b %b (%b %b expected)", s, cout,sexpected, coutexpected);
                errors = errors + 1;
            end
            vectornum = vectornum + 1;
            
            if (testvectors[vectornum] === 5'bx) begin
                $display("%d tests completed with %d errors", vectornum,errors);
                $stop;
            end
        end

endmodule
