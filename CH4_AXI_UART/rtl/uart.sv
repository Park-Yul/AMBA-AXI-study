`timescale 1ns / 1ps

// uart
module uart (
    input logic i_clk,
    input logic i_rst,
    input logic [7:0] i_tx_data,
    input logic i_tx_start,
    input logic i_rx,
    output logic [7:0] o_rx_data,
    output logic o_tx_busy,
    output logic o_tx_done,
    output logic o_rx_busy,
    output logic o_rx_done,
    output logic o_tx
);
    // logic
    logic w_baud_tick;

    // uart_tx instantiation
    uart_tx U_UART_TX (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_tx_start(i_tx_start),
        .i_baud_tick(w_baud_tick),
        .i_tx_data(i_tx_data),
        .o_tx(o_tx),
        .o_tx_busy(o_tx_busy),
        .o_tx_done(o_tx_done)
    );

    // uart_rx instantiation
    uart_rx U_UART_RX (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_baud_tick(w_baud_tick),
        .i_rx(i_rx),
        .o_rx_busy(o_rx_busy),
        .o_rx_done(o_rx_done),
        .o_rx_data(o_rx_data)
    );

    // baud_tick_16 instantiation
    baud_tick_16 #(
        .SYS_CLK  (100000000),
        .BAUD_RATE(115200)
    ) U_BAUD_TICK_16 (
        .i_clk (i_clk),
        .i_rst (i_rst),
        .o_tick(w_baud_tick)
    );
endmodule

// uart_tx
module uart_tx (
    input logic i_clk,
    input logic i_rst,
    input logic i_tx_start,
    input logic i_baud_tick,
    input logic [7:0] i_tx_data,
    output logic o_tx,
    output logic o_tx_busy,
    output logic o_tx_done
);

    // logic
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } tx_state_e;

    tx_state_e c_tx_state, n_tx_state;

    logic [7:0] c_tx_data, n_tx_data;
    logic c_tick_count, n_tick_count;
    logic c_data_count, n_data_count;
    logic c_tx, n_tx;
    logic c_tx_busy, n_tx_busy;
    logic c_tx_done, n_tx_done;

    // CL
    always_comb begin
        n_tx_state = c_tx_state;
        n_tx_data = c_tx_data;
        n_tick_count = c_tick_count;
        n_data_count = c_data_count;
        n_tx = c_tx;
        n_tx_busy = c_tx_busy;
        n_tx_done = c_tx_done;
        case (c_tx_state)
            IDLE: begin
                n_tick_count = 0;
                n_data_count = 0;
                n_tx = 1;
                n_tx_busy = 0;
                n_tx_done = 0;
                if(i_tx_start) begin
                    n_tx_state = START;
                    n_tx_data = i_tx_data;
                    n_tx = 0;
                    n_tx_busy = 1;
                end
            end

            START: begin
                if(i_baud_tick) begin
                    n_tick_count ++;
                    if(n_tick_count == (16 - 1))begin
                        n_tx_state = DATA;
                        n_tick_count = 0;
                        n_tx = c_tx_data[0];
                    end
                end
            end

            DATA: begin
                
                ;
            end

            STOP: begin
            end

        endcase
    end
    // SL
    always_ff @(posedge i_clk) begin
        if (i_rst) begin

        end else begin

        end
    end

endmodule

// uart_rx
module uart_rx (
    input logic i_clk,
    input logic i_rst,
    input logic i_baud_tick,
    input logic i_rx,
    output logic o_rx_busy,
    output logic o_rx_done,
    output logic [7:0] o_rx_data
);

    // logic
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } rx_state_e;

    rx_state_e c_rx_state, n_rx_state;

    logic [7:0] c_rx_data, n_rx_data;
    logic c_tick_count, n_tick_count;
    logic c_rx_busy, n_rx_busy;
    logic c_rx_done, n_rx_done;

    // CL
    always_comb begin
        case (c_rx_state)
            IDLE: begin
            end

            START: begin
            end

            DATA: begin
            end

            STOP: begin
            end

        endcase
    end

    // SL
    always_ff @(posedge i_clk) begin
        if (i_rst) begin

        end else begin

        end
    end

endmodule

// baud_tick_16
module baud_tick_16 #(
    parameter SYS_CLK   = 100000000,
    parameter BAUD_RATE = 115200,
    parameter COUNT_MAX = SYS_CLK / BAUD_RATE / 16
) (
    input  logic i_clk,
    input  logic i_rst,
    output logic o_tick
);

    // logic
    logic [$clog2(COUNT_MAX) - 1 : 0] c_count;
    logic                             c_tick;


    // CL(assign)
    assign o_tick = c_tick;

    // SL
    always_ff @(posedge i_clk) begin
        if (i_rst) begin
            c_count <= 0;
            c_tick  <= 0;
        end else begin
            c_count <= c_count + 1;
            c_tick  <= 0;
            if (c_count == (COUNT_MAX - 1)) begin
                c_count <= 0;
                c_tick  <= 1;
            end
        end
    end
endmodule
