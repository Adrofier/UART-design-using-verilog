
// TOP LEVEL MODULE FOR UART
// INSTANTIATES THE TRANSMITTER, RECEIVER, AND BAUD RATE GENERATOR MODULE
// ALL THE PORTS DEFINED IN MODULE LINKED WITH SUB_MODULES

module uart(input wire [7:0] data_in,
	    input wire write_enable,
	    input wire clk_50mhz,
	    output wire tx,
	    output wire tx_busy,
	    input wire rx,
	    output wire ready,
	    input wire ready_clr,
	    output wire [7:0] data_out);

wire rxclk_en, txclk_en;

baud_rate br(.clk_50mhz(clk_50mhz),
	     .rxclk_en(rxclk_en),
	     .txclk_en(txclk_en));

transmitter tx(.data_in(data_in),
	       .write_enable(write_enable),
	       .clk_50mhz(clk_50mhz),
	       .clken(txclk_en),
	       .tx(tx),
	       .tx_busy(tx_busy));

receiver rx(.rx(rx),
	    .ready(ready),
	    .ready_clr(ready_clr),
	    .clk_50mhz(clk_50mhz),
  	    .clken(rxclk_en),
	    .data(data_out));

endmodule
