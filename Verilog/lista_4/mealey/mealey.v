module mealey(sel1,sel0,rst,clk,a,b,c,d,e,f,g,db0,db1,db2,db3,db4);
    
	 input wire rst,clk;
	 input wire sel1,sel0;
	 output a,b,c,d,e,f,g;
	 output db0,db1,db2,db3,db4;
	 
	 parameter A = 4'd0, B = 4'd1, C = 4'd2, D = 4'd3, E = 4'd4, F = 4'd5, G = 4'd6, H = 4'd7, I = 4'd8, J = 4'd9;
	 parameter S0 = 7'b0000001,S1 = 7'b1001111, S2 = 7'b0010010, S3 = 7'b0000110, S4 = 7'b1001100, S5 = 7'b0100100, S7 = 7'b0001111, S8 = 7'b0000000;
	 parameter SOFF = 7'b1111111;
	 
	 reg [3:0]stash;
	 reg [3:0]state;
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
	 
	 //next state and output
	 always @(sel0 or sel1 or state)begin
		if(sel1 == 0 && sel0 == 0) begin
			stash = state;
			case({state[3],state[2],state[1],state[0]})
				A: segments = S2;
				B: segments = S8;
				C: segments = S3;
				D: segments = S4;
				E: segments = S5;
				F: segments = S4;
				G: segments = S1;
				H: segments = S0;
				I: segments = S7;
				J: segments = SOFF;
				default: segments = SOFF;
			endcase
		end 
		
		else if(sel1 == 0 && sel0 == 1) begin
			case({state[3],state[2],state[1],state[0]})
				A: begin
					stash = I;
					segments = S7;
				end B: begin
					stash = A;
					segments = S2;
				end C: begin
					stash = B;
					segments = S8;
				end D: begin
					stash = C;
					segments = S3;
				end E: begin
					stash = D;
					segments = S4;
				end F: begin
					stash = E;
					segments = S5;
				end G: begin
					stash = F;
					segments = S4;
				end H: begin
					stash = G;
					segments = S1;
				end I: begin
					stash = H;
					segments = S0;
				end J: begin
					stash = A;
					segments = S2;
				end default: begin
					stash = J;
					segments = SOFF;
				end 
			endcase
		end
			
		else if(sel1 == 1 && sel0 == 0) begin
			case({state[3],state[2],state[1],state[0]})
				A: begin
					stash = B;
					segments = S8; 
				end B: begin
					stash = C;
					segments = S3;
				end C: begin
					stash = D;
					segments = S4;
				end D: begin
					stash = E;
					segments = S5;
				end E: begin
					stash = F;
					segments = S4;
				end F: begin
					stash = G;
					segments = S1;
				end G: begin
					stash = H;
					segments = S0;
				end H: begin
					stash = I;
					segments = S7;
				end I: begin
					stash = A;
					segments = S2;
				end J: begin
					stash = A;
					segments = S2;
				end default: begin
					stash = J;
					segments = SOFF;
				end
			endcase
		end 
		else if(sel1 == 1 && sel0 == 1) begin
			stash = J;
			segments = SOFF;
		end
	 end
	 
	 
	//comits or resets the state 
	always@(posedge spike or posedge rst)begin
		if(rst)
			state <= 0;
		else
			state <= stash;
	end
	 
	 assign {a,b,c,d,e,f,g} = segments;
	 assign {db3,db2,db1,db0} = state;
	 assign db4 = spike;
	 
endmodule