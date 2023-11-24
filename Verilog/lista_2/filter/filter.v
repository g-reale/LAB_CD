module filter(clk,auto_clk,rst,a,b,c,d,e,f,g);
    
    input rst;
    input clk;
    input auto_clk;
    output wire a,b,c,d,e,f,g;
    
    reg [6:0]segments;
    reg [2:0]counter;
    reg [1:0]filter;
    
    always@(posedge auto_clk) begin
        if(clk && filter < 2'd2)
            filter <= filter + 1;
        else if (!clk)
            filter <= 0;
    end
    
    always@(posedge filter[1] or posedge rst) begin
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
    
    assign {a,b,c,d,e,f,g} = segments;
    
endmodule