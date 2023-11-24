module mux(sel1,sel0,clk,rst,a,b,c,d,e,f,g);
    
	 input clk,rst;
	 input sel1,sel0;
	 output wire a,b,c,d,e,f,g;
	 
    reg [6:0]segments;
    reg [2:0]counter;
    reg [28:0]divider;
    reg [28:0]times;
    
    reg spike;
    
    always@(sel1 or sel0)begin
        case ({sel1,sel0})
            2'd0: times = 29'd25000000;
            2'd1: times = 29'd50000000;
            2'd2: times = 29'd100000000;
            2'd3: times = 29'd300000000;
            default: times = 29'd50000000;
        endcase
    end
    
    always@(posedge clk) begin
        if(divider >= times) begin
            spike <= 1;
            divider <= 0;
        end else begin
            spike <= 0;
            divider <= divider + 1;
        end
    end
    
    always@(posedge spike or posedge rst) begin
        if(rst)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    always @*
        case ({counter[2], counter[1], counter[0]})
            3'd7: segments = 7'b0001111; //7
            3'd6: segments = 7'b0100000; //6
            3'd5: segments = 7'b0100100; //5
            3'd4: segments = 7'b1001100; //4
            3'd3: segments = 7'b0000110; //3
            3'd2: segments = 7'b0010010; //2
            3'd1: segments = 7'b1001111; //1
            3'd0: segments = 7'b0000001; //0
            default: segments = 7'b1111111; //off
        endcase
    
    assign 	{a,b,c,d,e,f,g} = segments;
    
endmodule