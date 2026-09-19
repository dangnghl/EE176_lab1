`timescale 1ns / 1ps


module aludec(
    input logic opb5,
    input logic [2:0] funct3,
    input logic funct7b5,
    input logic [1:0] ALUOp,
    output logic [2:0] ALUControl
);
    
    // Virtual vars
    logic a,b,c,d,e,f,g;
    
    assign a = ALUOp[1];
    assign b = ALUOp[0];
    
    assign c = funct3[2];
    assign d = funct3[1];
    assign e = funct3[0];
    
    assign f = opb5;
    assign g = funct7b5;
    
    // NOT
    logic na,nb,nc,nd,ne;
    
    not n1(na,a);
    not n2(nb,b);
    not n3(nc,c);
    not n4(nd,d);
    not n5(ne,e);
    
    
    // Combination Logic
    //Bit 2
    and a1(ALUControl[2],a,nb,nc,d,ne);
    
    //Bit 1
    and a2(ALUControl[1],a,nb,c,d);
    
    //Bit 0
    logic t0,t1,t2;
    
    and a3(t0,na,b);
    and a4(t1,a,nb,nc,nd,ne,f,g);
    and a5(t2,a,nb,d,ne);
    
    or o1(ALUControl[0],t0,t1,t2);

endmodule
