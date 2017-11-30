// >>/////////////////////////// Mem and Reg /////////////////////////////
//Reg file
module regFile(R1,R2,W1,D1,We,clk,O1,O2); // 6 i/p , 2 o/p

input [4:0] R1,R2; //address '5 bits 
input [4:0] W1;
input[31:0] D1; // data to be saved '32 bits
input We;
input clk;

output [31:0] O1,O2; //output data from R1,R2 '32 bits

reg [31:0] index[0:31]; // first is number of reg size , second is number of regs

assign O1 = index[R1];
assign O2 = index[R2];


always @(posedge clk)
begin
if(We)
index[W1] <= D1;
end

endmodule 


module testRegFile; //inputs are reg - 2 i/p , 6 o/p

 reg [4:0] R1,R2; //address '5 bits 
 reg [4:0] W1;

 reg[31:0] D1; // data to be saved '32 bits
 reg We;
 reg clk;

 wire [31:0] in1,in2; //output data from R1,R2 '32 bits

integer i;

always
begin
#1 clk = ~ clk;  
end



initial
begin

clk = 0;
We =1;


$monitor($time, "  R1:%d , R2: %d ,W1 = %d , D1=%d , We=%d, clk=%d, out1=%d, out2=%d ",R1,R2,W1,D1,We,clk,in1,in2);


//to init the data in reg every address have a value of his address 
for(i = 0 ; i < 32 ; i = i+1)
begin
D1 <= i;
W1 <= i;
#2;
end

We = 0;
//to view the stored data
for (i = 0 ; i < 32 ; i = i+1)
begin
R1 <= i;
R2 <= i;
#1;
end

end

regFile Reg1(R1,R2,W1,D1,We,clk,in1,in2);
endmodule 

////////////////////////////////////////////

//DataMemory
module dataMem(R1,D1,We,Re,clk,O1); // 5 i/p , 1 o/p

input [31:0] R1; //address '32 bits 
input[31:0] D1; // data to be saved '32 bits
input We,Re;
input clk;

output reg [31:0] O1; //output data from R1 '32 bits

reg [7:0] index[0:2**32 -1]; // first is number of mem size , second is number of memvalues


always @(posedge clk)
begin

if(Re)
begin
O1 <= { index[R1] , index[R1+1], index[R1+2] ,index[R1+3] };
end


if(We)
begin
index[R1] <= D1[31:24];
index[R1+1] <= D1[23:16];
index[R1+2] <= D1[15:8];
index[R1+3] <= D1[7:0];
end

end

endmodule 

module testDataMem; //inputs are reg - 2 i/p , 7 o/p

 reg [31:0] R1; //address '32 bits 
 
 reg[31:0] D1; // data to be saved '32 bits
 reg We,Re;
 reg clk;

 wire [31:0] in1; //output data from R1,R2 '32 bits


always
begin
#1 clk = ~ clk;  
end



initial
begin

$monitor($time, "  R1:%d , D1=%d , We=%d, Re=%d, clk=%d, out1=%d",R1,D1,We,Re,clk,in1);


#1
clk = 0;
We =1;
D1  = 7;
R1 = 4; 

#4
R1 = 4;
Re = 1;

#4
Re = 0;


end

dataMem Mem1(R1,D1,We,Re,clk,in1,in2);
endmodule 

////////////////////////////////////////////

//InstMemory
module InstMem(R1,W1,D1,We,clk,O1); // 4 i/p , 1 o/p

input [31:0] R1 , W1 ;//address '32 bits 
input [31:0] D1;
input clk,We;

output reg [31:0] O1; //output data from R1'32 bits

reg [7:0] index[0:2**32 -1]; // first is number of mem size , second is number of memvalues


always @(posedge clk)
begin
O1 <= { index[R1] , index[R1+1], index[R1+2] ,index[R1+3] };

if(We)
begin
index[W1] <= D1[31:24];
index[W1+1] <= D1[23:16];
index[W1+2] <= D1[15:8];
index[W1+3] <= D1[7:0];
end

end
endmodule 
// <<///////////////////////// Mem and Reg /////////////////////////////


// >>/////////////////////////// ALU /////////////////////////////

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

			result = 
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
			zero=1;
		
		else
			zero=0;

