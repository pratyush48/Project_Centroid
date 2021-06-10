`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2020 10:47:29
// Design Name: 
// Module Name: topcontroller_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module topcontroller_tb;

//integer i;
integer k,i;


wire txd;
reg  rxd;

reg clk=1;
reg rst;

reg [7:0] sw=0;
reg send=0;

topcontroller top_instance(     
    .clk(clk),
    .rst(rst),
    .rxd(rxd),
    .txd(txd) );
    
reg bpsclk=1;
always #(4340) bpsclk=!bpsclk;

always #(5) clk=!clk;

reg [15:0] addr;
//wire[7:0] doutb;
reg [7:0] data1 =8'b00000001;  // = 44
//reg [7:0] temp;
//reg [7:0] data2=8'b01001101;  // = 77

initial begin 
    addr = 0;
    rst=1;
    #(10)rst=0;
    
//    for(i = 0;i < 65536;i = i+1)begin
//        $display("txd = %b",txd);
//    end
//    $display("txd=%b,rxd=%b",txd,rxd);
  for(i=0;i<2499;i=i+1)begin  
    for(k=0;k<10;k=k+1) begin
        if(k==0)
            rxd=0;
        else if(k==9)
            rxd=1;
        else begin
            rxd=data1[k-1];
        end
        #(8680);
    end
    data1 = data1+1;
    end
//    data1 = 8'b00101101;
//    for(k=0;k<10;k=k+1) begin
//        if(k==0)
//            rxd=0;
//        else if(k==9)
//            rxd=1;
//        else begin
//            rxd=data1[k-1];
//        end
//        #(8680);
//    end 
       
//    for(k=0;k<10;k=k+1) begin
//        if(k==0)
//            rxd=0;
//        else if(k==9)
//            rxd=1;
//        else begin
//            rxd=data2[k-1];
//        end
//        #(8680);
//    end
    

    end





endmodule
