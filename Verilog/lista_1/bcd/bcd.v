module bcd(w,x,y,z,a,b,c,d,e,f,g);
    input wire w,x,y,z;
    output wire a,b,c,d,e,f,g;
    
    wire [0:3] switches;
    reg [0:6] segments;
    
    assign switches = {w,x,y,z};
    
    always @(*)
    case (switches[0:3])
        4'b0000: segments=7'b0000001; //0
        4'b1000: segments=7'b1001111; //1
        4'b0100: segments=7'b0010010; //2
        4'b1100: segments=7'b0000110; //3
        4'b0010: segments=7'b1001100; //4
        4'b1010: segments=7'b0100100; //5
        4'b0110: segments=7'b0100000; //6
        4'b1110: segments=7'b0001111; //7
        4'b0001: segments=7'b0000000; //8
        4'b1001: segments=7'b0000100; //9
        default: segments = 7'b1111111; //off
    endcase
    
    assign {a,b,c,d,e,f,g} = segments;

endmodule