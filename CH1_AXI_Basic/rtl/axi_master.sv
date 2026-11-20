`timescale 1ns/1ps

module axi_master(
  input   logic         ACLK,
  input   logic         ARESETn,
  // internal signals
  input   logic         transfer,
  output  logic         ready,
  input   logic [31:0]  addr,
  input   logic [31:0]  wdata,
  output  logic [31:0]  rdata,
  input   logic         write,
  // AW channel
  output  logic [31:0]  AWADDR,
  output  logic         AWVALID,
  input   logic         AWREADY,
  // W channel
  output  logic [31:0]  WDATA,
  output  logic         WVALID,
  input   logic         WREADY,
  // B channel
  input   logic [1:0]   BRESP,
  input   logic         BVALID,
  output  logic         BREADY,
  // AR channel
  output  logic [31:0]  ARADDR,
  output  logic         ARVALID,
  input   logic         ARREADY,
  // R channel
  input   logic [31:0]  RDATA,
  input   logic         RVALID,
  output  logic         RREADY,
  input   logic [1:0]   RRESP
);

/******  Write Transaction ******/

// logic
logic w_ready, r_ready;

// CL(assign)
assign ready = w_ready | r_ready;

// AW Channel
// logic(typedef)
typedef enum logic{
  AW_IDLE = 1'b0,
  AW_VALID
}aw_state_e;

// logic(state)
aw_state_e c_aw_state, n_aw_state;

// CL
always_comb begin
AWADDR = addr;
AWVALID = 1'b0;
n_aw_state = c_aw_state;
  case(c_aw_state) 
    AW_IDLE : begin
      if(transfer & write) begin
        n_aw_state = AW_VALID;
      end
      AWVALID = 1'b0;
    end
    AW_VALID : begin
      if(AWREADY) begin
        n_aw_state = AW_IDLE;
      end
      AWADDR = addr;
      AWVALID = 1'b1;
    end
    default :;
  endcase
end

// SL
always_ff @ (posedge ACLK) begin
  if(!ARESETn) begin
    c_aw_state <= AW_IDLE;
  end
  else begin
    c_aw_state <= n_aw_state;
  end
end

// W Channel
// logic(typedef)
typedef enum logic{
  W_IDLE = 0,
  W_VALID
}w_state_e;

// logic(state)
w_state_e c_w_state, n_w_state;

// CL
always_comb begin
WDATA = wdata;
WVALID = 1'b0;
n_w_state = c_w_state;
  case(c_w_state) 
    W_IDLE : begin
      if(transfer && write) begin
        n_w_state = W_VALID;
      end
      WVALID = 1'b0;
    end
    W_VALID : begin
      if(WREADY) begin
        n_w_state = W_IDLE;
      end
      WDATA = wdata;
      WVALID = 1'b1;
    end

  endcase
end

// SL
always_ff @ (posedge ACLK) begin
  if(!ARESETn) begin
    c_w_state <= W_IDLE;
  end
  else begin
    c_w_state <= n_w_state;
  end
end


// B Channel
// logic(typedef)
typedef enum logic{
  B_IDLE = 0,
  B_READY
}b_state_e;

// logic(state)
b_state_e c_b_state, n_b_state;

// CL
always_comb begin
BREADY = 1'b0;
w_ready = 1'b0;
n_b_state = c_b_state;
  case(c_b_state) 
    B_IDLE : begin
      if(WVALID) begin
        n_b_state = B_READY;
      end
      BREADY = 1'b0;
    end
    B_READY : begin
      if(BVALID && BREADY) begin
        n_b_state = B_IDLE;
        w_ready = 1'b1;
      end
      BREADY = 1'b1;
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

/****** Read Transaction ******/

// AR Channel
// logic(typedef)
typedef enum logic{
  AR_IDLE = 1'b0,
  AR_VALID
} ar_state_e;

// logic(state)
ar_state_e c_ar_state, n_ar_state;

// CL
always_comb begin
  n_ar_state = c_ar_state;
  ARADDR = addr;
  ARVALID = 1'b0;
  case(c_ar_state)
  AR_IDLE : begin
    if(transfer && (!write)) begin
      n_ar_state = AR_VALID;
    end
    ARVALID = 1'b0;
  end
  AR_VALID : begin
    if(ARREADY) begin
      n_ar_state = AR_IDLE;
    end
    ARADDR = addr;
    ARVALID = 1'b1;
  end

  endcase
end

// SL
always_ff @ (posedge ACLK) begin
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
  R_IDLE = 0,
  R_READY
}r_state_e;

// logic(state)
r_state_e c_r_state, n_r_state;

// CL
always_comb begin
  n_r_state = c_r_state;
  r_ready = 1'b0;
  rdata = RDATA; 
  RREADY = 1'b0;
  case (c_r_state)
    R_IDLE : begin
      if(ARVALID) begin
        n_r_state = R_READY;
      end
      RREADY = 1'b0;
    end
    R_READY : begin
      if(RVALID) begin
        n_r_state = R_IDLE;
        r_ready = 1'b1;
      end
    rdata = RDATA;
    RREADY = 1'b1;
    end

  endcase
end

// SL
always @ (posedge ACLK) begin
  if(!ARESETn) begin
    c_r_state <= R_IDLE;
  end
  else begin
    c_r_state <= n_r_state;
  end
end
endmodule
