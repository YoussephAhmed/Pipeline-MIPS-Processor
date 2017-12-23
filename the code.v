module regFile(rs_address,rt_address,dest_address,writeBack_data,reg_write,clk,rs_data,rt_data,reg_file_address,reg_file_data); // 6 i/p , 2 o/p

input [4:0] rs_address,rt_address,reg_file_address; //address '5 bits 
input [4:0] dest_address;
input[31:0] writeBack_data; // data to be saved '32 bits
input reg_write;
input clk;

output reg [31:0] rs_data,rt_data,reg_file_data; //output data from rs_address,rt_address '32 bits

reg [31:0] index[0:31]; // first is number of reg size , second is number of regs




always @(negedge clk)
begin
if(reg_write)
index[dest_address] <= writeBack_data;


rs_data <= index[rs_address];
rt_data <= index[rt_address];
end
integer i;
integer line=0;

always@(reg_file_address)
begin
reg_file_data<=index[reg_file_address];
end

initial
begin
for (i = 0 ; i < 32 ; i = i+1)

index[i] <= 0;
end
endmodule 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////reg_file end


module ForwardUnit(ID_EX_RS,ID_EX_RT,
                   EX_MEM_RD,MEM_WB_RD,
                   ForwardA,ForwardB,
                   MEM_RegWrite,
                   WB_RegWrite
                   );

input wire [4:0] ID_EX_RS,ID_EX_RT,EX_MEM_RD,MEM_WB_RD;
input wire MEM_RegWrite,WB_RegWrite;
output reg [1:0] ForwardA,ForwardB;

always @*
begin

if((MEM_RegWrite==1)&&
   (EX_MEM_RD!=0)&&
   (EX_MEM_RD == ID_EX_RS))
   ForwardA <= 10;

else
begin
ForwardA <= 0;
end

if((MEM_RegWrite == 1)&&
   (EX_MEM_RD != 0)&&
   (EX_MEM_RD == ID_EX_RT))
     ForwardB <= 10;

else
begin
ForwardB <= 0;
end

///////////////////////////////////////////////////////////////
 //MemForwardUnit

 if((WB_RegWrite == 1)&&
   (MEM_WB_RD != 0)&&
   (EX_MEM_RD!= ID_EX_RS)&&
   (MEM_WB_RD == ID_EX_RS))
 ForwardA <= 01;
else
begin
ForwardA <= 0;
end


 if((WB_RegWrite == 1)&&
   (MEM_WB_RD != 0)&&
   (EX_MEM_RD != ID_EX_RT)&&
   (MEM_WB_RD == ID_EX_RT))
 ForwardB <= 01;
else
begin
ForwardB <= 0;
end
end
endmodule
//////////////////////////////////////////////////////////////////forwading unit end


module testbench;

wire [31:0]pc_output,ALU_Result,Mem_out,Instr_32;

wire [31:0] reg_file_data;
reg [4:0] reg_file_address;

reg [31:0] read_address , write_address ;//address '32 bits 
reg [7:0] write_data;
reg We , clk;
wire [31:0] read_data;

reg [7:0] index[0:256];

always
#100 clk = ~ clk;


integer i,j,line;
integer file;
reg pc_enable=0;



initial
begin


clk=0;
We=1;
#5
We=0;
#900000
file=$fopen("show.txt");

for(line=16;line<24;line=line+1)

begin
#1
reg_file_address=line;
#5
$fdisplay(file,"%d",reg_file_data);

end



end
 processor MIPS(write_data,write_address,We,pc_output,ALU_Result,Mem_out,pc_enable,clk,reg_file_address,reg_file_data);//module processor(write_data,write_address,We,pc_output,ALU_Result,Mem_out,clk);
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////test_bench end


module dataMem(R1,D1,We,Re,clk,O1); // 5 i/p , 1 o/p

input [31:0] R1; //address '32 bits 
input[31:0] D1; // data to be saved '32 bits
input We,Re;
input clk;

output reg [31:0] O1; //output data from R1 '32 bits

reg [7:0] index[0:255]; // first is number of mem size , second is number of memvalues


always @*
begin

if(Re)
begin
O1 <= { index[R1] , index[R1+1], index[R1+2] ,index[R1+3] };
end


