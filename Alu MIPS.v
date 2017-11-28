
module ALU (reg_data1,reg_data2,immidiate_value,ALUsrc,control_signals,zero,overflow,result);
	input [31:0]reg_data1,reg_data2,immidiate_value;
	input ALUsrc;// 1 to operate on immediate value;
	input [3:0] control_signals; 
	output reg zero,overflow;
	output reg [31:0] result;

	wire [31:0] reg_data2_negated;
	assign reg_data2_negated = -reg_data2;
	
	wire [31:0] immidiate_value_negated;
	assign immidiate_value_negated = -immidiate_value;
	

/*
//operations
0000-->and
0001-->or
0010-->add
0110-->sub
0111-->slt   //set (the least significant bit =1) on less than
1100-->nor
*/
	

	always@ (ALUsrc or control_signals)
	begin
//applying control signals on non immediate value

		if(ALUsrc==0)
		begin
			result = 
				 (control_signals == 4'b 0000) ? (reg_data1 & reg_data2) 
				:(control_signals == 4'b 0001) ? (reg_data1 | reg_data2)
				:(control_signals == 4'b 0010) ? (reg_data1 + reg_data2)
				:(control_signals == 4'b 0110) ? (reg_data1 - reg_data2)
				:(control_signals == 4'b 0111) ? ((reg_data1 < reg_data2)? 32'b0001 : 32'b0000)
				:(control_signals == 4'b 1100) ? ~(reg_data1 | reg_data2)				
				: 32'b0000 ;
		end

//applying control signals on immediate value
		else if (ALUsrc==1)
		begin
			result = 
				 (control_signals == 4'b 0000) ? (reg_data1 & immidiate_value) 
				:(control_signals == 4'b 0001) ? (reg_data1 | immidiate_value)
				:(control_signals == 4'b 0010) ? (reg_data1 + immidiate_value)
				:(control_signals == 4'b 0110) ? (reg_data1 - immidiate_value)
				:(control_signals == 4'b 0111) ? ((reg_data1 < immidiate_value)? 32'b0001 : 32'b0000)
				:(control_signals == 4'b 1100) ? ~(reg_data1 | immidiate_value)				
				: 32'b0000 ;
		end
	end
 
	always@ (result)
	begin
//setting zero flag
		if(result==0)
		begin
			zero=1;
		end
//overflow
		if(ALUsrc==0)
		begin
			overflow =
			 (control_signals == 4'b0010 && reg_data1[31] == reg_data2[31] && result[31] ==~reg_data1[31])? 1'b1 //+ 
			:(control_signals == 4'b0110 && reg_data1[31] == reg_data2_negated[31] &&result[31] == ~reg_data1[31])? 1'b1  //-
			: 1'b0;  
		end
		else if (ALUsrc==1)
		begin
			overflow =
			  (control_signals == 4'b0010 && reg_data1[31] == immidiate_value[31] && result[31] ==~reg_data1[31])? 1'b1 //+  
			: (control_signals == 4'b0110 && reg_data1[31] == immidiate_value_negated[31] &&result[31] == ~reg_data1[31])? 1'b1  //-
			: 1'b0; 

		end
	end
  
endmodule