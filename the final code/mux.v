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





