
module testbench;

wire [31:0]pc_output,ALU_Result,Mem_out,Instr_32;


reg [31:0] read_address , write_address ;//address '32 bits 
reg [7:0] write_data;
reg We , clk;
wire [31:0] read_data;

reg [7:0] index[0:256];

always
#100 clk = ~ clk;


integer i,j;
reg pc_enable=0;

initial
begin
clk=0;
We=1;
#5
We=0;
#5;
/*
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
#3;
pc_enable=1;
#5;
if (pc_output==2);
pc_enable=0;
*/
end
 processor e7na_a4ba7_fa45olaaaaa(write_data,write_address,We,pc_output,ALU_Result,Mem_out,pc_enable,clk);//module processor(write_data,write_address,We,pc_output,ALU_Result,Mem_out,clk);
endmodule


/*
for (j=0;j<3;j=j+1)
begin

read_address<=j;
#5;
$display(    "  write_address=%d, write_data=%d  ,read_address=%d,  read_data =%d  ,We= %d" 
              ,write_address,write_data,read_address,read_data,We);
end
*/