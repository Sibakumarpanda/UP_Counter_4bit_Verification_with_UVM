// Project    :  UP Counter using clock divider
// Author     :  Siba
// Created on :  7th feb,2021
// Language used: Verilog HDL


/* Design of UP Counter using clock divider on FPGA */

module upcounter_4bit_using_clock_divider(input clk,rst,output reg [3:0]count_out);
reg [26:0]count;
reg clk_out;
always @(posedge clk)
begin
   if(rst)
   begin
   count<=27'b0;
   clk_out<=1'b0;
   end
   else if(count==27'd100000000)
   begin
   clk_out<=~clk_out;
   count<=27'b0;
   end
   else
   begin
   count<=count+1'b1;
   clk_out<=clk_out;
   end
end
always@(posedge clk_out,posedge rst)
begin
if(rst)
count_out<=4'b0;
else
count_out<=count_out+1'b1;
end
endmodule
