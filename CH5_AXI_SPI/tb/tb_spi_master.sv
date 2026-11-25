`timescale 1ns / 1ps

module tb_spi_master;

    // tb signals
    logic       i_clk;
    logic       i_rst_n;
    // internal signals
    logic [7:0] i_clk_div;
    logic       i_start;
    logic [7:0] i_tx_data;
    logic [7:0] o_rx_data;
    logic       o_busy;
    logic       o_done;
    // external ports
    logic       o_sclk;
    // logic       o_mosi;
    // logic       i_miso;
    logic       o_ss_n;
    // loop
    logic       w_loop;

    // spi_master instantiation
    spi_master DUT (
        .*,
        .o_mosi(w_loop),
        .i_miso(w_loop)
    );

    // clk generation
    initial i_clk = 1'b0;
    always #5 i_clk = ~i_clk;

    // task for sending data
    task spi_send_data(logic [7:0] data);
        i_tx_data = data;
        i_start   = 1'b1;
        @(posedge i_clk);
        i_start = 1'b0;
        wait (o_done);
        @(posedge i_clk);
    endtask

    // test scenario
    initial begin
        i_rst_n = 1'b0;
        repeat (5) @(posedge i_clk);
        i_rst_n = 1'b1;
        repeat (3) @(posedge i_clk);

        i_clk_div = 4;  // SCLK = 10Mbps        
        @(posedge i_clk);
        spi_send_data(8'hAA);

        repeat (10) @(posedge i_clk);
        $finish;
    end

endmodule
