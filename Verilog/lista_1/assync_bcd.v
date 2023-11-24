module bcd(V_SW,V_BT,G_HEX4);
    
    input [17:17]V_SW;
    input [3:3]V_BT;
    output wire [0:6] G_HEX4;
    
    // wire clk = V_BT[3:3];
    // wire reset = V_SW[17:17];
    
    reg [6:0]segments;
    reg [2:0]counter;
    
    always@(posedge V_BT[3] or posedge V_SW[17])
    begin
        if(V_SW[17])
            counter[0] = 1;
        else
            counter[0] <= ~counter[0];
    end
    
    always@(posedge counter[0] or posedge V_SW[17])
    begin
        if(V_SW[17])
            counter[1] = 1;
        else
            counter[1] <= ~counter[1];
    end    
    
    always@(posedge counter[1] or posedge V_SW[17])
    begin
        if(V_SW[17])
            counter[2] = 1;
        else
            counter[2] <= ~counter[2];
    end    
    
    always @*
        case ({counter[2], counter[1], counter[0]})
            3'd0: segments = 7'b0001111; //7
            3'd1: segments = 7'b0100000; //6
            3'd2: segments = 7'b0100100; //5
            3'd3: segments = 7'b1001100; //4
            3'd4: segments = 7'b0000110; //3
            3'd5: segments = 7'b0010010; //2
            3'd6: segments = 7'b1001111; //1
            3'd7: segments = 7'b0000001; //0
            default: segments = 7'b1111111; //off
        endcase
    
    assign G_HEX4 = segments;
    
endmodule