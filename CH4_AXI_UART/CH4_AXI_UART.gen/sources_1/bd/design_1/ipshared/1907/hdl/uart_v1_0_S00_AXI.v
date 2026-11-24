
`timescale 1 ns / 1 ps

module uart_v1_0_S00_AXI #(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line

    // Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH = 4
) (
    // Users to add ports here
    // TX signal
    output wire [7:0] o_tx_data,
    output wire       o_tx_start,
    input  wire       i_tx_busy,
    input  wire       i_tx_done,
    // RX signal
    input  wire [7:0] i_rx_data,
    input  wire       i_rx_done,
    // User ports ends
    // Do not modify the ports beyond this line

    // Global Clock & Reset Signal
    input wire S_AXI_ACLK,
    input wire S_AXI_ARESETN,
    // AW Channel
    input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    input wire [2 : 0] S_AXI_AWPROT,
    input wire S_AXI_AWVALID,
    output wire S_AXI_AWREADY,
    // W Channel 
    input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    input wire S_AXI_WVALID,
    output wire S_AXI_WREADY,
    // B Channel
    output wire [1 : 0] S_AXI_BRESP,
    output wire S_AXI_BVALID,
    input wire S_AXI_BREADY,
    // AR Channel
    input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    input wire [2 : 0] S_AXI_ARPROT,
    input wire S_AXI_ARVALID,
    output wire S_AXI_ARREADY,
    // R Channel
    output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    output wire [1 : 0] S_AXI_RRESP,
    output wire S_AXI_RVALID,
    input wire S_AXI_RREADY
);

    // AXI4LITE signals
    // AW Channel
    reg [C_S_AXI_ADDR_WIDTH-1 : 0] axi_awaddr;
    reg axi_awready;
    // W Channel
    reg axi_wready;
    // B Channel
    reg [1 : 0] axi_bresp;
    reg axi_bvalid;
    // AR Channel
    reg [C_S_AXI_ADDR_WIDTH-1 : 0] axi_araddr;
    reg axi_arready;
    // R Channel
    reg [C_S_AXI_DATA_WIDTH-1 : 0] axi_rdata;
    reg [1 : 0] axi_rresp;
    reg axi_rvalid;
    // my code begin
    reg r_tx_start;
    // my code end

    // Example-specific design signals
    // local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
    // ADDR_LSB is used for addressing 32/64 bit registers/memories
    // ADDR_LSB = 2 for 32 bits (n downto 2)
    // ADDR_LSB = 3 for 64 bits (n downto 3)
    localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH / 32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 1;
    //----------------------------------------------
    //-- Signals for user logic register space example
    //------------------------------------------------
    //-- Number of Slave Registers 4
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg0;  // SR
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg1;  // TDR
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg2;  // RDR
    reg [C_S_AXI_DATA_WIDTH-1:0] slv_reg3;  // CR
    wire slv_reg_rden;
    wire slv_reg_wren;
    reg [C_S_AXI_DATA_WIDTH-1:0] reg_data_out;
    integer byte_index;
    reg aw_en;

    // I/O Connections assignments

    // AW Channel
    assign S_AXI_AWREADY = axi_awready;
    // W Channel
    assign S_AXI_WREADY = axi_wready;
    // B Channel
    assign S_AXI_BRESP = axi_bresp;
    assign S_AXI_BVALID = axi_bvalid;
    // AR Channel
    assign S_AXI_ARREADY = axi_arready;
    // R Channel
    assign S_AXI_RDATA = axi_rdata;
    assign S_AXI_RRESP = axi_rresp;
    assign S_AXI_RVALID = axi_rvalid;
    // my code begin
    assign o_tx_data = slv_reg1[7:0];
    assign o_tx_start = r_tx_start;
    // my code end
    // Implement axi_awready generation
    // axi_awready is asserted for one S_AXI_ACLK clock cycle when both
    // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
    // de-asserted when reset is low.

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_awready <= 1'b0;
            aw_en <= 1'b1;
        end else begin
            if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en && ~slv_reg0[0] ) begin
                // slave is ready to accept write address when 
                // there is a valid write address and write data
                // on the write address and data bus. This design 
                // expects no outstanding transactions. 
                axi_awready <= 1'b1;
                aw_en <= 1'b0;
            end else if (S_AXI_BREADY && axi_bvalid) begin
                aw_en <= 1'b1;
                axi_awready <= 1'b0;
            end else begin
                axi_awready <= 1'b0;
            end
        end
    end

    // Implement axi_awaddr latching
    // This process is used to latch the address when both 
    // S_AXI_AWVALID and S_AXI_WVALID are valid. 

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_awaddr <= 0;
        end else begin
            if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
                // Write Address latching 
                axi_awaddr <= S_AXI_AWADDR;
            end
        end
    end

    // Implement axi_wready generation
    // axi_wready is asserted for one S_AXI_ACLK clock cycle when both
    // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
    // de-asserted when reset is low. 

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_wready <= 1'b0;
        end else begin
            if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en) begin
                // slave is ready to accept write data when 
                // there is a valid write address and write data
                // on the write address and data bus. This design 
                // expects no outstanding transactions. 
                axi_wready <= 1'b1;
            end else begin
                axi_wready <= 1'b0;
            end
        end
    end

    // Implement memory mapped register select and write logic generation
    // The write data is accepted and written to memory mapped registers when
    // axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
    // select byte enables of slave registers while writing.
    // These registers are cleared when reset (active low) is applied.
    // Slave register write enable is asserted when valid address and data are available
    // and the slave is ready to accept the write address and write data.
    assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            // slv_reg0   <= 0;  // SR -> rd only
            slv_reg1   <= 0;  // TDR
            // slv_reg2   <= 0;  // SDR -> rd only
            slv_reg3   <= 0;  // CR
            // my code begin
            r_tx_start <= 1'b0;
            // my code end
        end else begin
            if (slv_reg_wren) begin
                case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
                    // 2'h0:  // SR
                    // for (
                    //     byte_index = 0;
                    //     byte_index <= (C_S_AXI_DATA_WIDTH / 8) - 1;
                    //     byte_index = byte_index + 1
                    // )
                    // if (S_AXI_WSTRB[byte_index] == 1) begin
                    //     // Respective byte enables are asserted as per write strobes 
                    //     // Slave register 0
                    //     slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    // end
                    2'h1: begin  // TDR
                        // my code begin
                        r_tx_start <= 1'b1;
                        // my code end
                        for (
                            byte_index = 0;
                            byte_index <= (C_S_AXI_DATA_WIDTH / 8) - 1;
                            byte_index = byte_index + 1
                        )
                        if (S_AXI_WSTRB[byte_index] == 1) begin
                            // Respective byte enables are asserted as per write strobes 
                            // Slave register 1
                            slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                        end
                    end
                    // 2'h2:
                    // for (
                    //     byte_index = 0;
                    //     byte_index <= (C_S_AXI_DATA_WIDTH / 8) - 1;
                    //     byte_index = byte_index + 1
                    // )
                    // if (S_AXI_WSTRB[byte_index] == 1) begin
                    //     // Respective byte enables are asserted as per write strobes 
                    //     // Slave register 2
                    //     slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    // end
                    2'h3:
                    for (
                        byte_index = 0;
                        byte_index <= (C_S_AXI_DATA_WIDTH / 8) - 1;
                        byte_index = byte_index + 1
                    )
                    if (S_AXI_WSTRB[byte_index] == 1) begin
                        // Respective byte enables are asserted as per write strobes 
                        // Slave register 3
                        slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                    end
                    default: begin
                        // slv_reg0   <= slv_reg0;
                        slv_reg1   <= slv_reg1;
                        // slv_reg2   <= slv_reg2;
                        slv_reg3   <= slv_reg3;
                        // my code begin
                        r_tx_start <= 0;
                        // my code end
                    end
                endcase
            end
        end
    end

    // my code begin
    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            slv_reg0 <= 0;
        end else begin
            if (i_tx_done) begin
                slv_reg0[0] <= 1'b0;
            end else if (~i_tx_done) begin
                if (i_tx_busy) begin
                    slv_reg0[0] <= 1'b1;
                end else if (~i_tx_busy) begin
                    slv_reg0[0] <= 1'b0;
                end
            end
			if(i_rx_done) begin
				slv_reg0[1] <= 1'b1;
			end
			else if(S_AXI_RREADY)begin
				slv_reg0[1] <= 1'b0;
			end
        end
    end

	always @ (posedge S_AXI_ACLK)begin
		if(!S_AXI_ARESETN)begin
			slv_reg2 <= 0;
		end
		else begin
			if(slv_reg0[1])begin
				slv_reg2[7 : 0] <= i_rx_data;
			end
		end	
	end

    // my code end

    // Implement write response logic generation
    // The write response and response valid signals are asserted by the slave 
    // when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
    // This marks the acceptance of address and indicates the status of 
    // write transaction.

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_bvalid <= 0;
            axi_bresp  <= 2'b0;
        end else begin
            if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
                // indicates a valid write response is available
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b0;  // 'OKAY' response 
            end                   // work error responses in future
	      else
	        begin
                if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
                    axi_bvalid <= 1'b0;
                end
            end
        end
    end

    // Implement axi_arready generation
    // axi_arready is asserted for one S_AXI_ACLK clock cycle when
    // S_AXI_ARVALID is asserted. axi_awready is 
    // de-asserted when reset (active low) is asserted. 
    // The read address is also latched when S_AXI_ARVALID is 
    // asserted. axi_araddr is reset to zero on reset assertion.

    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_arready <= 1'b0;
            axi_araddr  <= 32'b0;
        end else begin
            if (~axi_arready && S_AXI_ARVALID) begin
                // indicates that the slave has acceped the valid read address
                axi_arready <= 1'b1;
                // Read address latching
                axi_araddr  <= S_AXI_ARADDR;
            end else begin
                axi_arready <= 1'b0;
            end
        end
    end

    // Implement axi_arvalid generation
    // axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
    // S_AXI_ARVALID and axi_arready are asserted. The slave registers 
    // data are available on the axi_rdata bus at this instance. The 
    // assertion of axi_rvalid marks the validity of read data on the 
    // bus and axi_rresp indicates the status of read transaction.axi_rvalid 
    // is deasserted on reset (active low). axi_rresp and axi_rdata are 
    // cleared to zero on reset (active low).  
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_rvalid <= 0;
            axi_rresp  <= 0;
        end else begin
            if (axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
                // Valid read data is available at the read data bus
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b0;  // 'OKAY' response
            end else if (axi_rvalid && S_AXI_RREADY) begin
                // Read data is accepted by the master
                axi_rvalid <= 1'b0;
            end
        end
    end

    // Implement memory mapped register select and read logic generation
    // Slave register read enable is asserted when valid address is available
    // and the slave is ready to accept the read address.
    assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
    always @(*) begin
        // Address decoding for reading registers
        case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
            2'h0   : reg_data_out <= slv_reg0;
            2'h1   : reg_data_out <= slv_reg1;
            2'h2   : reg_data_out <= slv_reg2;
            2'h3   : reg_data_out <= slv_reg3;
            default : reg_data_out <= 0;
        endcase
    end

    // Output register or memory read data
    always @(posedge S_AXI_ACLK) begin
        if (S_AXI_ARESETN == 1'b0) begin
            axi_rdata <= 0;
        end else begin
            // When there is a valid read address (S_AXI_ARVALID) with 
            // acceptance of read address by the slave (axi_arready), 
            // output the read dada 
            if (slv_reg_rden) begin
                axi_rdata <= reg_data_out;  // register read data
            end
        end
    end

    // Add user logic here
    // User logic ends

endmodule

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
    uart_rx #(
        .CLK_FREQ (100_000_000),
        .BAUD_RATE(115_200)
    ) U_UART_RX (
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
