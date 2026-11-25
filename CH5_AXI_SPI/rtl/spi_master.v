`timescale 1ns / 1ps

module spi_master (
    input  wire       i_clk,
    input  wire       i_rst_n,
    // internal signals
    input  wire [7:0] i_clk_div,
    input  wire       i_start,
    input  wire [7:0] i_tx_data,
    output wire [7:0] o_rx_data,
    output wire       o_busy,
    output wire       o_done,
    // external ports
    output wire       o_sclk,
    output wire       o_mosi,
    input  wire       i_miso,
    output wire       o_ss_n
);

    // localparam
    localparam IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;

    // wire, reg
    // tick signal
    reg r_half_tick;
    reg [7:0] r_half_tick_cnt;
    // FSM
    reg [1:0] r_state;
    reg r_busy, r_done, r_sclk, r_mosi, r_ss_n;
    reg [7:0] r_tx_shift_reg, r_rx_shift_reg;
    reg [2:0] r_bit_cnt;
    reg r_step;
    reg [7:0] r_rx_data;
    reg [7:0] r_clk_div;

    // CL(assign)
    assign o_rx_data = r_rx_shift_reg;
    assign o_busy = r_busy;
    assign o_done = r_done;
    assign o_sclk = r_sclk;
    assign o_mosi = r_mosi;
    assign o_ss_n = r_ss_n;

    // SL(for r_half_tick, r_half_tick_cnt)
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_half_tick     <= 1'b0;
            r_half_tick_cnt <= 0;
        end else begin
            if (r_state == DATA) begin
                if (r_half_tick_cnt == r_clk_div) begin
                    r_half_tick     <= 1'b1;
                    r_half_tick_cnt <= 0;
                end else begin
                    r_half_tick     <= 1'b0;
                    r_half_tick_cnt <= r_half_tick_cnt + 1;
                end
            end else begin
                r_half_tick     <= 1'b0;
                r_half_tick_cnt <= 0;
            end
        end
    end

    // SL(FSM)
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_state        <= IDLE;
            r_busy         <= 1'b0;
            r_done         <= 1'b0;
            r_sclk         <= 1'b0;
            r_mosi         <= 1'b1;
            r_ss_n         <= 1'b1;
            r_tx_shift_reg <= 0;
            r_rx_shift_reg <= 0;
            r_bit_cnt      <= 0;
            r_step         <= 1'b0;
            r_rx_data      <= 0;
            r_clk_div      <= 0;
        end else begin
            case (r_state)
                IDLE: begin
                    r_busy <= 1'b0;
                    r_done <= 1'b0;
                    r_sclk <= 1'b0;
                    r_mosi <= 1'b1;
                    r_ss_n <= 1'b1;
                    if (i_start) begin
                        r_state        <= START;
                        r_busy         <= 1'b1;
                        r_ss_n         <= 1'b0;
                        r_tx_shift_reg <= i_tx_data;
                        r_bit_cnt      <= 0;
                        r_step         <= 1'b0;
                        r_clk_div      <= i_clk_div;
                    end
                end

                START: begin
                    r_state        <= DATA;
                    r_mosi         <= r_tx_shift_reg[7];
                    r_tx_shift_reg <= {r_tx_shift_reg[6:0], 1'b0};
                end

                DATA: begin
                    if (r_half_tick) begin
                        r_sclk <= ~r_sclk;
                        if (r_step == 1'b0) begin  //
                            r_rx_shift_reg <= {r_rx_shift_reg[6:0], i_miso};
                            r_step         <= 1'b1;
                        end else begin
                            r_step <= 1'b0;
                            if (r_bit_cnt < 7) begin
                                r_mosi         <= r_tx_shift_reg[7];
                                r_tx_shift_reg <= {r_tx_shift_reg[6:0], 1'b0};
                                r_bit_cnt      <= r_bit_cnt + 1;
                            end else begin
                                r_state   <= STOP;
                                r_rx_data <= r_rx_shift_reg;
                                r_bit_cnt <= 0;
                            end
                        end
                    end
                end

                STOP: begin
                    r_state <= IDLE;
                    r_done  <= 1'b1;
                    r_sclk  <= 1'b0;
                    r_mosi  <= 1'b1;
                    r_ss_n  <= 1'b1;
                    r_step  <= 1'b0;
                end

                default: begin
                    r_state <= IDLE;
                end
            endcase
        end
    end
endmodule
