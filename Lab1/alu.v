//0316055
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
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
		 //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


  input           rst_n;
  input  [32-1:0] src1;
  input  [32-1:0] src2;
  input   [4-1:0] ALU_control;
  //input   [3-1:0] bonus_control; 

  output [32-1:0] result;
  output          zero;
  output          cout;
  output          overflow;

  reg    [32-1:0] result;
  reg             zero;
  reg             cout;
  reg             overflow;

  localparam [3:0] OP_AND=4'b0000, OP_OR=4'b0001, OP_ADD=4'b0010, OP_SUB=4'b0110, OP_NOR=4'b1100, OP_NAND=4'b1101, OP_SLT=4'b0111;
  reg a, b;
  reg less;
  reg a_invert, b_invert;
  reg 1b_cin;
  reg [1:0] operation;
  reg 1b_result, 1b_cout;
  integer idx;

  alu_top 1_bit_alu(
    .src1(a),
    .src2(b),
    .less(less),
    .A_invert(a_invert),
    .B_invert(b_invert),
    .cin(1b_cin),
    .operation(operation),
    .result(1b_result),
    .cout(1b_cout)
  );

  always @(posedge clk or posedge rst) begin
    if (rst) begin
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
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      case (ALU_control)
        OP_ADD: begin
          for (idx=0; idx<32; idx=idx+1) begin
            if (idx==0) begin
              1b_cin = 1'b0;
            end
            else begin
              1b_cin = 1b_cout;
            end
          end
        end
        OP_SUB: begin
          for (idx=0; idx<32; idx=idx+1) begin
            if (idx==0) begin
              1b_cin = 1'b1;
            end
            else begin
              1b_cin = 1b_cout;
            end
          end
        end
    end
  end

endmodule
