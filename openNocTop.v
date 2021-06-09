/////////////////////////////////////////////////////////////////////////////////////////////
//File Name : openNocTop.v                                                                 //
//Description : Top most file of openNoc.                                                  //
/////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps


module openNocTop #(parameter X=4,Y=4,data_width=8,x_size=2,y_size=2,total_width=(2*x_size+2*y_size+data_width))//,if_width=total_width*X*Y)
(
input wire clk,
input wire rstn,
input [total_width-1:0] i_external_data,
output [total_width-1:0] o_external_data,
input  i_external_data_valid,
input  o_external_data_valid
);

wire  r_ready_r[X*Y-1:0];
wire  r_ready_t[X*Y-1:0];
wire  r_valid_l[X*Y-1:0];
wire  r_valid_b[X*Y-1:0];
wire  w_ready_l[X*Y-1:0];
wire  w_ready_b[X*Y-1:0];
wire  w_valid_r[X*Y-1:0];
wire  w_valid_t[X*Y-1:0];
wire [total_width-1:0]  w_data_r[X*Y-1:0];
wire [total_width-1:0]  w_data_t[X*Y-1:0];

wire [(X*Y)-1:0] r_valid_pe;
wire [total_width-1:0] r_data_pe [X*Y-1:0];
wire [(X*Y)-1:0] r_ready_pe;
wire [(X*Y)-1:0] w_valid_pe;
wire [(X*Y)-1:0] w_ready_pe;
wire [total_width-1:0] w_data_pe [X*Y-1:0];