else if(We)
begin
index[R1]   <= D1[31:24];
index[R1+1] <= D1[23:16];
index[R1+2] <= D1[15:8];
index[R1+3] <= D1[7:0];
end

end

integer i;
initial
begin
for (i = 0 ; i < 256 ; i = i+1)
#5
index[i] = 0;
end


endmodule 

/////////////////////////////////////////////////////////////////////////////////////////////////data memory end



module processor(write_data,write_address,We,pc_output,ALU_Result,Mem_out,pc_enable,clk,reg_file_address,reg_file_data);


//i/ps o/ps 
input clk,We,pc_enable; 
input [31:0] write_address ;
input [7:0] write_data;



input [4:0] reg_file_address;//++++++++++++++
//Wire Declarations

//pc
wire [31:0] pc_input;        
output wire [31:0] pc_output,reg_file_data;//++++++++++++++++++++++++++++++++++++++++++++++++++++
wire [31:0] pc_plus_4;


//pipelined regs
wire [31:0] Instr_32,ID_Instr_32 ;
wire [5:0] opcode = ID_Instr_32[31:26];
wire [4:0] IP_ID_EX_RS = ID_Instr_32[25:21];
wire [4:0] IP_ID_EX_RT = ID_Instr_32[20:16] ;
wire [4:0] IP_ID_EX_RD = ID_Instr_32[15:11] ;
wire [4:0] ID_shamt = ID_Instr_32[10:6]; 
wire [5:0] funct=ID_Instr_32[5:0] ; 
wire [15:0] immediate_value = ID_Instr_32[15:0] ;
wire [25:0] jump_pseudo = ID_Instr_32[25:0];
wire [31:0] ID_pc;
wire [31:0] EX_pc;
wire [31:0] MEM_pc;
wire [31:0] WB_pc;
wire [31:0] EX_sign_extended;
wire [31:0] MEM_ALU_Result;
wire [31:0] MEM_branch_address;
wire [4:0] EX_shamt;
wire [3:0] ID_AluOp ,MEM_AluOp,WB_AluOp;  
wire [3:0] EX_ALU_Control;
wire [4:0] ID_EX_RS, ID_EX_RT, ID_EX_RD, EX_MEM_WB_address, MEM_WB_address; 
wire [31:0] ID_EX_Data1, ID_EX_Data2 , MEM_RTData, WB_ALU_Result , WB_Mem_out;
wire [31:0] forwardA_out , forwardB_out;

//forwarding 
wire [1:0] ForwardA;
wire [1:0] ForwardB;


//Control Unit
wire RegDest;
wire ALUSrc;
wire MemtoReg;
wire RegWrite; 
wire MemRead;
wire MemWrite;
wire jcond;
wire bcond;
wire [3:0] ALU_Control;



//Register
wire [31:0] read_data1;//rsData
wire [31:0] read_data2;//rtData
wire [4:0]  write_back_address;
wire [31:0] write_back_data;




//ALU
wire [31:0]sign_extended;
output wire [31:0] ALU_Result;///////*******************************************************
wire [31:0] ALU_2operand;
wire zeroflag;
wire overflow;


//MEM
output wire [31:0] Mem_out;//*******************************************
wire [31:0] next_address;
wire [31:0] branch_address;
wire [31:0] offset;


//jump
wire [1:0] two_zeros =  0;
wire [31:0]jump_address = { ID_pc [31:28] , jump_pseudo   , two_zeros };
wire  [31:0]actual_jump_address;
adder control_hazard (jump_address,20,actual_jump_address);



//IF -----------------------------------


pc pc1(clk,We,pc_enable,pc_input,pc_output); 
InstMem inst1(pc_output,write_address,write_data,We,clk, Instr_32);
adder adder1(pc_output,4, pc_plus_4);
mux_2x1_32 mux4(pc_plus_4,MEM_branch_address,takebranch,next_address);
mux_2x1_32 mux5(next_address,actual_jump_address,jcond,pc_input); 

IF_ID IF_ID1(.input_pc(pc_plus_4),.input_Inst(Instr_32),
             .output_pc(ID_pc),.output_Inst(ID_Instr_32),
             .clk(clk));


//ID --------------------------------------

