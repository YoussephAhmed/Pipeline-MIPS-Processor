module ALU (reg_data1,reg_data2,immidiate_value,ALUsrc,control_signals,zero,overflow,result)
input [31:0]reg_data1,reg_data2,immidiate_value;
input ALUsrc;// 1 to operate on immediate value  
input [3:0] control_signals;

output zero,overflow;
output [31:0] result;
end module

/*
  control signal 
  0000-->and
  0001-->or
  0010-->sub
  0110-->slt   //set (the least significant bit =1) on less than
  1100-->nor
  */
  
