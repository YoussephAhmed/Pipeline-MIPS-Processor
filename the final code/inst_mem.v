
module InstMem(read_address,write_address,write_data,We,clk,read_data); // 5 i/p , 1 o/p
input [31:0] read_address , write_address ;//address '32 bits 

input [7:0] write_data;

input clk,We;
output reg [31:0] read_data; //output data from R1'32 bits
reg [7:0] index[0:255]; // first is number of mem size , second is number of memvalues

initial 
begin
$readmemb("D:\\projects\\MIPS\\Pipeline-MIPS-Processor\\output.txt" , index);
end


always @(posedge clk)
begin

//#1 ///4eeeel el delay daaaaaaaaaaaaaaaaaaa
read_data <= { index[read_address[7:0]],index[read_address[7:0]+1],index[read_address[7:0]+2],index[read_address[7:0]+3]};
 $display("blaaaaaaaaaaaaaaa");

end
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*if(We)
begin
index[write_address[7:0]]<= write_data;
end

else
*/

module testInstMem;

reg [31:0] read_address , write_address ;//address '32 bits 
reg [7:0] write_data;
reg We , clk;
wire [31:0] read_data;

reg [7:0] index[0:256];

always
#1 clk = ~ clk;


integer i,j;
initial
begin

$readmemb("E:\MyMemoryFile.txt" , index,0,11);

clk =0;
$display(    "  write_address=%d, write_data=%d  ,read_address=%d,  read_data =%d  ,We= %d" 
              ,write_address,write_data,read_address,read_data,We);


We=1;
for (i=0;i<12;i=i+1)
begin
#5
write_address<=i;
write_data<=index[i];
#5;
end

We=0;

for (j=0;j<3;j=j+1)
begin

read_address<=j;
#5;
$display(    "  write_address=%d, write_data=%d  ,read_address=%d,  read_data =%d  ,We= %d" 
              ,write_address,write_data,read_address,read_data,We);
end

end



InstMem instMem1(read_address,write_address,write_data,We,clk,read_data);
endmodule 