control_unit cu1(opcode,funct,RegDest,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,ALU_Control,jcond,bcond);
regFile Reg1(IP_ID_EX_RS,IP_ID_EX_RT ,MEM_WB_address,write_back_data,WB_RegWrite,clk,read_data1,read_data2,reg_file_address,reg_file_data);//++++++++
signext signex1(immediate_value,sign_extended);

ID_EX ID_EX1  (.clk(clk),
               .input_pc(ID_pc),.output_pc(EX_pc),
               .input_RSData(read_data1),.output_RSData(ID_EX_Data1),
               .input_RTData(read_data2),.output_RTData(ID_EX_Data2),
               .input_RSAddress(IP_ID_EX_RS),.output_RSAddress(ID_EX_RS),
               .input_RTAddress(IP_ID_EX_RT),.output_RTAddress(ID_EX_RT),
               .input_RDAddress(IP_ID_EX_RD),.output_RDAddress(ID_EX_RD),
               .input_SignExtended(sign_extended),.output_SignExtended(EX_sign_extended),
               .input_sh_amount(ID_shamt),.output_sh_amount(EX_shamt),
               .input_RegDst(RegDest),.output_RegDst(EX_RegDst),
               .input_Jump(jcond),.output_Jump(EX_Jump),
               .input_Branch(bcond),.output_Branch(EX_Branch),
               .input_MemRead(MemRead),.output_MemRead(EX_MemRead),
               .input_MemToReg(MemtoReg),.output_MemToReg(EX_MemToReg),
               .input_AluOp(ALU_Control),.output_AluOp(EX_ALU_Control),
               .input_MemWrite(MemWrite),.output_MemWrite(EX_MemWrite),
               .input_AluSrc(ALUSrc),.output_AluSrc(EX_AluSrc),
               .input_RegWrite(RegWrite),.output_RegWrite(EX_RegWrite)
	       );

//EXE


mux_3x1_32  rs_forward(ID_EX_Data1,write_back_data,MEM_ALU_Result,ForwardA,forwardA_out);
mux_3x1_32  second_operand_forward(ID_EX_Data2,write_back_data,MEM_ALU_Result,ForwardB,forwardB_out);
mux_2x1_32 mux2(forwardB_out,EX_sign_extended,EX_AluSrc,ALU_2operand);
ALU alu1(forwardA_out,ALU_2operand,EX_ALU_Control,EX_shamt,zeroflag,overflow,ALU_Result);
adder adder2 (offset,EX_pc, branch_address);
sh_by2 shift1(EX_sign_extended,offset);
mux_2x1_5 mux1(ID_EX_RT , ID_EX_RD ,EX_RegDst,write_back_address);



EX_MEM EX_MEM1(.clk(clk),
               .input_readData2(ID_EX_Data2),.output_readData2(MEM_RTData),
               .input_zeroflag(zeroflag),.output_zeroflag(MEM_zeroflag),
               .input_pc(EX_pc),.output_pc(MEM_pc),
               .input_RDAddress(write_back_address),.output_RDAddress(EX_MEM_WB_address),
               .input_RegDst(EX_RegDst),.output_RegDst(MEM_RegDst),
               .input_Jump(EX_Jump),.output_Jump(MEM_Jump),
               .input_Branch(EX_Branch),.output_Branch(MEM_Branch),
               .input_MemRead(EX_MemRead),.output_MemRead(MEM_MemRead),
               .input_MemToReg(EX_MemToReg),.output_MemToReg(MEM_MemToReg),
               .input_AluOp(EX_ALU_Control),.output_AluOp(MEM_AluOp),
               .input_MemWrite(EX_MemWrite),.output_MemWrite(MEM_MemWrite),
               .input_AluSrc(EX_AluSrc),.output_AluSrc(MEM_AluSrc),
               .input_RegWrite(EX_RegWrite),.output_RegWrite(MEM_RegWrite),
               .input_Alu_Result(ALU_Result),.output_Alu_Result(MEM_ALU_Result),
               .input_BranchAddress(branch_address),.output_BranchAddress(MEM_branch_address)
	       );



//MEM
dataMem datamem1(MEM_ALU_Result,MEM_RTData,MEM_MemWrite,MEM_MemRead,clk,Mem_out);
and and1(eq_branch,MEM_zeroflag,WB_Branch);
and and2(neq_branch,!MEM_zeroflag,WB_Branch);
or or1(takebranch,eq_branch,neq_branch);



