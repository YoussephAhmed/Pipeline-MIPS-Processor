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

/*

always @(posedge clk)
begin
if(pc_enable)
out_address<= in_address;
end  
always @(negedge We)
begin
out_address <=0;
end
endmodule
*/