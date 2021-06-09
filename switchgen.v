/////////////////////////////////////////////////////////////////////////////////////////////
//File Name : switch.v                                                                     //
//Description : Bufferless router following XY routing                                     //
/////////////////////////////////////////////////////////////////////////////////////////////
//switch gen

module switchgen #(parameter x_coord ='d3,parameter y_coord='d1,X=4,Y=4,data_width=8, x_size=2, y_size=2,total_width=(2*x_size+2*y_size+data_width),sw_no=X*Y,layerNo=1,neuronNo=2,numWeight=4,sigmoidSize=5,weightIntWidth=2,bias=16'h1AA5,weightFile="w_1_2")
(
input wire clk,
input wire rstn,
input wire i_ready_r,  //if right side switch is ready to accept data from this switch
input wire i_ready_t,  //if top  switch is ready to accept data from this switch
input wire i_ready_pe, //if PE is ready to accept data from this switch.....this should come from neuron..//incorporate
input wire i_valid_l,  // if data coming from left switch is valid or not
input wire i_valid_b,  // if data coming from bottom switch is valid or not
input wire i_valid_pe, // if data coming from PE is valid or not.....this should come from neuron i.e. finoutvalid
output wire o_ready_l, //if this switch is ready to accept data from left side switch
output wire o_ready_b,  //if this switch is ready to accept data from bottom switch
output reg  o_ready_pe, //if this switch is ready to accept data from PE....//incorporate
output reg o_valid_r,  // if data going out from this switch to right side switch is valid or not
output reg o_valid_t,  // if data going out from this switch to top switch is valid or not
output reg o_valid_pe, // if data going out from this switch to PE is valid or not.....myinputvalid
input wire [total_width-1:0] i_data_l,
input wire [total_width-1:0] i_data_b,
input wire [total_width-1:0] i_data_pe,
output reg [total_width-1:0] o_data_r,
output reg [total_width-1:0] o_data_t,
output reg [total_width-1:0] o_data_pe
);

/*neuron #(.layerNo(layerNo),.neuronNo(neuronNo),.numWeight(numWeight),.sigmoidSize(sigmoidSize),.weightIntWidth(weightIntWidth),.bias(bias),.weightFile(weightFile),.x_coord(x_coord), .y_coord(y_coord))
   nn2(
    .clk(clk),
    .rst(rstn), // assuming active low reset
    .myinput(o_data_pe), //input comes from its own switch 
    .myinputValid(o_valid_pe),  //
    .finout(i_data_pe), //output goes to its own switch
    .finoutvalid(i_valid_pe), 
	.i_ready_pe(i_ready_pe),
	.o_ready_pe(o_ready_pe)
    );*/

wire leftToPe;
wire bottomToPe;
wire peTope;
wire leftToRight;
wire leftToTop;
wire bottomToRight;
wire bottomToTop;
wire peToTop;
wire peToRight;

assign  o_ready_l = 1'b1;
assign  o_ready_b = 1'b1;
//assign  o_ready_pe = 1'b1;

assign leftToPe = ((i_data_l[3:2]==x_coord) & (i_data_l[1:0]==y_coord) & i_valid_l);
assign leftToRight = ((i_data_l[3:2]!=x_coord) & i_valid_l);
assign leftToTop = (i_data_l[3:2]==x_coord) & (i_data_l[1:0]!=y_coord) & i_valid_l;
assign bottomToPe = (i_data_b[3:2]==x_coord) & (i_data_b[1:0]==y_coord) & i_valid_b;
assign bottomToRight = (i_data_b[1:0]==y_coord) & (i_data_b[3:2]!=x_coord) & i_valid_b;// ? 1'b1 : 1'b0;
assign bottomToTop = (i_data_b[1:0]!=y_coord ) & i_valid_b;
assign peTope = ((i_data_pe[3:2]==x_coord) & (i_data_pe[1:0]==y_coord) & i_valid_pe & o_ready_pe);
assign peToRight = ((i_data_pe[3:2]!=x_coord) & i_valid_pe & o_ready_pe);
assign peToTop = (~peToRight & (i_data_pe[1:0]!=y_coord) & i_valid_pe & o_ready_pe);


always @(*)
begin
    //If there are no packets to either right or top, we can accept data from PE
    //If packets have to be sent to both out ports, will have to back pressure the PE
    if((~leftToRight & ~leftToTop & ~leftToPe) | (~bottomToTop & ~bottomToRight & ~bottomToPe))
    begin
        o_ready_pe = 1'b1;
    end
    else
    begin
        o_ready_pe = 1'b0;
    end
end

