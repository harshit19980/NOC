`timescale 1ns / 1ps
module neuron #(parameter layerNo=0,neuronNo=0,numWeight=4,sigmoidSize=5,weightIntWidth=2,bias=16'h1565,weightFile="w_1_1",x_coord =2'b01, y_coord=2'b00) //xcoord and ycoord are its own switch addressses
   (
    input           clk,
    input           rst, // assuming active low reset
    input [15:0]    myinput, //input comes from its own switch 
    input           myinputValid,  //
    output reg[15:0]    finout, //output goes to its own switch
    output reg      finoutvalid, 
	output reg      i_ready_pe,
	input           o_ready_pe
    );
	
    


    wire [7:0]   out;
    wire        ren;
    wire [2:0]   r_addr; //should be 1 bit more bcoz at the end it becomes equal to numWeight
    wire [7:0] w_out;   //since actual data size is only 8 bits
    reg [15:0]  mul;  
    reg [15:0]  sum;  
    reg         mult_valid;
    wire        mux_valid;
    reg         sigValid; 
    //wire [15:0] comboAdd;
	reg [15:0] comboAdd;
    reg [15:0] BiasAdd;  
    reg  [15:0] myinputd; 
    reg muxValid_d;
    reg muxValid_f;
	reg [1:0]xn;
	reg [1:0]yn;
	reg [1:0]xn1;
	reg [1:0]xn2;
	reg [1:0]yn1;
	reg [1:0]yn2;
	reg [15:0]finout1;
	reg [15:0]finout2;
	reg [15:0]finout_temp;
	reg myinputValidd;
	integer pred;
	integer succ;
	integer temp_count;
	integer flag=1;
	wire [3:0] cord;
	wire [1:0] x;
	wire [1:0] y;
	assign x={x_coord};
	assign y={y_coord};
	assign cord= {x,y};
	
	always@(posedge clk) //added
	begin
	if(rst==0)
	begin
	if(layerNo==1) //in which block should this be kept?
	    begin
	     pred=4;
		 succ=2;
		 xn1=2'b10;
		 yn1=2'b00;
		 xn2=2'b10;
		 yn2=2'b01;
	   end
    else if(layerNo==2)
	    begin
	      pred=3;
		  succ=4;
		  xn=2'b00;
		  yn=2'b00;
	    end
	end
	end
	
	assign mux_valid = mult_valid;
    //assign comboAdd = mul + sum;
	always@(mul)
	begin
	comboAdd=mul+sum;
	end
	
    //assign BiasAdd = bias + sum;
    assign ren = myinputValid;
	
	
    
    assign r_addr = myinput[5:4];
    /*always @(posedge clk) //modified
    begin
        if(~rst|finoutvalid)
            r_addr <= 0;
        else if(myinputValid == 1'b1)
            //r_addr <= myinput[5:4];			//Y coords will be such that they are 0,1,2,3 for the corresponding pred
			r_addr <= r_addr + 1;
    end
	*/
    
    always @(posedge clk)
    begin
        mul  <= $signed(myinputd[15:8]) * $signed(w_out);  //since input data is only 8 bits and rest 8 bits are source and dest address
    end
    
	always@(posedge clk)
	begin
	if(rst==0)
	    begin
		  temp_count=0;
		  i_ready_pe=1'b1;
		end
	end
		
		
	always @(mul)
	    begin
		  temp_count=temp_count+1;
		end
		
	  
	 
    
    always @(posedge clk)
    begin
        if(rst& mult_valid & flag | sigValid)
				begin
					sum <= 0;
					flag=0;
					end
        else if(temp_count == pred)
				begin
                //sum <= BiasAdd;
				BiasAdd <= bias +comboAdd;
				end
			else if(temp_count != pred)
				begin
                sum <= comboAdd; 
				end
    end
    
    always @(posedge clk)
    begin
        myinputd <= myinput;
        mult_valid <= myinputValid;
        sigValid <=(temp_count == pred)? 1'b1 : 1'b0;
        finoutvalid <= sigValid;
        muxValid_d <= mux_valid;
		myinputValidd<=myinputValid;
    end
    
    
    //Instantiation of Memory for Weights
    Weight_Memory #(.numWeight(numWeight),.weightFile(weightFile)) WM(
        .clk(clk),
        .ren(ren),
        .radd(r_addr),
        .wout(w_out)
    );
    
 
        //Instantiation of ROM for sigmoid
            Sig_ROM #(.inWidth(sigmoidSize)) s1(
            .clk(clk),
            .x(BiasAdd[15-:sigmoidSize]),
            .out(out)
        );

	
	// generating output packets (added)
	always@(out)
	begin
	if(layerNo==1)
	    begin
	     finout1 <= {out,cord,xn1,yn1};
		 finout2 <= {out,cord,xn2,yn2};
		 finout_temp <= {out,cord,xn1,yn1};
	   end
    else if(layerNo==2)
	    begin
	      finout_temp <= {out,cord,xn,yn};
	    end
	end
		
always @(posedge clk)
	begin
	    if(finoutvalid /*&& o_ready_pe*/) 
		    begin
		      if(layerNo==2)
			    begin
	            finout=finout_temp;			
				end
			  else if(layerNo==1) //for layer 1, finout_temp=finout1 first and in next cycle finout2 and we are assigning finout = finout_temp
			    begin
				finout=finout_temp;
				finout_temp=finout2;
				end
	        end
	end
	
endmodule
