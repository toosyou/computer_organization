//0316055
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
    src1,       //1 bit source 1 (input)
    src2,       //1 bit source 2 (input)
    less,       //1 bit less     (input)
    A_invert,   //1 bit A_invert (input)
    B_invert,   //1 bit B_invert (input)
    cin,        //1 bit carry in (input)
    operation,  //operation      (input)
    result,     //1 bit result   (output)
    cout       //1 bit carry out(output)
    );

    input src1;
    input src2;
    input less;
    input A_invert;
    input B_invert;
    input cin;
    input [2-1:0] operation;

    output result;
    output cout;

    reg    result;
    reg    cout;

    localparam [1:0] OP_AND = 2'b00, OP_OR = 2'b01, OP_ADD = 2'b10;
    reg a, b;
    reg g, p;

    assign a = A_invert? !src1: src1;
    assign b = B_invert? !src2: src2;
    assign g = a & b;
    assign p = a | b;

    always@( * )begin
        if (operation==OP_AND) begin
            result <= g;
        end
        else if (operation==OP_OR) begin
            result <= p;
        end
        else begin//operation==OP_ADD
            result <= a ^ b ^ cin;
            cout <= g | (p&cin);
        end
    end

endmodule
