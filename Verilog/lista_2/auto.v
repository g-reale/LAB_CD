module auto(V_SW,G_HEX4,CLOCK_50);
    
    input [17:17]V_SW;
    input CLOCK_50;
    output wire [0:6] G_HEX4;
    
    reg [6:0]segments;
    reg [2:0]counter;
    reg [25:0] divider;
    reg spike;
    
    always@(posedge CLOCK_50) begin
        if(divider == 26'd50000000) begin
            spike <= 1;
            divider <= 0;
        end else begin
            spike <= 0;
            divider <= divider + 1;
        end
    end
    
    always@(posedge spike or posedge V_SW[17]) begin
        if(V_SW[17])
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
    
    assign G_HEX4 = segments;
    
endmodule