`timescale 1ns / 1ps
module Weight_Memory #(parameter numWeight=4, weightFile="w_1_1") 
    ( 
    input clk,
    input ren,
    input [2:0] radd,
    output reg [7:0] wout);
    
    reg [15:0] mem [numWeight-1:0];

    
        initial
		begin
	        $readmemb(weightFile, mem);
	    end
	
    
    always @(posedge clk)
    begin
        if (ren)
        begin
            wout <= mem[radd];
        end
    end 
endmodule
