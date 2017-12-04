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

/*
module ForwardUnit();

if((EX_MEM.RegWrite)&&(EX_MEM.RD != 0)&&(EX_MEM.RD == ID_EX.RS))
ForwardA = 10;

if((EX_MEM.RegWrite)&&(EX_MEM.RD != 0)&&(EX_MEM.RD == ID_EX.RT))
ForwardB = 10;

endmodule

module MemForwardUnit();

if((MEM_WB.RegWrite)&&
   (MEM_WB.RD != 0)&&
   (EX_MEM.RD!= ID_EX.RS)&&
   (MEM_WB.RD == ID_EX.RS))
ForwardA = 01;

if((MEM_WB.RegWrite)&&
   (MEM_WB.RD != 0)&&
   (EX_MEM.RD!= ID_EX.RT)&&
   (MEM_WB.RD == ID_EX.RT))
ForwardB = 01;


endmodule
*/
