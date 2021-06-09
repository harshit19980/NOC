`timescale 1ns/1ps
module testbench();
reg clk;
reg rstn;
reg [15:0] i_external_data;
wire [15:0] o_external_data;
reg  i_external_data_valid;
reg  o_external_data_valid;

openNocTop #(.X(4),.Y(4),.data_width(8),.x_size(2),.y_size(2),.total_width(16))
n1(
clk,
rstn,
i_external_data,
o_external_data,
i_external_data_valid,
o_external_data_valid
);

initial
begin
rstn = 1'b0;
clk = 1'b1;
#2 rstn = 1'b1;
i_external_data_valid = 1'b1;
o_external_data_valid = 1'b1;
#10 i_external_data = 16'b1011011100000100;
#10 i_external_data = 16'b0110101000010100;
#10 i_external_data = 16'b0111000000100100;
#10 i_external_data = 16'b1111000000110100;
#10 i_external_data = 16'b1011011100000101;
#10 i_external_data = 16'b0110101000010101;
#10 i_external_data = 16'b0111000000100101;
#10 i_external_data = 16'b1111000000110101;
#10 i_external_data = 16'b1011011100000110;
#10 i_external_data = 16'b0110101000010110;
#10 i_external_data = 16'b0111000000100110;
#10 i_external_data = 16'b1111000000110110;
end

always #5 clk=~clk;


endmodule