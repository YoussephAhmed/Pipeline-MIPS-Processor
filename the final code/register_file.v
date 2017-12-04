module regFile(rs_address,rt_address,dest_address,writeBack_data,reg_write,clk,rs_data,rt_data); // 6 i/p , 2 o/p

input [4:0] rs_address,rt_address; //address '5 bits 
input [4:0] dest_address;
input[31:0] writeBack_data; // data to be saved '32 bits
input reg_write;
input clk;

output reg [31:0] rs_data,rt_data; //output data from rs_address,rt_address '32 bits

reg [31:0] index[0:31]; // first is number of reg size , second is number of regs




always @(negedge clk)
begin
if(reg_write)
index[dest_address] <= writeBack_data;


rs_data <= index[rs_address];
rt_data <= index[rt_address];
end
integer i;


initial
begin
for (i = 0 ; i < 32 ; i = i+1)

index[i] = i;
end
endmodule 

//////////////////////////////////////////////////////////////////////////////////
module testRegFile; //inputs are reg - 2 i/p , 6 o/p

 reg [4:0] rs_address,rt_address; //address '5 bits 
 reg [4:0] dest_address;

 reg[31:0] writeBack_data; // data to be saved '32 bits
 reg reg_write;
 reg clk;

 wire [31:0] in1,in2; //output data from rs_address,rt_address '32 bits

integer i;

always
begin
#1 clk = ~ clk;  
end



initial
begin

clk = 0;
reg_write =1;


$monitor($time, "  rs_address:%d , rt_address: %d ,dest_address = %d , writeBack_data=%d , reg_write=%d, clk=%d, out1=%d, out2=%d ",rs_address,rt_address,dest_address,writeBack_data,reg_write,clk,in1,in2);


//to init the data in reg every address have a value of his address 
for(i = 0 ; i < 32 ; i = i+1)
begin
writeBack_data <= i;
dest_address <= i;
#2;
end

reg_write = 0;
//to view the stored data
for (i = 0 ; i < 32 ; i = i+1)
begin
rs_address <= i;
rt_address <= i;
#1;
end

end

regFile Reg1(rs_address,rt_address,dest_address,writeBack_data,reg_write,clk,in1,in2);
endmodule 

