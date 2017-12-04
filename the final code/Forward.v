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

if((MEM_RegWrite == 1)&&
   (EX_MEM_RD != 0)&&
   (EX_MEM_RD == ID_EX_RT))
     ForwardB <= 10;

///////////////////////////////////////////////////////////////
 //MemForwardUnit

if((WB_RegWrite == 1)&&
   (MEM_WB_RD != 0)&&
   (EX_MEM_RD!= ID_EX_RS)&&
   (MEM_WB_RD == ID_EX_RS))
 ForwardA <= 01;

if((WB_RegWrite == 1)&&
   (MEM_WB_RD != 0)&&
   (EX_MEM_RD != ID_EX_RT)&&
   (MEM_WB_RD == ID_EX_RT))
 ForwardB <= 01;

end
endmodule

