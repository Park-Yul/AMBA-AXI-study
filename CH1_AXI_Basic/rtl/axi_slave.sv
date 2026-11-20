`timescale 1ns/1ps

module axi_slave(
  input   logic         ACLK,
  input   logic         ARESETn,
  // AW channel
  input   logic [31:0]  AWADDR,
  input   logic         AWVALID,
  output  logic         AWREADY,
  // W channel
  input   logic [31:0]  WDATA,
  input   logic         WVALID,
  output  logic         WREADY,
  // B channel
  output  logic [1:0]   BRESP,
  output  logic         BVALID,
  input   logic         BREADY,
  // AR channel
  input   logic [31:0]  ARADDR,
  input   logic         ARVALID,
  output  logic         ARREADY,
  // R channel
  output   logic [31:0]  RDATA,
  output   logic         RVALID,
  input    logic         RREADY,
  output   logic [1:0]   RRESP
);

/****** Write Transaction ******/

// register file
logic [31:0] offset_reg [0:3];

// logic
logic [31:0] waddr_temp;
logic [31:0] raddr_temp;

// CL

// SL

// AW Channel
// logic(typedef)
typedef enum logic{
  AW_IDLE = 1'b0,
  AW_READY
}aw_state_e;

// logic(state)
aw_state_e c_aw_state, n_aw_state;

// CL
always_comb begin
  n_aw_state = c_aw_state;
  AWREADY = 1'b0;
  case (c_aw_state) 
    AW_IDLE : begin
      if(AWVALID) begin
        n_aw_state = AW_READY;
      end
      AWREADY = 1'b0;
    end
    AW_READY : begin
      n_aw_state = AW_IDLE;
      waddr_temp = AWADDR;
      AWREADY = 1'b1;  
    end
  endcase
end

// SL
always_ff @ (posedge ACLK) begin
  if (!ARESETn) begin
    c_aw_state <= AW_IDLE;
  end
  else begin
    c_aw_state <= n_aw_state;
  end
end

// W Channel
// logic(typedef)
typedef enum logic{
  W_IDLE = 1'b0,
  W_READY
}w_state_e;

// logic(state)
w_state_e c_w_state, n_w_state;

// CL
always_comb begin
  n_w_state = c_w_state;
  WREADY = 1'b0;
    case (c_w_state) 
      W_IDLE : begin
        if(WVALID && AWVALID && AWREADY) begin
          n_w_state = W_READY;
        end
        WREADY = 1'b0;
      end
      W_READY : begin
        n_w_state = W_IDLE;
        offset_reg[waddr_temp[3:2]] = WDATA;
        WREADY = 1'b1;
      end
    endcase
end

// SL
always_ff @ (posedge ACLK) begin
  if (!ARESETn) begin
    c_w_state <= W_IDLE;
  end
  else begin
    c_w_state <= n_w_state;     
  end
end

// B Channel
// logic(typedef)
typedef enum logic{
  B_IDLE = 1'b0,
  B_VALID 
}b_state_e;

// logic(state_
b_state_e c_b_state, n_b_state;

// CL
always_comb begin
  n_b_state = c_b_state;
  BRESP = 2'b00;
  BVALID = 1'b0;
  n_b_state = c_b_state;
  case (c_b_state)
    B_IDLE : begin
      if(WREADY) begin
        n_b_state = B_VALID;
      end
      BVALID = 1'b0;
    end
    B_VALID: begin
      if(BREADY) begin
        n_b_state = B_IDLE;
      end
      BRESP = 1'b00;
      BVALID = 1'b1;
    end
  endcase
end

// SL
always_ff @ (posedge ACLK) begin
  if(!ARESETn) begin
    c_b_state <= B_IDLE;
  end
  else begin
    c_b_state <= n_b_state;
  end
end


// AR Channel
// logic(typedef)
typedef enum logic{
  AR_IDLE = 1'b0,
  AR_READY
}ar_state_e;


// logic(state)
ar_state_e c_ar_state, n_ar_state;

// CL
always_comb begin
  n_ar_state = c_ar_state;
  ARREADY = 1'b0;
  case(c_b_state) 
    AR_IDLE:begin
      if(ARVALID) begin
        n_ar_state = AR_READY;
      end
      ARREADY = 1'b0;
    end
    AR_READY: begin
      n_ar_state = AR_IDLE;
      raddr_temp = ARADDR;
      ARREADY = 1'b1;      
    end
  endcase
end

// SL
always_ff @ (posedge ACLK)begin
  if(!ARESETn) begin
    c_ar_state <= AR_IDLE;
  end
  else begin
    c_ar_state <= n_ar_state;
  end
end


// R Channel

// logic(typedef)
typedef enum logic{
  R_IDLE = 1'b0,
  R_VALID
}r_state_e;

// assign
r_state_e c_r_state, n_r_state;

// CL
always_comb begin
  n_r_state = c_r_state;
  RDATA = 0;
  RRESP = 2'b00;
  RVALID = 1'b0;
  case(c_r_state)
  R_IDLE: begin
    if(ARREADY)begin
      n_r_state = R_VALID;
    end
    RVALID = 1'b0;
  end
  R_VALID: begin
    if(RREADY) begin
      n_r_state = R_IDLE;
    end
    RVALID = 1'b1;
    RRESP = 2'b00;
    RDATA = offset_reg[raddr_temp[3:2]];
  end
  endcase
end

// SL
always_ff @ (posedge ACLK) begin
  if (!ARESETn) begin
    c_r_state <= R_IDLE;
  end
  else begin
    c_r_state <= n_r_state;
  end
end

endmodule