MEM_WB MEM_WB1 (.clk(clk),
               .input_pc(WB_pc),.output_pc(WB_pc),
               .input_RDAddress(EX_MEM_WB_address),.output_RDAddress(MEM_WB_address),
               .input_RegDst(MEM_RegDst),.output_RegDst(WB_RegDst),
               .input_Jump(MEM_Jump),.output_Jump(WB_Jump),
               .input_Branch(MEM_Branch),.output_Branch(WB_Branch),
               .input_MemRead(MEM_MemRead),.output_MemRead(WB_MemRead),
               .input_MemToReg(MEM_MemToReg),.output_MemToReg(WB_MemToReg),
               .input_AluOp(MEM_AluOp),.output_AluOp(WB_AluOp),
               .input_MemWrite(MEM_MemWrite),.output_MemWrite(WB_MemWrite),
               .input_AluSrc(MEM_AluSrc),.output_AluSrc(WB_AluSrc),
               .input_RegWrite(MEM_RegWrite),.output_RegWrite(WB_RegWrite),
               .input_Alu_Result(MEM_ALU_Result),.output_Alu_Result(WB_ALU_Result),
               .input_MemOut(Mem_out),.output_MemOut(WB_Mem_out)
               );


//WB
mux_2x1_32 mux3(WB_ALU_Result,WB_Mem_out,WB_MemToReg,write_back_data);





ForwardUnit FU    (.ID_EX_RS(ID_EX_RS),.ID_EX_RT(ID_EX_RT),
                   .EX_MEM_RD(EX_MEM_WB_address),.MEM_WB_RD(MEM_WB_address),
                   .ForwardA(ForwardA),.ForwardB(ForwardB),
                   .MEM_RegWrite(MEM_RegWrite),
                   .WB_RegWrite(WB_RegWrite)
                   );
