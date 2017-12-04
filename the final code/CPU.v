
module processor(write_data,write_address,We,pc_output,ALU_Result,Mem_out,pc_enable,clk);


//i/ps o/ps 
input clk,We,pc_enable; 
input [31:0] write_address ;
input [7:0] write_data;




//Wire Declarations

//pc
wire [31:0] pc_input;        
output wire [31:0] pc_output;
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




//IF ------------------------------------


pc pc1(clk,We,pc_enable,pc_input,pc_output); 
InstMem inst1(pc_output,write_address,write_data,We,clk, Instr_32);
adder adder1(pc_output,4, pc_plus_4);
mux_2x1_32 mux4(pc_plus_4,MEM_branch_address,takebranch,next_address);
mux_2x1_32 mux5(next_address,jump_address,jcond,pc_input); 

IF_ID IF_ID1(.input_pc(pc_plus_4),.input_Inst(Instr_32),
             .output_pc(ID_pc),.output_Inst(ID_Instr_32),
             .clk(clk));


//ID --------------------------------------

control_unit cu1(opcode,funct,RegDest,ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,ALU_Control,jcond,bcond);
regFile Reg1(IP_ID_EX_RS,IP_ID_EX_RT ,MEM_WB_address,write_back_data,RegWrite,clk,read_data1,read_data2);
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

mux_3x1_32  rs_forward(ID_EX_Data1,MEM_ALU_Result,write_back_data,ForwardA,forwardA_out);
mux_3x1_32  second_operand_forward(ID_EX_Data2,MEM_ALU_Result,write_back_data,ForwardB,forwardB_out);
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





ForwardUnit FU    (.ID_EX_RS(ID_EX_RS),.ID_EX_RT(ID_EX_RS),
                   .EX_MEM_RD(EX_MEM_WB_address),.MEM_WB_RD(MEM_WB_address),
                   .ForwardA(ForwardA),.ForwardB(ForwardB),
                   .MEM_RegWrite(MEM_RegWrite),
                   .WB_RegWrite(WB_RegWrite)
                   );
endmodule
// <</////////////////// Processor ///////////////////////////


