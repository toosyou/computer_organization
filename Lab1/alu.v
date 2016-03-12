//0316055_0316313

`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 02/25/2016
// Design Name:
// Module Name:    alu
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

module alu(
    input               rst_n,         // negative reset            (input)
    input [31:0]        src1,          // 32 bits source 1          (input)
    input [31:0]        src2,          // 32 bits source 2          (input)
    input [3:0]         ALU_control,   // 4 bits ALU control input  (input)
                    //bonus_control, // 3 bits bonus control input(input)
    output reg [31:0]   result,        // 32 bits result            (output)
    output reg [31:0]   zero,          // 1 bit when the output is 0, zero must be set (output)
    output reg          cout,          // 1 bit carry out           (output)
    output reg          overflow       // 1 bit overflow            (output)
    );

    localparam [3:0] OP_AND=4'b0000, OP_OR=4'b0001, OP_ADD=4'b0010, OP_SUB=4'b0110, OP_NOR=4'b1100, OP_NAND=4'b1101, OP_SLT=4'b0111;
    reg [31:0]      a;
    reg [31:0]      b;
    reg             a_invert;
    reg             b_invert;
    reg             first_cin;
    reg [1:0]       operation;

    wire carry_ins[32:0];
    wire set_less;
    assign carry_ins[0] = first_cin;

    //get data when rst_n = 1
    always @(*) begin
        if(rst_n == 1)begin
            a = src1;
            b = src2;
        end
    end

    //set first_cin
    always @(*) begin
        if(rst_n == 1) begin
            case( ALU_control )
                OP_ADD: begin
                    first_cin = 1'b0;
                end
                OP_SUB: begin
                    first_cin = 1'b1;
                end
            endcase
        end
    end

    //set invert & operation
    always @(*) begin
        if(rst_n == 1)begin
            case (ALU_control)
                OP_ADD: begin
                    a_invert = 1'b0;
                    b_invert = 1'b0;
                    operation = 2'b10;
                end
                OP_SUB: begin
                    a_invert = 1'b0;
                    b_invert = 1'b1;
                    operation = 2'b10;
                end
            endcase
        end
    end

    //generate and connect all the alu_top modules
    generate
        genvar i;
        for( i=0; i<32; i=i+1 ) begin: alu_top_i
            //first module
            if( i == 0 ) begin
                alu_top one_bit_alu(
                    .src1(a[i]),
                    .src2(b[i]),
                    .less(set_less), // connect to the set_less of the last module
                    .A_invert(a_invert),
                    .B_invert(b_invert),
                    .cin(carry_ins[i]),
                    .operation(operation),
                    .result(result[i]),
                    .cout(carry_ins[i+1])
                    );
            end
            else if( i == 31 )begin //last module
                alu_top one_bit_alu(
                    .src1(a[i]),
                    .src2(b[i]),
                    .less(0),
                    .A_invert(a_invert),
                    .B_invert(b_invert),
                    .cin(carry_ins[i]),
                    .operation(operation),
                    .result(result[i]),
                    .cout(carry_ins[i+1]),
                    .set_less(set_less) //connect to the less of the first module
                    );
            end
            else begin
                alu_top one_bit_alu(
                    .src1(a[i]),
                    .src2(b[i]),
                    .less(0),
                    .A_invert(a_invert),
                    .B_invert(b_invert),
                    .cin(carry_ins[i]),
                    .operation(operation),
                    .result(result[i]),
                    .cout(carry_ins[i+1])
                    );
            end
        end
    endgenerate

endmodule
