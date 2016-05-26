//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
        clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
	wire [31:0] IF_pc_mux_out;
	wire [31:0] IF_pc_out;
	wire [31:0] IF_pc_add4;
	wire [31:0] IF_instruction;

/**** ID stage ****/

//control signal


/**** EX stage ****/

//control signal


/**** MEM stage ****/
	wire MEM_PCSrc;
	wire [31:0] MEM_ALU_result;

//control signal


/**** WB stage ****/

//control signal


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) PC_MUX(
		.data0_i(IF_pc_add4),
		.data1_i(MEM_ALU_result),
		.select_i(MEM_PCSrc),
		.data_o(IF_pc_mux_out)
		);

ProgramCounter PC(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.pc_in_i(IF_pc_mux_out),
		.pc_out_o(IF_pc_out)
        );

Instr_Memory IM(
		.addr_i(IF_pc_out),
		.instr_o(IF_instruction)
	    );
			
Adder Add_pc(
		.src1_i(IF_pc_out),
		.src2_i(32'd4),
		.sum_o(IF_pc_add4)
		);

		
Pipe_Reg #(.size(32*2)) IF_ID(//top to down
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i({IF_pc_add4,IF_instruction}),
		.data_o()
		);
		
//Instantiate the components in ID stage
Reg_File RF(

		);

Decoder Control(

		);

Sign_Extend Sign_Extend(

		);	

Pipe_Reg #(.size(N)) ID_EX(

		);
		
//Instantiate the components in EX stage	   
ALU ALU(

		);
		
ALU_Control ALU_Control(

		);

MUX_2to1 #(.size(32)) Mux1(

        );
		
MUX_2to1 #(.size(5)) Mux2(

        );

Pipe_Reg #(.size(N)) EX_MEM(

		);
			   
//Instantiate the components in MEM stage
Data_Memory DM(

	    );

Pipe_Reg #(.size(N)) MEM_WB(
        
		);

//Instantiate the components in WB stage
MUX_3to1 #(.size(32)) Mux3(

        );

/****************************************
signal assignment
****************************************/	
endmodule

