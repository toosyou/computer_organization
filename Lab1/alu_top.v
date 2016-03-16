//0316055_0316313
`timescale 1ns/1ps

module alu_top(
    input           src1,       //1 bit source 1 (input)
    input           src2,       //1 bit source 2 (input)
    input           less,       //1 bit less     (input)
    input           equal,
    input           A_invert,   //1 bit A_invert (input)
    input           B_invert,   //1 bit B_invert (input)
    input           cin,        //1 bit carry in (input)
    input [1:0]     operation,  //operation      (input)
    input [2:0]     comp_sel,
    input           lsb,        //if it is LSB
    output reg      result,     //1 bit result   (output)
    output          cout,       //1 bit carry out(output)
    output          set_less,   //set less for the first alu_top
    output          set_equal
    );

    localparam [1:0] OP_AND = 2'b00, OP_OR = 2'b01, OP_ADD = 2'b10, OP_LESS = 2'b11;
    localparam [2:0] CMP_SLT=3'b000, CMP_SGT=3'b001, CMP_SLE=3'b010, CMP_SGE=3'b011, CMP_SEQ=3'b110, CMP_SNE=3'b100;
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
    assign set_equal = lsb? !add_result: (!add_result & equal);

    always @(*) begin
        case(operation)
            OP_AND:
                result = g;
            OP_OR:
                result = p;
            OP_ADD:
                result = add_result;
            OP_LESS: begin
                if (lsb) begin
                    case(comp_sel)
                        CMP_SLT:
                            result = less;
                        CMP_SGT:
                            result = !less && !equal;
                        CMP_SLE:
                            result = less || equal;
                        CMP_SGE:
                            result = !less;
                        CMP_SEQ:
                            result = equal;
                        CMP_SNE:
                            result = !equal;
                    endcase
                end
                else begin
                    result = 0;
                end
            end
                
        endcase
    end

endmodule
