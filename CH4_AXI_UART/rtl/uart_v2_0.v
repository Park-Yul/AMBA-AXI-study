
`timescale 1 ns / 1 ps

module uart_v2_0 #(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line


    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter integer C_S00_AXI_DATA_WIDTH = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH = 4
) (
    // Users to add ports here
    output wire o_tx,
    input  wire i_rx,
    output wire o_intr,
    // User ports ends
    // Do not modify the ports beyond this line


    // Ports of Axi Slave Bus Interface S00_AXI
    input wire s00_axi_aclk,
    input wire s00_axi_aresetn,
    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
    input wire [2 : 0] s00_axi_awprot,
    input wire s00_axi_awvalid,
    output wire s00_axi_awready,
    input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
    input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
    input wire s00_axi_wvalid,
    output wire s00_axi_wready,
    output wire [1 : 0] s00_axi_bresp,
    output wire s00_axi_bvalid,
    input wire s00_axi_bready,
    input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
    input wire [2 : 0] s00_axi_arprot,
    input wire s00_axi_arvalid,
    output wire s00_axi_arready,
    output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
    output wire [1 : 0] s00_axi_rresp,
    output wire s00_axi_rvalid,
    input wire s00_axi_rready
);
    // my code begin
    // TX singnal
    wire w_tx_start;
    wire [7:0] w_tx_data;
    wire w_tx_busy;
    wire w_tx_done;
    // RX signal
    wire [7:0] w_rx_data;
    wire w_rx_done;
    // interrupt singal
    wire w_rx_ie;

    assign o_intr = w_rx_ie & w_rx_done;
    // my code end


    // Instantiation of Axi Bus Interface S00_AXI
    uart_v2_0_S00_AXI #(
        .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
    ) U_UART_V2_0_S00_AXI_inst (
        .S_AXI_ACLK(s00_axi_aclk),
        .S_AXI_ARESETN(s00_axi_aresetn),
        // my code begin
        // TX signal
        .o_tx_start(w_tx_start),
        .o_tx_data(w_tx_data),
        .i_tx_busy(w_tx_busy),
        .i_tx_done(w_tx_done),
        // RX signal
        .i_rx_data(w_rx_data),
        .i_rx_done(w_rx_done),
        // interrupt signal
        .o_rx_ie(w_rx_ie),
        // my code end
        // AW Channel
        .S_AXI_AWADDR(s00_axi_awaddr),
        .S_AXI_AWPROT(s00_axi_awprot),
        .S_AXI_AWVALID(s00_axi_awvalid),
        .S_AXI_AWREADY(s00_axi_awready),
        // W Channel
        .S_AXI_WDATA(s00_axi_wdata),
        .S_AXI_WSTRB(s00_axi_wstrb),
        .S_AXI_WVALID(s00_axi_wvalid),
        .S_AXI_WREADY(s00_axi_wready),
        // B Channel
        .S_AXI_BRESP(s00_axi_bresp),
        .S_AXI_BVALID(s00_axi_bvalid),
        .S_AXI_BREADY(s00_axi_bready),
        // AR Channel
        .S_AXI_ARADDR(s00_axi_araddr),
        .S_AXI_ARPROT(s00_axi_arprot),
        .S_AXI_ARVALID(s00_axi_arvalid),
        .S_AXI_ARREADY(s00_axi_arready),
        // R Channel
        .S_AXI_RDATA(s00_axi_rdata),
        .S_AXI_RRESP(s00_axi_rresp),
        .S_AXI_RVALID(s00_axi_rvalid),
        .S_AXI_RREADY(s00_axi_rready)
    );

    // Add user logic here

    uart U_UART (
        .i_clk(s00_axi_aclk),
        .i_rst_n(s00_axi_aresetn),
        // TX internal signal
        .i_tx_data(w_tx_data),
        .i_tx_start(w_tx_start),
        .o_tx_busy(w_tx_busy),
        .o_tx_done(w_tx_done),
        // TX external port
        .o_tx(o_tx),
        // RX internal signal
        .o_rx_data(w_rx_data),
        .o_rx_done(w_rx_done),
        // RX external port
        .i_rx(i_rx)
    );
    // User logic ends

endmodule
