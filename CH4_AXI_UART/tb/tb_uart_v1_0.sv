`timescale 1ns / 1ps

module tb_uart_v1_0;

    parameter integer C_S00_AXI_DATA_WIDTH = 32;
    parameter integer C_S00_AXI_ADDR_WIDTH = 4;

    // clk & rst
    wire s00_axi_aclk;
    wire s00_axi_aresetn;
    // AW
    reg [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr;
    reg [2 : 0] s00_axi_awprot;
    reg s00_axi_awvalid;
    wire s00_axi_awready;
    //W
    reg [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata;
    reg [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb;
    reg s00_axi_wvalid;
    wire s00_axi_wready;
    // B
    wire [1 : 0] s00_axi_bresp;
    wire s00_axi_bvalid;
    reg s00_axi_bready;
    // AR
    reg [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr;
    reg [2 : 0] s00_axi_arprot;
    reg s00_axi_arvalid;
    wire s00_axi_arready;
    // R
    wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata;
    wire [1 : 0] s00_axi_rresp;
    wire s00_axi_rvalid;
    reg s00_axi_rready;

    reg i_clk;
    reg i_reset_n;
    wire w_loop;
    wire o_intr;

    assign s00_axi_aclk = i_clk;
    assign s00_axi_aresetn = i_reset_n;

    // uart_v1_0 instantiation
    uart_v1_0 DUT (
        .*,
        .o_tx(w_loop),
        .i_rx(w_loop)
    );

    // clock generation
    initial i_clk = 1'b0;
    always #5 i_clk = ~i_clk;

    // Write Task
    task AXI_WriteData(logic [31:0] addr, logic [31:0] data);
        @(posedge i_clk);
        // AW
        s00_axi_awaddr  <= addr;
        s00_axi_awvalid <= 1'b1;
        // W
        s00_axi_wdata   <= data;
        s00_axi_wstrb   <= 4'b1111;
        s00_axi_wvalid  <= 1'b1;
        // B
        s00_axi_bready  <= 1'b1;
        @(posedge i_clk);
        wait (s00_axi_awready && s00_axi_wready);
        @(posedge i_clk);
        s00_axi_awvalid <= 1'b0;
        s00_axi_wvalid  <= 1'b0;
        @(posedge i_clk);
        wait (s00_axi_bvalid);
        @(posedge i_clk);
        s00_axi_bready <= 1'b0;
        @(posedge i_clk);
    endtask

    // Read Task
    task AXI_ReadData(logic [31:0] addr, logic [31:0] rdata);
        @(posedge i_clk);
        // AR
        s00_axi_araddr  <= addr;
        s00_axi_arvalid <= 1'b1;
        // R
        s00_axi_rready  <= 1'b1;
        wait (s00_axi_arready);
        @(posedge i_clk);
        s00_axi_arvalid <= 1'b0;
        wait (s00_axi_rvalid);
        @(posedge i_clk);
        s00_axi_rready <= 1'b0;
        rdata <= s00_axi_rdata;
        @(posedge i_clk);
    endtask

    // localparam
    localparam SR_ADDR = 32'h0000_0000;
    localparam TDR_ADDR = 32'h0000_0004;
    localparam RDR_ADDR = 32'h0000_0008;
    localparam CR_ADDR = 32'h0000_000C;
    logic [31:0] r_sr, r_tdr, r_rdr, r_cr;

    // test scenario
    initial begin
        i_reset_n = 1'b0;
        repeat (5) @(posedge i_clk);
        i_reset_n = 1'b1;
        repeat (3) @(posedge i_clk);

        do begin
            AXI_ReadData(SR_ADDR, r_sr);
        end while (r_sr & (1 << 0));
        r_tdr = 32'h0000_00AA;
        AXI_WriteData(TDR_ADDR, r_tdr);
        do begin
            AXI_ReadData(SR_ADDR, r_sr);
        end while (!(r_sr & (1 << 1)));
        AXI_ReadData(RDR_ADDR, r_rdr);

        repeat (5) @(posedge i_clk);
        $finish;
    end
endmodule
