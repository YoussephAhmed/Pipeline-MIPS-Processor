module ALU (data1,data2,control_signals,sh_am,zero,overflow,result);
	input [31:0]data1,data2;
        input [4:0] sh_am;
	input [3:0] control_signals; 
	output reg zero,overflow;
	output reg [31:0] result;

	wire [31:0] data2_negated;
	assign data2_negated = -data2;
	

	always@ (*)
	begin
//applying control signals

			result <= 
				 (control_signals == 4'b 0000) ? (data1 & data2) 
				:(control_signals == 4'b 0001) ? (data1 | data2)
				:(control_signals == 4'b 0010) ? (data1 + data2)
				:(control_signals == 4'b 0110) ? (data1 - data2)
				:(control_signals == 4'b 0111) ? ((data1 < data2)? 32'b0001 : 32'b0000)
                                :(control_signals == 4'b 0011) ?  (data1 << sh_am)
                                :(control_signals == 4'b 0101) ?  (data2 >> sh_am)
				:(control_signals == 4'b 1100) ? ~(data1 | data2)				
				: 32'bxxxx ;
		

	end
 
	always@ (result)
	begin
//setting zero flag
		if(result==0)
			zero<=1;
		
		else
			zero<=0;

//overflow

			 overflow <=
			 (control_signals == 4'b0010 && data1[31] == data2[31] && result[31] ==~data1[31])? 1'b1 //+ 
			:(control_signals == 4'b0110 && data1[31] == data2_negated[31] &&result[31] == ~data1[31])? 1'b1  //-
			: 1'b0;  
		
	end
  
endmodule




//--------------------------------------------------------------//ALU testbench

module testALU;
        reg [31:0]data1,data2;
	reg [3:0] control_signals; 
	wire zero,overflow;
	wire [31:0] result;
        reg [4:0]sh_am;


initial
begin
$monitor($time, "  R1=%d , R2=%d,control=%d, Result=%d, zeroFlag=%d, overflow=%d",
               data1,data2,control_signals,result,zero,overflow);

#1 data1 = 1; data2 = 3; control_signals = 0; // and
#2 data1 = 1; data2 = 3; control_signals = 1; // or
#3 data1 = 5; data2 = 2; control_signals = 2; // add
#4 data1 = 3; data2 = -1; control_signals = 2; // add
#5 data1 = 3; data2 = 2; control_signals = 6; // sub
#6 data1 = 2147483645; data2 = 9; control_signals = 2; // add


end

ALU alu1(data1,data2,control_signals,sh_am,zero,overflow,result);//module ALU (data1,data2,control_signals,sh_am,zero,overflow,result);
endmodule
