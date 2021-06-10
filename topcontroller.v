
module topcontroller(   input clk,
                        input rst,
                        input rxd,
                        output txd );
    
    wire [15:0] prescale=100000000/(115200*8);
    
    reg [7:0] senddata;
    reg sendvalid=0;
    wire [7:0] readdata;
    wire readvalid;
    reg[31:0]sum_num_y = 0,sum_num_x = 0,sum_den_x = 0;
    reg[1:0] counter_r,counter_w;
    reg[2:0] state=0;
    reg[7:0]Xcom = 0,Ycom = 0;//--ILA4,ILA5
    reg[7:0]roi[1:21][1:21];
    reg [7:0] data1=0;
    reg ena,enb;
    reg[0:0] wea;
    reg[15:0] addra;
    reg[7:0] dina,max = 0;
    reg[15:0] row,col,row_max,row_min,col_max,col_min,i,j;
    wire[7:0] douta;
    reg done = 0;
    reg max_done = 0;
    reg roi_done = 0;
    integer k,l;
    reg centroid_done = 0;
    integer count;
    
    uart uartuut(
    .clk(clk),
    .rst(rst),
    .s_axis_tdata(senddata),
    .s_axis_tvalid(sendvalid),
    .m_axis_tdata(readdata),
    .m_axis_tvalid(readvalid),
    .m_axis_tready(1),
    .rxd(rxd),
    .txd(txd),
    .prescale(prescale)

);


blk_mem_gen_1 mem (
  .clka(clk),    // input wire clka
  .ena(ena),      // input wire ena
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [15 : 0] addra--ILA1
  .dina(dina),    // input wire [7 : 0] dina--ILA2
  .douta(douta)  // output wire [7 : 0] douta--ILA3
);

ila_0 navyush (
	.clk(clk), // input wire clk


	.probe0(addra), // input wire [15:0]  probe0  
	.probe1(dina), // input wire [7:0]  probe1 
	.probe2(douta), // input wire [7:0]  probe2 
	.probe3(Xcom), // input wire [7:0]  probe3 
	.probe4(Ycom) // input wire [7:0]  probe4
);

initial
begin
    ena = 1;
    wea = 1;
    addra = 0;
end

always @(posedge clk) begin
    if(rst==1) begin
        state=0;
        sendvalid=0;
        data1=0;
    end
    
    case(state)
    
    3'b000: begin //writing to block ram
            sendvalid=0;
            if(readvalid) begin
                ena = 1;
                wea = 1;            
                data1=readdata;
                dina = data1;  
                addra = addra+1; 
                if(addra == 65535)begin    
                    addra = 0;
                    done = 1;
                    wea = 0;
                    state = 3'b001;
                    count=0;
                end                  
                end                
            end   
    3'b001:begin//finding max
          if(done == 1)begin
            if(count<3)begin
                count = count+1;
            end
            else begin
                if(douta > max)begin
                    max = douta;            
                    row = addra/256;
                    col = addra - (row+1)*256;
                    row_max = row+10;
                    row_min = row-10;
                    col_max = col+10;
                    col_min = col-10;
                    i = row_min;
                    j = col_min;
                end
            addra = addra+1;
            count = 0;
            end
            if(addra == 65535)begin
                max_done = 1;
                k = 1;
                l = 1;
                wea = 0;
                count = 0;
                state = 3'b010;
            end
          end
        end         
    3'b010:begin//finding ROI
          if(max_done == 1)begin
            if(i <= row_max)begin
                if(j <= col_max)begin
                    addra = i*256+j;
                    if(count<3)begin
                    count = count+1;
                    end
                    else begin
                    roi[k][l] = douta; 
//                  $display("k = %d,l = %d,val=%d",k,l,douta);
                    j = j+1;
                    l = l+1;    
                    count = 0;
                end 
                end
                else begin
                    j = col_min;
                    l = 1;
                    i = i+1;
                    k = k+1;    
                end
              end
            else begin
                roi_done = 1;
                state = 3'b011;
            end
          end                      
          end
    3'b011:begin//Finding Xcom
          for(l = 1;l <= 21;l=l+1)begin
              for(k = 1;k <= 21;k = k+1)begin
//                $display("l = %d,k= %d,val = %d",l,k,roi[k][l]);
                sum_num_x = sum_num_x +  l*roi[k][l];
                sum_den_x = sum_den_x + roi[k][l];
              end
          end
          Xcom = sum_num_x/sum_den_x;
          state = 3'b100;
          end
    3'b100:begin//Finding Ycom
          for(k = 1;k <= 21;k=k+1)begin
              for(l = 1;l <= 21;l = l+1)begin
                sum_num_y = sum_num_y +  k*roi[k][l];
              end
          end    
          Ycom = sum_num_y/sum_den_x;      
          centroid_done = 1;
          state = 3'b101;
          end                    
    3'b101: begin //Xcom is sent
           if(centroid_done == 1)begin
                senddata = Xcom;
                $display("%d",Xcom);
                sendvalid = 1;
                state = 3'b110;
           end
           end
    3'b110: begin //Ycom is sent
           senddata = Ycom;
           $display("%d",Ycom);
           sendvalid = 1; 
           $finish;          
           end
    endcase
end

endmodule