//overflow

			overflow =
			 (control_signals == 4'b0010 && data1[31] == data2[31] && result[31] ==~data1[31])? 1'b1 //+ 
			:(control_signals == 4'b0110 && data1[31] == data2_negated[31] &&result[31] == ~data1[31])? 1'b1  //-
			: 1'b0;  
		
	end
  
endmodule

module testALU;
        reg [31:0]data1,data2;
	reg [3:0] control_signals; 
	wire zero,overflow;
	wire [31:0] result;


initial
begin
$monitor($time, "  R1=%d , R2=%d,control=%d, Result=%d, zeroFlag=%d, overflow=%d",
               data1,data2,control_signals,result,zero,overflow);

#1 data1 = 1; data2 = 3; control_signals = 0; // and
#2 data1 = 1; data2 = 3; control_signals = 1; // or
#3 data1 = 5; data2 = 2; control_signals = 2; // add
#4 data1 = 3; data2 = 2; control_signals = 2; // add
#5 data1 = 3; data2 = 2; control_signals = 6; // sub
#6 data1 = 2147483645; data2 = 9; control_signals = 2; // add


end

ALU alu1(data1,data2,control_signals,zero,overflow,result);
endmodule



// <</////////////////////////// ALU /////////////////////////////

// >>////////////////////////// MUX 2*1 //////////////////////////
module mux_2x1 #(parameter DATA_WIDTH = 32) (ip0, ip1, sel, out);

input [DATA_WIDTH-1:0] ip1;
input [DATA_WIDTH-1:0] ip0;
input sel;
output reg [DATA_WIDTH-1:0] out;

always@(*) begin
  if (sel==1'b1) begin
   out = ip1;
  end 
  else begin 
   out = ip0;
  end
end

endmodule
// <<////////////////////////// MUX 2*1 //////////////////////////



// >>///////////////////////// PC //////////////////////////////

module pc(clk,rst,en,in_address,out_address);

input clk,en,rst;
input[31:0]in_address;

output reg[31:0]out_address;

always @(posedge clk or posedge rst)
begin
if(rst)
out_address =0;
else if (en)
out_address = in_address + 4;
end  

endmodule

// <<///////////////////////// PC //////////////////////////////

// >>//////////////////////// Control Unit ////////////////////

module control_unit(opcode,funct,RegDest,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,ALU_Control,jcond,bcond);
input [5:0] opcode;       //Instr[31:26]
input [5:0] funct;        //Defines operation when Instructyion in R type
output bcond;              //1 when opcode is BEQ and BNE
output jcond;             //1 when jump
output RegDest;           //Write Destination register location
                          //RegDest = 1 -> R-type - Instr[15:11]
                          //RegDest = 0 -> I-type - Instr[21:16]
output ALUSrc;      
output [3:0] ALU_Control; //Defines the ALU operation 
output MemtoReg;          //Steer ALU(0)/Load memory(1) output to GPR write port
output RegWrite;          //GPR wite Disabled(0)/Enabled(1)
output MemRead;           //Read from Data memory(LW/LB=1)
output MemWrite;          //Write to Data memory(SW/SB=1)

`define ADD  6'b100000
`define AND  6'b100100 
`define Rf   6'b000000
`define OR   6'b100101 
`define SLL  6'b000000
`define SLT  6'b101010
`define SRL  6'b000010
`define SUB  6'b100010
`define ADDI 6'b001000
`define ANDI 6'b001100
`define BEQ  6'b000100
`define BNE  6'b000101
`define LW   6'b100011
`define SW   6'b101011
`define SLTI 6'b001010 
`define ORI  6'b001101
`define J    6'b000010

reg [3:0] alu_ctrl;


assign RegDest   = (opcode==6'b0);
assign ALUSrc    = (opcode!=6'b0) && (opcode!=`BEQ) && (opcode!=`BNE);
assign MemtoReg  = (opcode==`LW);
assign RegWrite  = (opcode == `Rf);
assign MemRead   = (opcode==`LW);
assign MemWrite  = (opcode==`SW);
assign jcond = (opcode ==`J);
assign bcond = (opcode == `BEQ) || (opcode == `BNE); 



always@ (*) begin
  casex({opcode,funct})
    {6'd0 ,`ADD},{`ADDI,6'dx},
     {`LW  ,6'dx},
     {`SW  ,6'dx} : alu_ctrl = 4'd0;
    {6'd0 ,`AND},{`ANDI,6'dx} : alu_ctrl = 4'd1;
    {6'd0 ,`OR} ,{`ORI ,6'dx} : alu_ctrl = 4'd2;
    {6'd0 ,`SLL}              : alu_ctrl = 4'd3;
    {6'd0 ,`SLT},{`SLTI,6'dx} : alu_ctrl = 4'd4;
    {6'd0 ,`SRL}              : alu_ctrl = 4'd5;
    {6'd0 ,`SUB},{`BEQ ,6'dx}
     ,{`BNE ,6'dx}            : alu_ctrl = 4'd6;
    default                   : alu_ctrl = 4'd15;
  endcase
end

assign ALU_Control = alu_ctrl;

endmodule


module testControlUnit;
   reg [5:0]opcode,funct;
   wire bcond,jcond,RegDest,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite;  
   wire [3:0] ALU_Control;                            
        


initial
begin
$monitor($time,"opcode=%d,funct=%d,bcond=%d,jcond=%d,RegDest=%d,ALUSrc=%d,ALU_Control=%d,MemtoReg=%d,RegWrite=%d,MemRead=%d,MemWrite=%d",
opcode,funct,bcond,jcond,RegDest,ALUSrc,ALU_Control,MemtoReg,RegWrite,MemRead,MemWrite);
           

#1 opcode = 0 ; funct = 32; // and
#2 opcode = 'b 101011 ; // SW
#3 opcode = 'b  100011 ; // LW 

end

control_unit cu1(opcode,funct,RegDest,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,ALU_Control,jcond,bcond);

endmodule

// <</////////////////////// Control Unit /////////////////////

// >>////////////////////// Sh by 2 ///////////////////////////
module sh_by2(in,out);
input[31:0]in;
output[31:0]out;
assign out = in << 2;
endmodule
// <<////////////////////// Sh by 2 ///////////////////////////

// <<//////////////////// sign extend ////////////////////////

module signext(ip, op);

input [15:0] ip;
output [31:0] op;
reg [31:0] ext;

always @(*) begin
 ext [15:0]  = ip;
 ext [31:16] = {16{ip[15]}};
end

assign op = ext;
endmodule
// >>//////////////////// sign extend ////////////////////////



// >>//////////////////// adder //////////////////////////////
module adder (ip1, ip2, out);

//input clk, rst;
input [31:0] ip1, ip2;
output [31:0] out;

reg [31:0] add;

always @(ip1 or ip2) begin
 add <= ip1 + ip2;
end
assign out = add;

endmodule
// <<//////////////////// adder //////////////////////////////




// >>/////////////////// Processor /////////////////////////// 

module processor(clk,rst,en);

input clk,rst,en; 

//Wire Declarations

//PC
wire [31:0] pc_input;        
wire [31:0] pc_output;
wire [31:0] pc_plus_4;
pc pc1(clk,rst,en,pc_input,pc_output);        


//Instruction Mem

wire [31:0] Instr_32;
//InstMem inst1(pc_output,W1,D1,We,clk, Instr_32bit);

wire [25:0] Inst_25_0 = Instr_32[25-0];
wire [4:0] Inst_25_21 =Instr_32[25-21] ;
wire [4:0] Inst_20_16 = Instr_32[20-16] ;
wire [4:0] Inst_15_11 = Instr_32[15-11] ;
wire [15:0] Inst_15_0 = Instr_32[15-0] ;
wire [4:0] shamt = Instr_32[4-0] ; 


//Control Unit
wire [5:0] opcode;
wire [5:0] funct;
wire RegDest;
wire ALUSrc;
wire MemtoReg;
wire RegWrite; 
wire MemRead;
wire MemWrite;
wire jcond;
wire bcond;
wire [3:0] ALU_Control;
control_unit cu1(opcode,funct,RegDest,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,ALU_Control,jcond,bcond);


//Register
wire [31:0] read_data1;
wire [31:0] read_data2;
wire [4:0]  write_back_address;
wire [31:0] write_back_data;
mux_2x1 mux1(Inst_20_16 , Inst_15_11 ,RegDest,write_back_address);
regFile Reg1(Inst_25_21,Inst_20_16 ,write_back_address,write_back_data,RegWrite,clk,read_data1,read_data2);



//ALU
wire [31:0]sign_extended;
wire [31:0] ALU_Result;
wire zeroflag;
wire overflow;

signext signex1(Inst_15_11,sign_extended);
mux_2x1 mux2(read_data2,sign_extend,ALUSrc,ALU_2operand);
ALU alu1(read_data1,ALU_2operand,ALU_Control,zero,overflow,ALU_Result);


//MEM
wire [31:0] Mem_out;
wire [31:0] Inst_15_0_signext; 
dataMem datamem1(ALU_Result,read_data2,MemWrite,MemRead,clk,Mem_out);

// .. TO BE CONTINOUED

endmodule


// <</////////////////// Processor ///////////////////////////
