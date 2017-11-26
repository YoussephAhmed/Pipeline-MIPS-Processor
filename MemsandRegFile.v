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
module dataMem(R1,R2,W1,D1,We,Re,clk,O1,O2); // 7 i/p , 2 o/p

input [31:0] R1,R2; //address '32 bits 
input [31:0] W1;
input[31:0] D1; // data to be saved '32 bits
input We,Re;
input clk;

output reg [31:0] O1,O2; //output data from R1,R2 '32 bits

reg [7:0] index[0:(2^32)-1]; // first is number of mem size , second is number of memvalues


always @(posedge clk)
begin

if(Re)
begin
O1 <= { index[R1] , index[R1+1], index[R1+2] ,index[R1+3] };
O2 <= { index[R2] , index[R2+1], index[R2+2] ,index[R2+3] };
end


if(We)
begin
index[W1] <= D1[31:24];
index[W1+1] <= D1[23:16];
index[W1+2] <= D1[15:8];
index[W1+3] <= D1[7:0];
end

end

endmodule 

module testDataMem; //inputs are reg - 2 i/p , 7 o/p

 reg [31:0] R1,R2; //address '32 bits 
 reg [31:0] W1;

 reg[31:0] D1; // data to be saved '32 bits
 reg We,Re;
 reg clk;

 wire [31:0] in1,in2; //output data from R1,R2 '32 bits


always
begin
#1 clk = ~ clk;  
end



initial
begin

$monitor($time, "  R1:%d , R2: %d ,W1 = %d ,  D1=%d , We=%d, Re=%d, clk=%d, out1=%d, out2=%d ",R1,R2,W1,D1,We,Re,clk,in1,in2);


#1
clk = 0;
We =1;
D1  = 7;
W1 = 4; 

#4
R1 = 4;
Re = 1;

#4
Re = 0;


end

dataMem Mem1(R1,R2,W1,D1,We,Re,clk,in1,in2);
endmodule 

////////////////////////////////////////////

//InstMemory
module InstMem(R1,W1,D1,We,clk,O1); // 4 i/p , 1 o/p

input [31:0] R1 , W1 ;//address '32 bits 
input [31:0] D1;
input clk,We;

output reg [31:0] O1; //output data from R1'32 bits

reg [7:0] index[0:(2^32)-1]; // first is number of mem size , second is number of memvalues


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