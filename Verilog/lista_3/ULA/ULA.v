module ULA(a3,a2,a1,a0,b3,b2,b1,b0,sel2,sel1,sel0,a,b,c,d,e,f,g,ld3,ld2,ld1,ld0);
    
	 input wire a3,a2,a1,a0;
	 input wire b3,b2,b1,b0;
	 input wire sel2,sel1,sel0;
	 output a,b,c,d,e,f,g;
	 output ld3,ld2,ld1,ld0;
	
	 wire [3:0]A;
	 assign A = {a3,a2,a1,a0};
	 
	 wire [3:0]B;
	 assign B = {b3,b2,b1,b0};
	
	 reg [3:0]result; 
	 reg [6:0]segments;
  
	 always@*begin
		case ({sel2,sel1,sel0})
			3'd0: result = A & B;
			3'd1: result = A | B;
			3'd2: result = A + B;
			3'd3: result = A - B;
			3'd4: result = A * B;
			3'd5: result = A / B;
			default: result = result;
		endcase
	 end
	 
	 always @(result)begin
        case ({result[3],result[2], result[1], result[0]})
            4'd7: segments = 7'b0001111; //7
            4'd6: segments = 7'b0100000; //6
            4'd5: segments = 7'b0100100; //5
            4'd4: segments = 7'b1001100; //4
            4'd3: segments = 7'b0000110; //3
            4'd2: segments = 7'b0010010; //2
            4'd1: segments = 7'b1001111; //1
            4'd0: segments = 7'b0000001; //0
            default: segments = 7'b1111111; //off
        endcase
    end
	 
	 assign {ld3,ld2,ld1,ld0} = result;
    assign {a,b,c,d,e,f,g} = segments;
    
endmodule