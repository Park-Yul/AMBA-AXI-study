`timescale 1ns / 1ps

// tb_uart
module tb_uart;
    parameter CLK_FREQ = 100_000_000;
    parameter BAUD_RATE = 115_200;

    logic       i_clk;
    logic       i_rst_n;
    // TX internal signal
    logic [7:0] i_tx_data;
    logic       i_tx_start;
    logic       o_tx_busy;
    logic       o_tx_done;
    // TX external_prot
    logic       o_tx;
    // RX internal signal
    logic [7:0] o_rx_data;
    logic       o_rx_done;
    // RX external port
    logic       i_rx;

    // logic    
    logic       w_loop;
    logic   [7:0]   uart_data;

    // uart instantiation
    uart #(
        .CLK_FREQ (100_000_000),
        .BAUD_RATE(115_200)
    ) DUT (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        // TX internal signal
        .i_tx_data(i_tx_data),
        .i_tx_start(i_tx_start),
        .o_tx_busy(o_tx_busy),
        .o_tx_done(o_tx_done),
        // TX external_prot
        .o_tx(w_loop),
        // RX internal signal
        .o_rx_data(o_rx_data),
        .o_rx_done(o_rx_done),
        // RX external port
        .i_rx(w_loop)
    );

    // task
    task UART_WriteData(logic [7:0] data);
        @(posedge i_clk);
        wait(!o_tx_busy);
        i_tx_data <= data;
        i_tx_start <= 1'b1;
        @(posedge i_clk);
        i_tx_start <= 1'b0;
        wait(o_tx_done);
        @(posedge i_clk);
        $strobe("[%t] TX Done! Data = %x", $time, i_tx_data);
    endtask

    // scenario
    initial i_clk = 1'b0;
    always #5 i_clk = ~i_clk;

    initial begin
        i_rst_n = 1'b0;
        repeat(5) @(posedge i_clk);
        i_rst_n = 1'b1;
        repeat(2) @(posedge i_clk);

        uart_data = 8'b1010_1010;
        UART_WriteData(uart_data);
        
        uart_data = 8'b0101_0101;
        UART_WriteData(uart_data);

        uart_data = 8'b1100_1100;
        UART_WriteData(uart_data);

        uart_data = 8'b0011_0011;
        UART_WriteData(uart_data);

        $finish;
    end

endmodule
