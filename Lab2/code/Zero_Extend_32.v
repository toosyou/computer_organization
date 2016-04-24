//0316055_0316313
//Subject:     CO project 2 - Zero_Extend_32
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
     
module Zero_Extend_32(
    data_i,
    data_o
    );

parameter size = 0;
			
//I/O ports
input   [size-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;
integer i;

//Main function
always @(*) begin
	data_o[size-1:0] = data_i[size-1:0];
	for(i=size;i<32;i=i+1)begin
		data_o[i] = 0;
	end
end

endmodule      
          
          