
// THIS BUAD RATE GENERATOR DIVIDES THE 50MHZ CLOCK INTO A BAUD OF 115200.
// AND THE RX/TX CLOCK IS OVERSAMPLED 16x AS RX CLOCK ENABLE.

module baud_rate
        (input wire clk_50mhz,
		     output wire rxclk_en,
		     output wire txclk_en);

parameter RX_MAX = 50000000 / (115200 * 16);   // 50MHZ TO 115200 BAUD
parameter TX_MAX = 50000000 / 115200;

parameter RX_WIDTH = $clog2(RX_MAX);  // CEILING OF BASE LOG 2 TO CALCULATE NO. OF BITS REQUIRED
parameter TX_WIDTH = $clog2(TX_MAX);

reg [RX_WIDTH - 1:0] rx_acc = 0;
reg [TX_WIDTH - 1:0] tx_acc = 0;

assign rxclk_en = (rx_acc == 5'd0);
assign txclk_en = (tx_acc == 9'd0);

always @(posedge clk_50mhz) begin
	if (rx_acc == RX_MAX[RX_WIDTH - 1:0])
		rx_acc <= 0;
	else
		rx_acc <= rx_acc + 5'b1;
end

always @(posedge clk_50mhz) begin
	if (tx_acc == TX_MAX[TX_WIDTH - 1:0])
		tx_acc <= 0;
	else
		tx_acc <= tx_acc + 9'b1;
end

endmodule
