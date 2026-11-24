`timescale 1ns / 1ps

// uart
module uart #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 115_200
) (
    input  wire       i_clk,
    input  wire       i_rst_n,
    // TX internal signal
    input  wire [7:0] i_tx_data,
    input  wire       i_tx_start,
    output wire       o_tx_busy,
    output wire       o_tx_done,
    // TX external_prot
    output wire       o_tx,
    // RX internal signal
    output wire [7:0] o_rx_data,
    output wire       o_rx_done,
    // RX external port
    input  wire       i_rx
);

    // wire, reg

    // uart_tx instantiation
    uart_tx #(
        .CLK_FREQ (100_000_000),
        .BAUD_RATE(115_200)
    ) U_UART_TX (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_tx_data(i_tx_data),
        .i_tx_start(i_tx_start),
        .o_tx_busy(o_tx_busy),
        .o_tx_done(o_tx_done),
        .o_tx(o_tx)
    );

    // uart_rx instantiation
    uart_rx#(
        .CLK_FREQ (100_000_000),
        .BAUD_RATE(115_200)
    )U_UART_RX(
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .o_rx_data(o_rx_data),
        .o_rx_done(o_rx_done),
        .i_rx(i_rx)
    );

endmodule

// uart_tx
module uart_tx #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 115_200
) (
    input  wire       i_clk,
    input  wire       i_rst_n,
    // internal signal
    input  wire [7:0] i_tx_data,
    input  wire       i_tx_start,
    output wire       o_tx_busy,
    output wire       o_tx_done,
    // external_prot
    output wire       o_tx
);
    // localparam
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam S_IDLE = 2'd0;
    localparam S_START = 2'd1;
    localparam S_DATA = 2'd2;
    localparam S_STOP = 2'd3;

    // wire, reg
    reg r_tx, r_tx_busy, r_tx_done;
    reg [                         1:0] r_state;
    reg [$clog2(CLKS_PER_BIT) - 1 : 0] r_clk_cnt;
    reg [                         2:0] r_bit_idx;
    reg [                         7:0] r_tx_data;

    // CL(assign)
    assign o_tx = r_tx;
    assign o_tx_busy = r_tx_busy;
    assign o_tx_done = r_tx_done;

    // SL
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_state   <= S_IDLE;
            r_tx      <= 1'b1;
            r_tx_busy <= 1'b0;
            r_tx_done <= 1'b0;
            r_clk_cnt <= 0;
            r_bit_idx <= 0;
            r_tx_data <= 0;
        end else begin
            case (r_state)
                S_IDLE: begin
                    r_tx      <= 1'b1;
                    r_tx_busy <= 1'b0;
                    r_tx_done <= 1'b0;
                    r_tx_data <= 0;
                    if (i_tx_start) begin
                        r_state   <= S_START;
                        r_tx_data <= i_tx_data;
                        r_tx_busy <= 1'b1;
                        r_clk_cnt <= 0;
                    end
                end

                S_START: begin
                    r_tx <= 0;
                    if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                        r_clk_cnt <= 1'b0;
                        r_bit_idx <= 1'b0;
                        r_state   <= S_DATA;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end

                S_DATA: begin
                    r_tx <= r_tx_data[r_bit_idx];
                    if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                        r_clk_cnt <= 1'b0;
                        if (r_bit_idx == 3'd7) begin
                            r_state <= S_STOP;
                        end else begin
                            r_bit_idx <= r_bit_idx + 1;
                        end
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end

                // S_D1: begin
                //     r_tx <= r_tx_data[1];
                //     if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                //         r_clk_cnt <= 1'b0;
                //         r_state   <= S_D2;
                //     end else begin
                //         r_clk_cnt <= r_clk_cnt + 1;
                //     end
                // end

                // S_D2: begin
                //     r_tx <= r_tx_data[2];
                //     if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                //         r_clk_cnt <= 1'b0;
                //         r_state   <= S_D3;
                //     end else begin
                //         r_clk_cnt <= r_clk_cnt + 1;
                //     end
                // end

                // S_D3: begin
                //     r_tx <= r_tx_data[3];
                //     if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                //         r_clk_cnt <= 1'b0;
                //         r_state   <= S_D4;
                //     end else begin
                //         r_clk_cnt <= r_clk_cnt + 1;
                //     end
                // end

                // S_D4: begin
                //     r_tx <= r_tx_data[4];
                //     if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                //         r_clk_cnt <= 1'b0;
                //         r_state   <= S_D5;
                //     end else begin
                //         r_clk_cnt <= r_clk_cnt + 1;
                //     end
                // end

                // S_D5: begin
                //     r_tx <= r_tx_data[5];
                //     if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                //         r_clk_cnt <= 1'b0;
                //         r_state   <= S_D6;
                //     end else begin
                //         r_clk_cnt <= r_clk_cnt + 1;
                //     end
                // end

                // S_D6: begin
                //     r_tx <= r_tx_data[6];
                //     if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                //         r_clk_cnt <= 1'b0;
                //         r_state   <= S_D7;
                //     end else begin
                //         r_clk_cnt <= r_clk_cnt + 1;
                //     end
                // end

                // S_D7: begin
                //     r_tx <= r_tx_data[7];
                //     if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                //         r_clk_cnt <= 1'b0;
                //         r_state   <= S_STOP;
                //     end else begin
                //         r_clk_cnt <= r_clk_cnt + 1;
                //     end
                // end

                S_STOP: begin
                    r_tx <= 1'b1;
                    if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                        r_clk_cnt <= 1'b0;
                        r_tx_busy <= 1'b0;
                        r_tx_done <= 1'b1;
                        r_state   <= S_IDLE;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end

                default: begin
                    r_state <= S_IDLE;
                end
            endcase
        end
    end

endmodule

// uart_rx
module uart_rx #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 115_200
) (
    input  wire       i_clk,
    input  wire       i_rst_n,
    // internal signal
    output wire [7:0] o_rx_data,
    output wire       o_rx_done,
    // external port
    input  wire       i_rx
);
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam HALF_BIT = CLKS_PER_BIT / 2;
    localparam S_IDLE = 2'd0;
    localparam S_START = 2'd1;
    localparam S_DATA = 2'd2;
    localparam S_STOP = 2'd3;

    // wire, reg
    reg r_rx_z, r_rx_zz;  // synchronizer
    reg                                r_rx_done;
    reg [                         1:0] r_state;
    reg [$clog2(CLKS_PER_BIT) - 1 : 0] r_clk_cnt;
    reg [                         2:0] r_bit_idx;
    reg [                         7:0] r_rx_data;

    // CL(assign)
    assign o_rx_data = r_rx_data;
    assign o_rx_done = r_rx_done;

    // SL(for sync)
    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_rx_z  <= 1'b1;
            r_rx_zz <= 1'b1;
        end else begin
            r_rx_z  <= i_rx;
            r_rx_zz <= r_rx_z;
        end
    end

    // SL
    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_rx_done <= 1'b0;
            r_state   <= S_IDLE;
            r_clk_cnt <= 0;
            r_bit_idx <= 0;
            r_rx_data <= 0;
        end else begin
            case (r_state)
                S_IDLE: begin
                    r_rx_done <= 1'b0;
                    if (!r_rx_zz) begin
                        r_clk_cnt <= 0;
                        r_state   <= S_START;
                    end
                end

                S_START: begin
                    if (r_clk_cnt == (HALF_BIT - 1)) begin
                        r_clk_cnt <= 1'b0;
                        r_bit_idx <= 0;
                        r_state   <= S_DATA;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end

                S_DATA: begin
                    if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                        r_clk_cnt <= 0;
                        r_rx_data[r_bit_idx] <= r_rx_zz;
                        if (r_bit_idx == 3'd7) begin
                            r_bit_idx <= 0;
                            r_state   <= S_STOP;
                        end else begin
                            r_bit_idx <= r_bit_idx + 1;
                        end
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end

                S_STOP: begin
                    if (r_clk_cnt == (CLKS_PER_BIT - 1)) begin
                        r_clk_cnt <= 0;
                        r_rx_done <= 1'b1;
                        r_state   <= S_IDLE;
                    end else begin
                        r_clk_cnt <= r_clk_cnt + 1;
                    end
                end

                default: begin
                    r_state <= S_IDLE;
                end
            endcase
        end
    end
endmodule