always @(posedge clk)
begin
    if(!rstn)
        o_valid_r <=1'b0;
    //Whenever data from left wants to go right, it will be given preference
    else
    begin
        casex({leftToRight,leftToTop,leftToPe,bottomToRight,bottomToTop,bottomToPe,peTope,peToRight,peToTop,i_ready_pe})
            10'bxxx_1xx_xxx_x:begin //bottomToRight
                o_data_r  <= i_data_b;
                o_valid_r <= 1'b1;
            end
            10'b1xx_xxx_xxx_x:begin//leftToRight
                o_data_r  <= i_data_l;
                o_valid_r <= 1'b1;
            end
            10'b0xx_xxx_x1x_x:begin//peToRight
                o_data_r  <= i_data_pe;
                o_valid_r <= 1'b1;
            end
            10'bx1x_x1x_xxx_x:begin //leftToTop & bottomToTop
                o_data_r <= i_data_l;
                o_valid_r <= 1'b1;
            end
            10'bx1x_xxx_xx1_x:begin //leftToTop & peToTop
                o_data_r <= i_data_pe;
                o_valid_r <= 1'b1;
            end
            10'bxxx_x1x_xx1_x:begin//peToTop & bottomToTop
                o_data_r  <= i_data_pe;
                o_valid_r <= 1'b1;
            end
            10'bxx1_xxx_1xx_x:begin//leftToPe & peTope
                o_data_r  <= i_data_l;
                o_valid_r <= 1'b1;
            end
            10'bxx1_xx1_xxx_x:begin//leftToPe & bottomToPe
                o_data_r  <= i_data_l;
                o_valid_r <= 1'b1;
            end
            10'bxxx_xx1_1xx_x:begin//peTope & bottomToPe
                o_data_r  <= i_data_b;
                o_valid_r <= 1'b1;
            end
            10'bxx1_xxx_xxx_0:begin//leftToPe & !i_ready_pe
                o_data_r  <= i_data_l;
                o_valid_r <= 1'b1;
            end
            10'bxxx_xxx_1xx_0:begin//peTope & !i_ready_pe
                o_data_r <= i_data_pe;
                o_valid_r <= 1'b1;
            end
            10'bx1x_xx1_xxx_0:begin//leftToTop & bottomToPe & !i_ready_pe
                o_data_r <= i_data_b;
                o_valid_r <= 1'b1;
            end
            10'bxxx_xx1_xx1_0:begin//peToTop & bottomToPe & !i_ready_pe
                o_data_r  <= i_data_b;
                o_valid_r <= 1'b1;
            end
            default:begin
                o_valid_r <= 1'b0;
            end
        endcase
    end
end


always @(posedge clk)
begin
    if(!rstn)
        o_valid_t <= 1'b0;
    else
    begin
        casex({leftToRight,leftToTop,leftToPe,bottomToRight,bottomToTop,bottomToPe,peTope,peToRight,peToTop,i_ready_pe})
            10'bxxx_x1x_xxx_x:begin//bottomToTop
                o_data_t <= i_data_b;
                o_valid_t <= 1'b1;
            end
            10'bx1x_xxx_xxx_x:begin //leftToTop
                o_data_t <= i_data_l;
                o_valid_t <= 1'b1;
            end
            10'bxxx_xxx_xx1_x:begin //peToTop
                o_data_t <= i_data_pe;
                o_valid_t <= 1'b1;
            end
            10'b1xx_1xx_xxx_x:begin //bottomToRight & leftToRight
                o_data_t <= i_data_l;
                o_valid_t <= 1'b1;
            end
            10'bxxx_1xx_x1x_x:begin //bottomToRight & peToRight
                o_data_t <= i_data_pe;
                o_valid_t <= 1'b1;
            end
            10'bxx1_1xx_xxx_0:begin//bottomToRight & leftToPe & ~i_ready_pe
                o_data_t <= i_data_l;
                o_valid_t <= 1'b1;
            end
            10'bxxx_1xx_1xx_0:begin//bottomToRight & peTope & ~i_ready_pe
                o_data_t <= i_data_pe;
                o_valid_t <= 1'b1;
            end
            10'b1xx_xxx_x1x_x:begin //leftToRight & peToRight
                o_data_t <= i_data_pe;
                o_valid_t <= 1'b1;
            end
            10'b1xx_xxx_1xx_0:begin //leftToRight & peTope & ~i_ready_pe
                o_data_t <= i_data_pe;
                o_valid_t <= 1'b1;
            end
            10'bxx1_xxx_x1x_0:begin//leftToPe & peToRight & ~i_ready_pe
                o_data_t <= i_data_l;
                o_valid_t <= 1'b1;
            end
            10'bxx1_xxx_1xx_0:begin //leftToPe & peTope & ~i_ready_pe
                o_data_t <= i_data_pe;
                o_valid_t <= 1'b1;
            end
            10'bxxx_xx1_1xx_0:begin//bottomToPe & peTope & ~i_ready_pe
                o_data_t <= i_data_pe;
                o_valid_t <= 1'b1;
            end
            10'bxxx_xx1_xxx_0:begin//bottomToPe & ~i_ready_pe
                o_data_t <= i_data_b;
                o_valid_t <= 1'b1;
            end
            default:begin
                o_valid_t <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk)
begin
    if(!rstn)
        o_valid_pe <= 1'b0; 
        
    else if(peTope & i_ready_pe)
    begin
        o_data_pe <= i_data_pe;
        o_valid_pe <=1'b1;
    end
    else if(bottomToPe & i_ready_pe)
    begin
        o_data_pe  <= i_data_b;
        o_valid_pe <= 1'b1;
    end
    else if(leftToPe & i_ready_pe)
    begin
        o_data_pe <= i_data_l;
        o_valid_pe <= 1'b1;
    end
    else if(o_valid_pe & ~i_ready_pe)
        o_valid_pe <=1'b1;
    else
        o_valid_pe <=1'b0;
end


endmodule
