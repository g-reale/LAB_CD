module mealey(sel1,sel0,rst,clk,a,b,c,d,e,f,g,db0,db1,db2,db3,db4);
    
	 input wire rst,clk;
	 input wire sel1,sel0;
	 output a,b,c,d,e,f,g;
	 output db0,db1,db2,db3,db4;
	 
	 reg [3:0]state;
	 reg [3:0]result; 
	 reg [6:0]segments;
	 reg [25:0] divider;
    reg spike;
    
	 //clk divider
    always@(posedge clk) begin
        if(divider == 26'd50000000) begin
            spike <= 1;
            divider <= 0;
        end else begin
            spike <= 0;
            divider <= divider + 1;
        end
    end
	 
	 
	 //sync part
	 always@(posedge spike or posedge rst)begin
		if(rst)
			state <= 0;
		else begin
			case({sel1,sel0})
				2'd0: state <= state;
				
				2'd1: 
					begin	
						if(state == 4'b1001)
							state <= 0;
						else
							state <= state == 4'd0 ? 4'd8 : state - 1;
					end
				
				2'd2: 
					begin
						if(state == 4'b1001)
							state <= 0;
						else
							state <= state == 4'd8 ? 4'd0 : state + 1;
					end
					
				2'd3: state <= 4'b1001;
			endcase
		end
	 end
	 
	 assign {db3,db2,db1,db0} = state;
	 assign db4 = spike;
	 
	 //assync part
	 always@(state or sel0 or sel1)begin
		case({sel1,sel0})
			
			2'd0: result = state;

			2'd1: 
				begin	
					if(state == 4'b1001)
						result = 0;
					else
						result = state == 4'd0 ? 4'd8 : state - 1;
				end
			
			2'd2:
				begin
					if(state == 4'b1001)
						result = 0;
					else
						result = state == 4'd8 ? 4'd0 : state + 1;
				end
			
			2'd3: result = 4'b1001;
		endcase
	 end
	 
	 
	 //mapping to output
	 always @(result)begin
        case ({result[3],result[2], result[1], result[0]})
            4'd0: segments=7'b0010010; //2
				4'd1: segments=7'b0000000; //8
				4'd2: segments=7'b0000110; //3
				4'd3: segments=7'b1001100; //4
				4'd4: segments=7'b0100100; //5
				4'd5: segments=7'b1001100; //4
				4'd6: segments=7'b1001111; //1
				4'd7: segments=7'b0000001; //0
				4'd8: segments=7'b0001111; //7
				4'd9: segments=7'b1111111; //off
				default: segments = 7'b1111111; //off
        endcase
    end
    
    assign {a,b,c,d,e,f,g} = segments;
	 
endmodule