generate
genvar x, y; 
for (x=0;x<X;x=x+1) begin:xs
    for (y=0; y<Y; y=y+1) begin:ys
        if(x==0 & y==0)
        begin: instnce
            switch00 #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width), .x_size(x_size), .y_size(y_size),.total_width(total_width))
                sw00(
                    .clk(clk), 
                    .rstn(rstn),     
                    .i_ready_r(r_ready_r[(y*X)+x]),   ////  
                    .i_ready_t(r_ready_t[(y*X)+x]),////
                    .i_valid_l(1'b0),//   changing on jun 2nd 3:30pm                       
                    .i_valid_b(1'b0),///changing on jun 2nd 3:30pm 
                    .i_valid_pe(i_external_data_valid),
                    .o_ready_l(r_ready_r[(y*X)+x+X-1]),    ////                      
                    .o_ready_b(r_ready_t[(y*X)+x+(Y-1)*X]),////
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),                     
                    .o_valid_r(w_valid_r[y*X+x]),//                          
                    .o_valid_t(w_valid_t[y*X+x]),///
                    .o_valid_pe(o_external_data_valid),
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),
					
                    .i_data_l(w_data_r[3]),    //changing this on jun 2nd 1pm                   
                    //.i_data_b(w_data_t[12]),///changing this on jun 2nd 1pm
					  .i_data_b(w_data_t[12]),
                    .o_data_r(w_data_r[y*X+x]),//
                    .o_data_t(w_data_t[y*X+x]),///
                    .i_data_pe(i_external_data),
                    .o_data_pe(o_external_data)
                    );
         end

        else if(x!=0 && y==0)
        begin: instnce
		    if(x==1 && y==0)
			    begin
				switch10 #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width),.x_size(x_size), .y_size(y_size),.total_width(total_width),.layerNo(1),.neuronNo(1),.numWeight(4),.sigmoidSize(5),.weightIntWidth(2),.bias(16'h1565),.weightFile("w_1_1.mif"))
                sw10(          
                    .clk(clk), 
                    .rstn(rstn),     
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),        //                  
                    .i_valid_b(w_valid_t[(y*X)+x+(Y-1)*X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),
                    .o_ready_l(r_ready_r[(y*X)+x-1]),        //                  
                    .o_ready_b(r_ready_t[(y*X)+x+(Y-1)*X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                      
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),    
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),                 
                    .i_data_l(w_data_r[(y*X)+x-1]),            //             
                    .i_data_b(w_data_t[(y*X)+x+(Y-1)*X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y])
					); 
				  end
			else if(x==2 && y==0)
			      begin
				switch20 #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width),.x_size(x_size), .y_size(y_size),.total_width(total_width),.layerNo(2),.neuronNo(1),.numWeight(3),.sigmoidSize(5),.weightIntWidth(2),.bias(16'h1AA1),.weightFile("w_2_1.mif"))
                sw20(          
                    .clk(clk), 
                    .rstn(rstn),     
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),        //                  
                    .i_valid_b(w_valid_t[(y*X)+x+(Y-1)*X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),
                    .o_ready_l(r_ready_r[(y*X)+x-1]),        //                  
                    .o_ready_b(r_ready_t[(y*X)+x+(Y-1)*X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                      
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),    
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),                 
                    .i_data_l(w_data_r[(y*X)+x-1]),            //             
                    .i_data_b(w_data_t[(y*X)+x+(Y-1)*X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y])
					); 
				  end
			else if(x==3 && y==0)
			      begin
				switch30 #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width),.x_size(x_size), .y_size(y_size),.total_width(total_width),.layerNo(3),.neuronNo(1),.numWeight(1),.sigmoidSize(5),.weightIntWidth(2),.bias(16'h1AA1),.weightFile("w_2_1.mif"))
                sw30(          
                    .clk(clk), 
                    .rstn(rstn),     
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),        //                  
                    .i_valid_b(w_valid_t[(y*X)+x+(Y-1)*X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),
                    .o_ready_l(r_ready_r[(y*X)+x-1]),        //                  
                    .o_ready_b(r_ready_t[(y*X)+x+(Y-1)*X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                      
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),    
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),                 
                    .i_data_l(w_data_r[(y*X)+x-1]),            //             
                    .i_data_b(w_data_t[(y*X)+x+(Y-1)*X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y])
					); 
				  end		  
				else
				begin
                     switchgen #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width), .x_size(x_size), .y_size(y_size),.total_width(total_width))
                nbyn_instance(          
                    .clk(clk), 
                    .rstn(rstn),     
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),        //                  
                    .i_valid_b(w_valid_t[(y*X)+x+(Y-1)*X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),
                    .o_ready_l(r_ready_r[(y*X)+x-1]),        //                  
                    .o_ready_b(r_ready_t[(y*X)+x+(Y-1)*X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                      
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),    
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),                 
                    .i_data_l(w_data_r[(y*X)+x-1]),            //             
                    .i_data_b(w_data_t[(y*X)+x+(Y-1)*X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y])
					);
				end
        end

        else if(x==0 & y!=0 )
        begin: instnce
            switchgen #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width), .x_size(x_size), .y_size(y_size),.total_width(total_width))
                nbyn_instance(
                    .clk(clk),   
                    .rstn(rstn),   
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x+X-1]),                          
                    .i_valid_b(w_valid_t[(y*X)+x-X]),//
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),                     
                    .o_ready_l(r_ready_r[(y*X)+x+X-1]),                          
                    .o_ready_b(r_ready_t[(y*X)+x-X]),//
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                          
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),    
                    .i_data_l(w_data_r[(y*X)+x+X-1]),                         
                    .i_data_b(w_data_t[(y*X)+x-X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y]));
        end         

        else if(x!=0 & y!=0)
         begin: instnce
		    if(x==1 && y==1)
			    begin
				switch11 #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width),.x_size(x_size), .y_size(y_size),.total_width(total_width),.layerNo(1),.neuronNo(2),.numWeight(4),.sigmoidSize(5),.weightIntWidth(2),.bias(16'h1AA5),.weightFile("w_1_2.mif"))
                sw11(
                    .clk(clk),
                    .rstn(rstn),      
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),                          
                    .i_valid_b(w_valid_t[(y*X)+x-X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),    
                    .o_ready_l(r_ready_r[(y*X)+x-1]),                          
                    .o_ready_b(r_ready_t[(y*X)+x-X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                          
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),
                    .i_data_l(w_data_r[(y*X)+x-1]),                         
                    .i_data_b(w_data_t[(y*X)+x-X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y]));
				end
			 else if(x==1 && y==2)
			    begin
				switch12 #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width),.x_size(x_size), .y_size(y_size),.total_width(total_width),.layerNo(1),.neuronNo(3),.numWeight(4),.sigmoidSize(5),.weightIntWidth(2),.bias(16'h1010),.weightFile("w_1_3.mif"))
                sw12(
                    .clk(clk),
                    .rstn(rstn),      
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),                          
                    .i_valid_b(w_valid_t[(y*X)+x-X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),    
                    .o_ready_l(r_ready_r[(y*X)+x-1]),                          
                    .o_ready_b(r_ready_t[(y*X)+x-X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                          
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),
                    .i_data_l(w_data_r[(y*X)+x-1]),                         
                    .i_data_b(w_data_t[(y*X)+x-X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y]));
				end
			 else if(x==2 && y==1)
			    begin
				switch21 #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width),.x_size(x_size), .y_size(y_size),.total_width(total_width),.layerNo(2),.neuronNo(2),.numWeight(3),.sigmoidSize(5),.weightIntWidth(2),.bias(16'hBCBC),.weightFile("w_2_2.mif"))
                sw21(
                    .clk(clk),
                    .rstn(rstn),      
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),                          
                    .i_valid_b(w_valid_t[(y*X)+x-X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),    
                    .o_ready_l(r_ready_r[(y*X)+x-1]),                          
                    .o_ready_b(r_ready_t[(y*X)+x-X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                          
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),
                    .i_data_l(w_data_r[(y*X)+x-1]),                         
                    .i_data_b(w_data_t[(y*X)+x-X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y]));
				end
			else if(x==3 && y==1)
				begin
				   switch31 #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width), .x_size(x_size), .y_size(y_size),.total_width(total_width))
                sw31(
                    .clk(clk),
                    .rstn(rstn),      
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),                          
                    .i_valid_b(w_valid_t[(y*X)+x-X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),    
                    .o_ready_l(r_ready_r[(y*X)+x-1]),                          
                    .o_ready_b(r_ready_t[(y*X)+x-X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                          
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),
                    .i_data_l(w_data_r[(y*X)+x-1]),                         
                    .i_data_b(w_data_t[(y*X)+x-X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y]));
				end
			else if(x==3 && y==2)
				begin
				   switch32 #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width), .x_size(x_size), .y_size(y_size),.total_width(total_width))
                sw32(
                    .clk(clk),
                    .rstn(rstn),      
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),                          
                    .i_valid_b(w_valid_t[(y*X)+x-X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),    
                    .o_ready_l(r_ready_r[(y*X)+x-1]),                          
                    .o_ready_b(r_ready_t[(y*X)+x-X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                          
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),
                    .i_data_l(w_data_r[(y*X)+x-1]),                         
                    .i_data_b(w_data_t[(y*X)+x-X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y]));
				end
			else if(x==3 && y==3)
				begin
				   switch32 #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width), .x_size(x_size), .y_size(y_size),.total_width(total_width))
                sw3(
                    .clk(clk),
                    .rstn(rstn),      
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),                          
                    .i_valid_b(w_valid_t[(y*X)+x-X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),    
                    .o_ready_l(r_ready_r[(y*X)+x-1]),                          
                    .o_ready_b(r_ready_t[(y*X)+x-X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                          
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),
                    .i_data_l(w_data_r[(y*X)+x-1]),                         
                    .i_data_b(w_data_t[(y*X)+x-X]),
					.o_data_r(o_external_data),
                    //.o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y]));
				end
			else
			begin
            switchgen #(.x_coord(x),.y_coord(y),.X(X),.Y(Y),.data_width(data_width), .x_size(x_size), .y_size(y_size),.total_width(total_width))
                nbyn_instance(
                    .clk(clk),
                    .rstn(rstn),      
                    .i_ready_r(r_ready_r[(y*X)+x]),     
                    .i_ready_t(r_ready_t[(y*X)+x]),
                    .i_valid_l(w_valid_r[(y*X)+x-1]),                          
                    .i_valid_b(w_valid_t[(y*X)+x-X]),
                    .i_valid_pe(r_valid_pe[x+X*y:x+X*y]),    
                    .o_ready_l(r_ready_r[(y*X)+x-1]),                          
                    .o_ready_b(r_ready_t[(y*X)+x-X]),
                    .o_ready_pe(r_ready_pe[x+X*y:x+X*y]),
                    .o_valid_r(w_valid_r[(y*X)+x]),                          
                    .o_valid_t(w_valid_t[(y*X)+x]),
                    .o_valid_pe(w_valid_pe[x+X*y:x+X*y]),
                    .i_ready_pe(w_ready_pe[x+X*y:x+X*y]),
                    .i_data_l(w_data_r[(y*X)+x-1]),                         
                    .i_data_b(w_data_t[(y*X)+x-X]),
                    .o_data_r(w_data_r[(y*X)+x]),
                    .o_data_t(w_data_t[(y*X)+x]),
                    .i_data_pe(r_data_pe[x+X*y]),
                    .o_data_pe(w_data_pe[x+X*y]));
			end
            end
        end
    end            
endgenerate 

endmodule