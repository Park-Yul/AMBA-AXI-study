//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Tue Nov 24 15:57:02 2026
//Host        : DESKTOP-7CFQ9ND running 64-bit major release  (build 9200)
//Command     : generate_target uart_design_1_wrapper.bd
//Design      : uart_design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module uart_design_1_wrapper
   (i_rx,
    o_btn_tri_io,
    o_fnd_com_tri_io,
    o_fnd_data_tri_io,
    o_led_tri_io,
    o_sw_tri_io,
    o_tx,
    reset,
    sys_clock,
    usb_uart_rxd,
    usb_uart_txd);
  input i_rx;
  inout [3:0]o_btn_tri_io;
  inout [3:0]o_fnd_com_tri_io;
  inout [7:0]o_fnd_data_tri_io;
  inout [15:0]o_led_tri_io;
  inout [15:0]o_sw_tri_io;
  output o_tx;
  input reset;
  input sys_clock;
  input usb_uart_rxd;
  output usb_uart_txd;

  wire i_rx;
  wire [0:0]o_btn_tri_i_0;
  wire [1:1]o_btn_tri_i_1;
  wire [2:2]o_btn_tri_i_2;
  wire [3:3]o_btn_tri_i_3;
  wire [0:0]o_btn_tri_io_0;
  wire [1:1]o_btn_tri_io_1;
  wire [2:2]o_btn_tri_io_2;
  wire [3:3]o_btn_tri_io_3;
  wire [0:0]o_btn_tri_o_0;
  wire [1:1]o_btn_tri_o_1;
  wire [2:2]o_btn_tri_o_2;
  wire [3:3]o_btn_tri_o_3;
  wire [0:0]o_btn_tri_t_0;
  wire [1:1]o_btn_tri_t_1;
  wire [2:2]o_btn_tri_t_2;
  wire [3:3]o_btn_tri_t_3;
  wire [0:0]o_fnd_com_tri_i_0;
  wire [1:1]o_fnd_com_tri_i_1;
  wire [2:2]o_fnd_com_tri_i_2;
  wire [3:3]o_fnd_com_tri_i_3;
  wire [0:0]o_fnd_com_tri_io_0;
  wire [1:1]o_fnd_com_tri_io_1;
  wire [2:2]o_fnd_com_tri_io_2;
  wire [3:3]o_fnd_com_tri_io_3;
  wire [0:0]o_fnd_com_tri_o_0;
  wire [1:1]o_fnd_com_tri_o_1;
  wire [2:2]o_fnd_com_tri_o_2;
  wire [3:3]o_fnd_com_tri_o_3;
  wire [0:0]o_fnd_com_tri_t_0;
  wire [1:1]o_fnd_com_tri_t_1;
  wire [2:2]o_fnd_com_tri_t_2;
  wire [3:3]o_fnd_com_tri_t_3;
  wire [0:0]o_fnd_data_tri_i_0;
  wire [1:1]o_fnd_data_tri_i_1;
  wire [2:2]o_fnd_data_tri_i_2;
  wire [3:3]o_fnd_data_tri_i_3;
  wire [4:4]o_fnd_data_tri_i_4;
  wire [5:5]o_fnd_data_tri_i_5;
  wire [6:6]o_fnd_data_tri_i_6;
  wire [7:7]o_fnd_data_tri_i_7;
  wire [0:0]o_fnd_data_tri_io_0;
  wire [1:1]o_fnd_data_tri_io_1;
  wire [2:2]o_fnd_data_tri_io_2;
  wire [3:3]o_fnd_data_tri_io_3;
  wire [4:4]o_fnd_data_tri_io_4;
  wire [5:5]o_fnd_data_tri_io_5;
  wire [6:6]o_fnd_data_tri_io_6;
  wire [7:7]o_fnd_data_tri_io_7;
  wire [0:0]o_fnd_data_tri_o_0;
  wire [1:1]o_fnd_data_tri_o_1;
  wire [2:2]o_fnd_data_tri_o_2;
  wire [3:3]o_fnd_data_tri_o_3;
  wire [4:4]o_fnd_data_tri_o_4;
  wire [5:5]o_fnd_data_tri_o_5;
  wire [6:6]o_fnd_data_tri_o_6;
  wire [7:7]o_fnd_data_tri_o_7;
  wire [0:0]o_fnd_data_tri_t_0;
  wire [1:1]o_fnd_data_tri_t_1;
  wire [2:2]o_fnd_data_tri_t_2;
  wire [3:3]o_fnd_data_tri_t_3;
  wire [4:4]o_fnd_data_tri_t_4;
  wire [5:5]o_fnd_data_tri_t_5;
  wire [6:6]o_fnd_data_tri_t_6;
  wire [7:7]o_fnd_data_tri_t_7;
  wire [0:0]o_led_tri_i_0;
  wire [1:1]o_led_tri_i_1;
  wire [10:10]o_led_tri_i_10;
  wire [11:11]o_led_tri_i_11;
  wire [12:12]o_led_tri_i_12;
  wire [13:13]o_led_tri_i_13;
  wire [14:14]o_led_tri_i_14;
  wire [15:15]o_led_tri_i_15;
  wire [2:2]o_led_tri_i_2;
  wire [3:3]o_led_tri_i_3;
  wire [4:4]o_led_tri_i_4;
  wire [5:5]o_led_tri_i_5;
  wire [6:6]o_led_tri_i_6;
  wire [7:7]o_led_tri_i_7;
  wire [8:8]o_led_tri_i_8;
  wire [9:9]o_led_tri_i_9;
  wire [0:0]o_led_tri_io_0;
  wire [1:1]o_led_tri_io_1;
  wire [10:10]o_led_tri_io_10;
  wire [11:11]o_led_tri_io_11;
  wire [12:12]o_led_tri_io_12;
  wire [13:13]o_led_tri_io_13;
  wire [14:14]o_led_tri_io_14;
  wire [15:15]o_led_tri_io_15;
  wire [2:2]o_led_tri_io_2;
  wire [3:3]o_led_tri_io_3;
  wire [4:4]o_led_tri_io_4;
  wire [5:5]o_led_tri_io_5;
  wire [6:6]o_led_tri_io_6;
  wire [7:7]o_led_tri_io_7;
  wire [8:8]o_led_tri_io_8;
  wire [9:9]o_led_tri_io_9;
  wire [0:0]o_led_tri_o_0;
  wire [1:1]o_led_tri_o_1;
  wire [10:10]o_led_tri_o_10;
  wire [11:11]o_led_tri_o_11;
  wire [12:12]o_led_tri_o_12;
  wire [13:13]o_led_tri_o_13;
  wire [14:14]o_led_tri_o_14;
  wire [15:15]o_led_tri_o_15;
  wire [2:2]o_led_tri_o_2;
  wire [3:3]o_led_tri_o_3;
  wire [4:4]o_led_tri_o_4;
  wire [5:5]o_led_tri_o_5;
  wire [6:6]o_led_tri_o_6;
  wire [7:7]o_led_tri_o_7;
  wire [8:8]o_led_tri_o_8;
  wire [9:9]o_led_tri_o_9;
  wire [0:0]o_led_tri_t_0;
  wire [1:1]o_led_tri_t_1;
  wire [10:10]o_led_tri_t_10;
  wire [11:11]o_led_tri_t_11;
  wire [12:12]o_led_tri_t_12;
  wire [13:13]o_led_tri_t_13;
  wire [14:14]o_led_tri_t_14;
  wire [15:15]o_led_tri_t_15;
  wire [2:2]o_led_tri_t_2;
  wire [3:3]o_led_tri_t_3;
  wire [4:4]o_led_tri_t_4;
  wire [5:5]o_led_tri_t_5;
  wire [6:6]o_led_tri_t_6;
  wire [7:7]o_led_tri_t_7;
  wire [8:8]o_led_tri_t_8;
  wire [9:9]o_led_tri_t_9;
  wire [0:0]o_sw_tri_i_0;
  wire [1:1]o_sw_tri_i_1;
  wire [10:10]o_sw_tri_i_10;
  wire [11:11]o_sw_tri_i_11;
  wire [12:12]o_sw_tri_i_12;
  wire [13:13]o_sw_tri_i_13;
  wire [14:14]o_sw_tri_i_14;
  wire [15:15]o_sw_tri_i_15;
  wire [2:2]o_sw_tri_i_2;
  wire [3:3]o_sw_tri_i_3;
  wire [4:4]o_sw_tri_i_4;
  wire [5:5]o_sw_tri_i_5;
  wire [6:6]o_sw_tri_i_6;
  wire [7:7]o_sw_tri_i_7;
  wire [8:8]o_sw_tri_i_8;
  wire [9:9]o_sw_tri_i_9;
  wire [0:0]o_sw_tri_io_0;
  wire [1:1]o_sw_tri_io_1;
  wire [10:10]o_sw_tri_io_10;
  wire [11:11]o_sw_tri_io_11;
  wire [12:12]o_sw_tri_io_12;
  wire [13:13]o_sw_tri_io_13;
  wire [14:14]o_sw_tri_io_14;
  wire [15:15]o_sw_tri_io_15;
  wire [2:2]o_sw_tri_io_2;
  wire [3:3]o_sw_tri_io_3;
  wire [4:4]o_sw_tri_io_4;
  wire [5:5]o_sw_tri_io_5;
  wire [6:6]o_sw_tri_io_6;
  wire [7:7]o_sw_tri_io_7;
  wire [8:8]o_sw_tri_io_8;
  wire [9:9]o_sw_tri_io_9;
  wire [0:0]o_sw_tri_o_0;
  wire [1:1]o_sw_tri_o_1;
  wire [10:10]o_sw_tri_o_10;
  wire [11:11]o_sw_tri_o_11;
  wire [12:12]o_sw_tri_o_12;
  wire [13:13]o_sw_tri_o_13;
  wire [14:14]o_sw_tri_o_14;
  wire [15:15]o_sw_tri_o_15;
  wire [2:2]o_sw_tri_o_2;
  wire [3:3]o_sw_tri_o_3;
  wire [4:4]o_sw_tri_o_4;
  wire [5:5]o_sw_tri_o_5;
  wire [6:6]o_sw_tri_o_6;
  wire [7:7]o_sw_tri_o_7;
  wire [8:8]o_sw_tri_o_8;
  wire [9:9]o_sw_tri_o_9;
  wire [0:0]o_sw_tri_t_0;
  wire [1:1]o_sw_tri_t_1;
  wire [10:10]o_sw_tri_t_10;
  wire [11:11]o_sw_tri_t_11;
  wire [12:12]o_sw_tri_t_12;
  wire [13:13]o_sw_tri_t_13;
  wire [14:14]o_sw_tri_t_14;
  wire [15:15]o_sw_tri_t_15;
  wire [2:2]o_sw_tri_t_2;
  wire [3:3]o_sw_tri_t_3;
  wire [4:4]o_sw_tri_t_4;
  wire [5:5]o_sw_tri_t_5;
  wire [6:6]o_sw_tri_t_6;
  wire [7:7]o_sw_tri_t_7;
  wire [8:8]o_sw_tri_t_8;
  wire [9:9]o_sw_tri_t_9;
  wire o_tx;
  wire reset;
  wire sys_clock;
  wire usb_uart_rxd;
  wire usb_uart_txd;

  IOBUF o_btn_tri_iobuf_0
       (.I(o_btn_tri_o_0),
        .IO(o_btn_tri_io[0]),
        .O(o_btn_tri_i_0),
        .T(o_btn_tri_t_0));
  IOBUF o_btn_tri_iobuf_1
       (.I(o_btn_tri_o_1),
        .IO(o_btn_tri_io[1]),
        .O(o_btn_tri_i_1),
        .T(o_btn_tri_t_1));
  IOBUF o_btn_tri_iobuf_2
       (.I(o_btn_tri_o_2),
        .IO(o_btn_tri_io[2]),
        .O(o_btn_tri_i_2),
        .T(o_btn_tri_t_2));
  IOBUF o_btn_tri_iobuf_3
       (.I(o_btn_tri_o_3),
        .IO(o_btn_tri_io[3]),
        .O(o_btn_tri_i_3),
        .T(o_btn_tri_t_3));
  IOBUF o_fnd_com_tri_iobuf_0
       (.I(o_fnd_com_tri_o_0),
        .IO(o_fnd_com_tri_io[0]),
        .O(o_fnd_com_tri_i_0),
        .T(o_fnd_com_tri_t_0));
  IOBUF o_fnd_com_tri_iobuf_1
       (.I(o_fnd_com_tri_o_1),
        .IO(o_fnd_com_tri_io[1]),
        .O(o_fnd_com_tri_i_1),
        .T(o_fnd_com_tri_t_1));
  IOBUF o_fnd_com_tri_iobuf_2
       (.I(o_fnd_com_tri_o_2),
        .IO(o_fnd_com_tri_io[2]),
        .O(o_fnd_com_tri_i_2),
        .T(o_fnd_com_tri_t_2));
  IOBUF o_fnd_com_tri_iobuf_3
       (.I(o_fnd_com_tri_o_3),
        .IO(o_fnd_com_tri_io[3]),
        .O(o_fnd_com_tri_i_3),
        .T(o_fnd_com_tri_t_3));
  IOBUF o_fnd_data_tri_iobuf_0
       (.I(o_fnd_data_tri_o_0),
        .IO(o_fnd_data_tri_io[0]),
        .O(o_fnd_data_tri_i_0),
        .T(o_fnd_data_tri_t_0));
  IOBUF o_fnd_data_tri_iobuf_1
       (.I(o_fnd_data_tri_o_1),
        .IO(o_fnd_data_tri_io[1]),
        .O(o_fnd_data_tri_i_1),
        .T(o_fnd_data_tri_t_1));
  IOBUF o_fnd_data_tri_iobuf_2
       (.I(o_fnd_data_tri_o_2),
        .IO(o_fnd_data_tri_io[2]),
        .O(o_fnd_data_tri_i_2),
        .T(o_fnd_data_tri_t_2));
  IOBUF o_fnd_data_tri_iobuf_3
       (.I(o_fnd_data_tri_o_3),
        .IO(o_fnd_data_tri_io[3]),
        .O(o_fnd_data_tri_i_3),
        .T(o_fnd_data_tri_t_3));
  IOBUF o_fnd_data_tri_iobuf_4
       (.I(o_fnd_data_tri_o_4),
        .IO(o_fnd_data_tri_io[4]),
        .O(o_fnd_data_tri_i_4),
        .T(o_fnd_data_tri_t_4));
  IOBUF o_fnd_data_tri_iobuf_5
       (.I(o_fnd_data_tri_o_5),
        .IO(o_fnd_data_tri_io[5]),
        .O(o_fnd_data_tri_i_5),
        .T(o_fnd_data_tri_t_5));
  IOBUF o_fnd_data_tri_iobuf_6
       (.I(o_fnd_data_tri_o_6),
        .IO(o_fnd_data_tri_io[6]),
        .O(o_fnd_data_tri_i_6),
        .T(o_fnd_data_tri_t_6));
  IOBUF o_fnd_data_tri_iobuf_7
       (.I(o_fnd_data_tri_o_7),
        .IO(o_fnd_data_tri_io[7]),
        .O(o_fnd_data_tri_i_7),
        .T(o_fnd_data_tri_t_7));
  IOBUF o_led_tri_iobuf_0
       (.I(o_led_tri_o_0),
        .IO(o_led_tri_io[0]),
        .O(o_led_tri_i_0),
        .T(o_led_tri_t_0));
  IOBUF o_led_tri_iobuf_1
       (.I(o_led_tri_o_1),
        .IO(o_led_tri_io[1]),
        .O(o_led_tri_i_1),
        .T(o_led_tri_t_1));
  IOBUF o_led_tri_iobuf_10
       (.I(o_led_tri_o_10),
        .IO(o_led_tri_io[10]),
        .O(o_led_tri_i_10),
        .T(o_led_tri_t_10));
  IOBUF o_led_tri_iobuf_11
       (.I(o_led_tri_o_11),
        .IO(o_led_tri_io[11]),
        .O(o_led_tri_i_11),
        .T(o_led_tri_t_11));
  IOBUF o_led_tri_iobuf_12
       (.I(o_led_tri_o_12),
        .IO(o_led_tri_io[12]),
        .O(o_led_tri_i_12),
        .T(o_led_tri_t_12));
  IOBUF o_led_tri_iobuf_13
       (.I(o_led_tri_o_13),
        .IO(o_led_tri_io[13]),
        .O(o_led_tri_i_13),
        .T(o_led_tri_t_13));
  IOBUF o_led_tri_iobuf_14
       (.I(o_led_tri_o_14),
        .IO(o_led_tri_io[14]),
        .O(o_led_tri_i_14),
        .T(o_led_tri_t_14));
  IOBUF o_led_tri_iobuf_15
       (.I(o_led_tri_o_15),
        .IO(o_led_tri_io[15]),
        .O(o_led_tri_i_15),
        .T(o_led_tri_t_15));
  IOBUF o_led_tri_iobuf_2
       (.I(o_led_tri_o_2),
        .IO(o_led_tri_io[2]),
        .O(o_led_tri_i_2),
        .T(o_led_tri_t_2));
  IOBUF o_led_tri_iobuf_3
       (.I(o_led_tri_o_3),
        .IO(o_led_tri_io[3]),
        .O(o_led_tri_i_3),
        .T(o_led_tri_t_3));
  IOBUF o_led_tri_iobuf_4
       (.I(o_led_tri_o_4),
        .IO(o_led_tri_io[4]),
        .O(o_led_tri_i_4),
        .T(o_led_tri_t_4));
  IOBUF o_led_tri_iobuf_5
       (.I(o_led_tri_o_5),
        .IO(o_led_tri_io[5]),
        .O(o_led_tri_i_5),
        .T(o_led_tri_t_5));
  IOBUF o_led_tri_iobuf_6
       (.I(o_led_tri_o_6),
        .IO(o_led_tri_io[6]),
        .O(o_led_tri_i_6),
        .T(o_led_tri_t_6));
  IOBUF o_led_tri_iobuf_7
       (.I(o_led_tri_o_7),
        .IO(o_led_tri_io[7]),
        .O(o_led_tri_i_7),
        .T(o_led_tri_t_7));
  IOBUF o_led_tri_iobuf_8
       (.I(o_led_tri_o_8),
        .IO(o_led_tri_io[8]),
        .O(o_led_tri_i_8),
        .T(o_led_tri_t_8));
  IOBUF o_led_tri_iobuf_9
       (.I(o_led_tri_o_9),
        .IO(o_led_tri_io[9]),
        .O(o_led_tri_i_9),
        .T(o_led_tri_t_9));
  IOBUF o_sw_tri_iobuf_0
       (.I(o_sw_tri_o_0),
        .IO(o_sw_tri_io[0]),
        .O(o_sw_tri_i_0),
        .T(o_sw_tri_t_0));
  IOBUF o_sw_tri_iobuf_1
       (.I(o_sw_tri_o_1),
        .IO(o_sw_tri_io[1]),
        .O(o_sw_tri_i_1),
        .T(o_sw_tri_t_1));
  IOBUF o_sw_tri_iobuf_10
       (.I(o_sw_tri_o_10),
        .IO(o_sw_tri_io[10]),
        .O(o_sw_tri_i_10),
        .T(o_sw_tri_t_10));
  IOBUF o_sw_tri_iobuf_11
       (.I(o_sw_tri_o_11),
        .IO(o_sw_tri_io[11]),
        .O(o_sw_tri_i_11),
        .T(o_sw_tri_t_11));
  IOBUF o_sw_tri_iobuf_12
       (.I(o_sw_tri_o_12),
        .IO(o_sw_tri_io[12]),
        .O(o_sw_tri_i_12),
        .T(o_sw_tri_t_12));
  IOBUF o_sw_tri_iobuf_13
       (.I(o_sw_tri_o_13),
        .IO(o_sw_tri_io[13]),
        .O(o_sw_tri_i_13),
        .T(o_sw_tri_t_13));
  IOBUF o_sw_tri_iobuf_14
       (.I(o_sw_tri_o_14),
        .IO(o_sw_tri_io[14]),
        .O(o_sw_tri_i_14),
        .T(o_sw_tri_t_14));
  IOBUF o_sw_tri_iobuf_15
       (.I(o_sw_tri_o_15),
        .IO(o_sw_tri_io[15]),
        .O(o_sw_tri_i_15),
        .T(o_sw_tri_t_15));
  IOBUF o_sw_tri_iobuf_2
       (.I(o_sw_tri_o_2),
        .IO(o_sw_tri_io[2]),
        .O(o_sw_tri_i_2),
        .T(o_sw_tri_t_2));
  IOBUF o_sw_tri_iobuf_3
       (.I(o_sw_tri_o_3),
        .IO(o_sw_tri_io[3]),
        .O(o_sw_tri_i_3),
        .T(o_sw_tri_t_3));
  IOBUF o_sw_tri_iobuf_4
       (.I(o_sw_tri_o_4),
        .IO(o_sw_tri_io[4]),
        .O(o_sw_tri_i_4),
        .T(o_sw_tri_t_4));
  IOBUF o_sw_tri_iobuf_5
       (.I(o_sw_tri_o_5),
        .IO(o_sw_tri_io[5]),
        .O(o_sw_tri_i_5),
        .T(o_sw_tri_t_5));
  IOBUF o_sw_tri_iobuf_6
       (.I(o_sw_tri_o_6),
        .IO(o_sw_tri_io[6]),
        .O(o_sw_tri_i_6),
        .T(o_sw_tri_t_6));
  IOBUF o_sw_tri_iobuf_7
       (.I(o_sw_tri_o_7),
        .IO(o_sw_tri_io[7]),
        .O(o_sw_tri_i_7),
        .T(o_sw_tri_t_7));
  IOBUF o_sw_tri_iobuf_8
       (.I(o_sw_tri_o_8),
        .IO(o_sw_tri_io[8]),
        .O(o_sw_tri_i_8),
        .T(o_sw_tri_t_8));
  IOBUF o_sw_tri_iobuf_9
       (.I(o_sw_tri_o_9),
        .IO(o_sw_tri_io[9]),
        .O(o_sw_tri_i_9),
        .T(o_sw_tri_t_9));
  uart_design_1 uart_design_1_i
       (.i_rx(i_rx),
        .o_btn_tri_i({o_btn_tri_i_3,o_btn_tri_i_2,o_btn_tri_i_1,o_btn_tri_i_0}),
        .o_btn_tri_o({o_btn_tri_o_3,o_btn_tri_o_2,o_btn_tri_o_1,o_btn_tri_o_0}),
        .o_btn_tri_t({o_btn_tri_t_3,o_btn_tri_t_2,o_btn_tri_t_1,o_btn_tri_t_0}),
        .o_fnd_com_tri_i({o_fnd_com_tri_i_3,o_fnd_com_tri_i_2,o_fnd_com_tri_i_1,o_fnd_com_tri_i_0}),
        .o_fnd_com_tri_o({o_fnd_com_tri_o_3,o_fnd_com_tri_o_2,o_fnd_com_tri_o_1,o_fnd_com_tri_o_0}),
        .o_fnd_com_tri_t({o_fnd_com_tri_t_3,o_fnd_com_tri_t_2,o_fnd_com_tri_t_1,o_fnd_com_tri_t_0}),
        .o_fnd_data_tri_i({o_fnd_data_tri_i_7,o_fnd_data_tri_i_6,o_fnd_data_tri_i_5,o_fnd_data_tri_i_4,o_fnd_data_tri_i_3,o_fnd_data_tri_i_2,o_fnd_data_tri_i_1,o_fnd_data_tri_i_0}),
        .o_fnd_data_tri_o({o_fnd_data_tri_o_7,o_fnd_data_tri_o_6,o_fnd_data_tri_o_5,o_fnd_data_tri_o_4,o_fnd_data_tri_o_3,o_fnd_data_tri_o_2,o_fnd_data_tri_o_1,o_fnd_data_tri_o_0}),
        .o_fnd_data_tri_t({o_fnd_data_tri_t_7,o_fnd_data_tri_t_6,o_fnd_data_tri_t_5,o_fnd_data_tri_t_4,o_fnd_data_tri_t_3,o_fnd_data_tri_t_2,o_fnd_data_tri_t_1,o_fnd_data_tri_t_0}),
        .o_led_tri_i({o_led_tri_i_15,o_led_tri_i_14,o_led_tri_i_13,o_led_tri_i_12,o_led_tri_i_11,o_led_tri_i_10,o_led_tri_i_9,o_led_tri_i_8,o_led_tri_i_7,o_led_tri_i_6,o_led_tri_i_5,o_led_tri_i_4,o_led_tri_i_3,o_led_tri_i_2,o_led_tri_i_1,o_led_tri_i_0}),
        .o_led_tri_o({o_led_tri_o_15,o_led_tri_o_14,o_led_tri_o_13,o_led_tri_o_12,o_led_tri_o_11,o_led_tri_o_10,o_led_tri_o_9,o_led_tri_o_8,o_led_tri_o_7,o_led_tri_o_6,o_led_tri_o_5,o_led_tri_o_4,o_led_tri_o_3,o_led_tri_o_2,o_led_tri_o_1,o_led_tri_o_0}),
        .o_led_tri_t({o_led_tri_t_15,o_led_tri_t_14,o_led_tri_t_13,o_led_tri_t_12,o_led_tri_t_11,o_led_tri_t_10,o_led_tri_t_9,o_led_tri_t_8,o_led_tri_t_7,o_led_tri_t_6,o_led_tri_t_5,o_led_tri_t_4,o_led_tri_t_3,o_led_tri_t_2,o_led_tri_t_1,o_led_tri_t_0}),
        .o_sw_tri_i({o_sw_tri_i_15,o_sw_tri_i_14,o_sw_tri_i_13,o_sw_tri_i_12,o_sw_tri_i_11,o_sw_tri_i_10,o_sw_tri_i_9,o_sw_tri_i_8,o_sw_tri_i_7,o_sw_tri_i_6,o_sw_tri_i_5,o_sw_tri_i_4,o_sw_tri_i_3,o_sw_tri_i_2,o_sw_tri_i_1,o_sw_tri_i_0}),
        .o_sw_tri_o({o_sw_tri_o_15,o_sw_tri_o_14,o_sw_tri_o_13,o_sw_tri_o_12,o_sw_tri_o_11,o_sw_tri_o_10,o_sw_tri_o_9,o_sw_tri_o_8,o_sw_tri_o_7,o_sw_tri_o_6,o_sw_tri_o_5,o_sw_tri_o_4,o_sw_tri_o_3,o_sw_tri_o_2,o_sw_tri_o_1,o_sw_tri_o_0}),
        .o_sw_tri_t({o_sw_tri_t_15,o_sw_tri_t_14,o_sw_tri_t_13,o_sw_tri_t_12,o_sw_tri_t_11,o_sw_tri_t_10,o_sw_tri_t_9,o_sw_tri_t_8,o_sw_tri_t_7,o_sw_tri_t_6,o_sw_tri_t_5,o_sw_tri_t_4,o_sw_tri_t_3,o_sw_tri_t_2,o_sw_tri_t_1,o_sw_tri_t_0}),
        .o_tx(o_tx),
        .reset(reset),
        .sys_clock(sys_clock),
        .usb_uart_rxd(usb_uart_rxd),
        .usb_uart_txd(usb_uart_txd));
endmodule
