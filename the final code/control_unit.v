
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
assign RegWrite  = (opcode == `Rf) || (opcode == `LW);
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


