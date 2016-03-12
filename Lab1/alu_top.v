//0316055_0316313
`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    10:58:01 02/25/2016
// Design Name:
// Module Name:    alu_top
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
    input           src1,       //1 bit source 1 (input)
    input           src2,       //1 bit source 2 (input)
    input           less,       //1 bit less     (input)
    input           A_invert,   //1 bit A_invert (input)
    input           B_invert,   //1 bit B_invert (input)
    input           cin,        //1 bit carry in (input)
    input [1:0]     operation,  //operation      (input)
    
    output reg      result,     //1 bit result   (output)
    output          cout,      //1 bit carry out(output)
    output          set_less    //set less for the first alu_top
    );

    localparam [1:0] OP_AND = 2'b00, OP_OR = 2'b01, OP_ADD = 2'b10, OP_LESS = 2'b11;
    wire a, b;
    wire g, p;
    wire add_result;

    assign a = A_invert? !src1: src1;
    assign b = B_invert? !src2: src2;
    assign g = a & b;
    assign p = a | b;
    assign cout = g | (p&cin);
    assign add_result = a ^ b ^ cin;
    assign set_less = add_result;

    always @(*) begin
        case(operation)
            OP_AND:
                result = g;
            OP_OR:
                result = p;
            OP_ADD:
                result = add_result;
            OP_LESS:
                result = less;
        endcase
    end


endmodule
