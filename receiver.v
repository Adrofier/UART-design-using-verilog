
// RECEIVER MODULE WHICH SAMPLES THE INPUT DATA ACCORDING TO THE BAUD CLOCK.

module receiver(input wire rx,
		output reg ready,
		input wire ready_clr,
		input wire clk_50mhz,
		input wire clken,
		output reg [7:0] data);

initial begin
	ready = 0;
	data = 8'b0;
end

parameter RX_STATE_START	= 2'b00;
parameter RX_STATE_DATA		= 2'b01;
parameter RX_STATE_STOP		= 2'b10;

reg [1:0] state = RX_STATE_START;
reg [3:0] sample = 0;
reg [3:0] bit_position = 0;
reg [7:0] scratch = 8'b0;

always @(posedge clk_50mhz) begin
	if (ready_clr)
		ready <= 0;

	if (clken) begin
		case (state)
		
    RX_STATE_START: begin
			
			if (!rx || sample != 0)
				sample <= sample + 4'b1;

			if (sample == 15) begin
				state <= RX_STATE_DATA;
				bit_position <= 0;
				sample <= 0;
				scratch <= 0;
			end
		end
		
    RX_STATE_DATA: begin
			sample <= sample + 4'b1;
			if (sample == 4'h8) begin
				scratch[bit_position[2:0]] <= rx;
				bit_position <= bit_position + 4'b1;
			end
			if (bit_position == 8 && sample == 15)
				state <= RX_STATE_STOP;
		end
		
    RX_STATE_STOP: begin
			
      if (sample == 15 || (sample >= 8 && !rx)) begin
				state <= RX_STATE_START;
				data <= scratch;
				ready <= 1'b1;
				sample <= 0;
			end else begin
				sample <= sample + 4'b1;
			end
		end
		
    default: begin
			state <= RX_STATE_START;
		end
		endcase
	end
end

endmodule