endmodule
// <</////////////////// Processor ///////////////////////////


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
assign RegWrite  = (opcode == `Rf) || (opcode == `LW) || (opcode == `ADDI) || (opcode == `ANDI) ||(opcode == `SLTI)|| (opcode == `ORI)  ;
assign MemRead   = (opcode==`LW);
assign MemWrite  = (opcode==`SW);
assign jcond = (opcode ==`J);
assign bcond = (opcode == `BEQ) || (opcode == `BNE); 



always@ (*) begin
  casex({opcode,funct})
     {`Rf ,`ADD},{`ADDI,6'dx},
     {`LW  ,6'dx},
     {`SW  ,6'dx} : alu_ctrl = 4'd2;
    {6'd0 ,`AND},{`ANDI,6'dx} : alu_ctrl = 4'd0;
    {6'd0 ,`OR} ,{`ORI ,6'dx} : alu_ctrl = 4'd1;
    {6'd0 ,`SLL}              : alu_ctrl = 4'd3;
    {6'd0 ,`SLT},{`SLTI,6'dx} : alu_ctrl = 4'd7;
    {6'd0 ,`SRL}              : alu_ctrl = 4'd5;
    {6'd0 ,`SUB},{`BEQ ,6'dx}
     ,{`BNE ,6'dx}            : alu_ctrl = 4'd6;
    default                   : alu_ctrl = 4'd15;
  endcase
end

assign ALU_Control = alu_ctrl;

endmodule

///////////////////////////////////////////////////////////////////////////control unit end



module pc(clk,We,pc_enable,in_address,out_address);

input clk,We,pc_enable;
input[31:0]in_address;

output reg[31:0]out_address;

reg first_clock=1;

always @(negedge clk)
begin
if(first_clock)
begin
out_address <=0;
first_clock<=0;
end
else
out_address<= in_address;

end

always @(negedge We)
begin
out_address <=0;


end

endmodule


//////////////////////////////////////////////////////////////////////////////////////////////pc counter end



module InstMem(read_address,write_address,write_data,We,clk,read_data); // 5 i/p , 1 o/p
input [31:0] read_address , write_address ;//address '32 bits 

input [7:0] write_data;

input clk,We;
output reg [31:0] read_data; //output data from R1'32 bits
reg [7:0] index[0:255]; // first is number of mem size , second is number of memvalues

initial 
begin
$readmemb("output.txt" , index);
end


always @(posedge clk)
begin

//#1 ///4eeeel el delay daaaaaaaaaaaaaaaaaaa
read_data <= { index[read_address[7:0]],index[read_address[7:0]+1],index[read_address[7:0]+2],index[read_address[7:0]+3]};
$display("blaaaaaaaaaaaaaaa");

end
endmodule
////////////////////////////////////////////////////////////////////////intsruction mem end



module sh_by2(in,out);
input signed [31:0]in;
output reg[31:0]out;

always @*
begin
if(in>0)
out <= (in<<2)+16;
else
 out <= (in<<2)-4;
end
endmodule

// >>//////////////////// sign extend ////////////////////////
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

// >>//////////////////// adder //////////////////////////////end



module mux_2x1_5(ip0, ip1, sel, out);
input sel;
input [4:0] ip1;
input [4:0] ip0;
output reg [4:0] out;

always@(*) begin
  if (sel==1'b1) begin
   out <= ip1;
  end 
  else begin 
   out <= ip0;
  end
end

endmodule


/////////////////////////////////////////////////////////////////
module mux_2x1_32(ip0, ip1, sel, out);
input sel;
input [31:0] ip1;
input [31:0] ip0;
output reg [31:0] out;

always@(*) begin
  if (sel==1'b1) begin
   out <= ip1;
  end 
  else begin 
   out <= ip0;
  end
end

endmodule



module mux_3x1_32(ip0,ip1,ip2,sel,out);

input [1:0]  sel;
input [31:0] ip1;
input [31:0] ip0;
input [31:0] ip2;
output reg [31:0] out;

always@(*) 
begin
	if(sel==2'b0)
	 out <= ip0;
  else if (sel==2'b1) begin
   out <= ip1;
  end 
  else if (sel==2'b10)begin 
   out <= ip2;
  end
end

endmodule 


//////////////////////////////////////////////////////////////////mux end

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////alu end

module IF_ID(clk,
             input_pc,output_pc,
             input_Inst,output_Inst
             );
input wire [31:0] input_pc,input_Inst;
input clk;
output reg [31:0] output_pc,output_Inst;
always @(posedge clk)
begin
output_pc <= input_pc;
output_Inst <= input_Inst;
end  
endmodule

module  ID_EX (clk,
               input_pc,output_pc,
               input_RSData,output_RSData,
               input_RTData,output_RTData,
               input_RSAddress,output_RSAddress,
               input_RTAddress,output_RTAddress,
               input_RDAddress,output_RDAddress,
               input_SignExtended,output_SignExtended,
	       input_sh_amount,output_sh_amount,
               input_RegDst,output_RegDst,
               input_Jump,output_Jump,
               input_Branch,output_Branch,
               input_MemRead,output_MemRead,
               input_MemToReg,output_MemToReg,
               input_AluOp,output_AluOp,
               input_MemWrite,output_MemWrite,
               input_AluSrc,output_AluSrc,
               input_RegWrite,output_RegWrite
	       );
input clk;
input wire [31:0] input_pc,input_RSData,input_RTData,input_SignExtended;
output reg [31:0] output_pc,output_RSData,output_RTData,output_SignExtended;

input wire [4:0] input_RDAddress,input_RTAddress,input_RSAddress,input_sh_amount;
output reg [4:0] output_RDAddress,output_RTAddress,output_RSAddress,output_sh_amount;

input wire [3:0] input_AluOp;
output reg [3:0] output_AluOp;

input wire input_RegDst,input_Jump,input_Branch,input_MemRead,input_MemToReg
          ,input_MemWrite,input_AluSrc,input_RegWrite;

output reg output_RegDst,output_Jump,output_Branch,output_MemRead,output_MemToReg,
            output_MemWrite,output_AluSrc,output_RegWrite;
always @(posedge clk)
begin
output_pc <= input_pc;
output_RSData <= input_RSData;
output_RTData <= input_RTData;
output_RSAddress<=input_RSAddress;
output_RTAddress<=input_RTAddress;
output_RDAddress <= input_RDAddress;
#1
output_SignExtended <= input_SignExtended;
output_sh_amount<=input_sh_amount;
output_RegDst<=input_RegDst;
output_Jump<=input_Jump;
output_Branch<=input_Branch;
output_MemRead<=input_MemRead;
output_MemToReg<=input_MemToReg;
output_MemWrite<=input_MemWrite;
output_AluSrc<=input_AluSrc;
output_RegWrite<=input_RegWrite;
output_AluOp<=input_AluOp;
end  
endmodule


module  EX_MEM (clk,
               input_zeroflag,output_zeroflag,
	       input_readData2,output_readData2,
               input_pc,output_pc,
               input_RDAddress,output_RDAddress,
               input_RegDst,output_RegDst,
               input_Jump,output_Jump,
               input_Branch,output_Branch,
               input_MemRead,output_MemRead,
               input_MemToReg,output_MemToReg,
               input_AluOp,output_AluOp,
               input_MemWrite,output_MemWrite,
               input_AluSrc,output_AluSrc,
               input_RegWrite,output_RegWrite,
               input_Alu_Result,output_Alu_Result,
               input_BranchAddress,output_BranchAddress
	       );
input clk;

input input_zeroflag;
output reg output_zeroflag;

input [31:0] input_readData2;
output reg [31:0] output_readData2;

input wire [31:0] input_pc,input_Alu_Result,input_BranchAddress;
output reg [31:0] output_pc,output_Alu_Result,output_BranchAddress;

input wire [4:0] input_RDAddress;
output reg [4:0] output_RDAddress;

input wire [3:0] input_AluOp;
output reg [3:0] output_AluOp;

input wire input_RegDst,input_Jump,input_Branch,input_MemRead,input_MemToReg
          ,input_MemWrite,input_AluSrc,input_RegWrite;
output reg output_RegDst,output_Jump,output_Branch,output_MemRead,output_MemToReg,
            output_MemWrite,output_AluSrc,output_RegWrite;
always @(posedge clk)
begin
output_pc <= input_pc;
output_RDAddress<=input_RDAddress;
output_RegDst<=input_RegDst;
output_Jump<=input_Jump;
output_Branch<=input_Branch;
output_MemRead<=input_MemRead;
output_MemToReg<=input_MemToReg;
output_MemWrite<=input_MemWrite;
output_AluSrc<=input_AluSrc;
output_RegWrite<=input_RegWrite;
output_AluOp<=input_AluOp;
output_Alu_Result <= input_Alu_Result;
output_BranchAddress<=input_BranchAddress;
output_zeroflag  <= input_zeroflag;
output_readData2 <= input_readData2;
end  
endmodule

module MEM_WB (clk,
	       input_pc,output_pc,
               input_RDAddress,output_RDAddress,
               input_RegDst,output_RegDst,
               input_Jump,output_Jump,
               input_Branch,output_Branch,
               input_MemRead,output_MemRead,
               input_MemToReg,output_MemToReg,
               input_AluOp,output_AluOp,
               input_MemWrite,output_MemWrite,
               input_AluSrc,output_AluSrc,
               input_RegWrite,output_RegWrite,
               input_Alu_Result,output_Alu_Result,
               input_MemOut,output_MemOut
               );
input clk;
input [31:0] input_pc;
output reg[31:0] output_pc;
input wire [31:0] input_Alu_Result, input_MemOut;
output reg [31:0] output_Alu_Result,output_MemOut;

input wire [4:0] input_RDAddress;
output reg [4:0] output_RDAddress;

input wire [3:0] input_AluOp;
output reg [3:0] output_AluOp;

input wire input_RegDst,input_Jump,input_Branch,input_MemRead,input_MemToReg
          ,input_MemWrite,input_AluSrc,input_RegWrite;
output reg output_RegDst,output_Jump,output_Branch,output_MemRead,output_MemToReg,
            output_MemWrite,output_AluSrc,output_RegWrite;


always @(posedge clk)
begin
output_pc <=  input_pc;
output_RDAddress <= input_RDAddress;
output_RegDst<=input_RegDst;
output_Jump<=input_Jump;
output_Branch<=input_Branch;
output_MemRead<=input_MemRead;
output_MemToReg<=input_MemToReg;
output_MemWrite<=input_MemWrite;
output_AluSrc<=input_AluSrc;
output_RegWrite<=input_RegWrite;
output_AluOp<=input_AluOp;
output_Alu_Result <= input_Alu_Result;
output_MemOut<=input_MemOut;
end  
endmodule












