/*
 * Copyright (c) 2024 Sam Kho
 * SPDX-License-Identifier: Apache-2.0
 */

/*
    Two Channel Square Wave Generator
    Like having two apple2-style speakers,
    but without 6502 software loops

    Sam Kho, 11/10/2024
*/
`default_nettype none

module tt_um_samkho_two_channel_square_wave_generator (
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // always 1 when the design is powered, so you can ignore it
  input  wire       clk,      // clock
  input  wire       rst_n     // reset_n - low to reset
);

  reg outputA;
  reg outputB;  
  reg [1:0] sum;
  
  reg [7:0] counterA;
  reg [7:0] counterB;
  
  always @(posedge clk)
    if (0 == rst_n) begin
      counterA <= 0;
      outputA <= 0;
    end else if (counterA != 0)
    	counterA <= counterA - 1;
    else begin
      counterA <= ui_in;
      if (ui_in != 0)
      	outputA <= !outputA;
      else outputA <= 0;
    end

  always @(posedge clk)
    if (0 == rst_n) begin
      counterB <= 0;
      outputB <= 0;
    end else if (counterB != 0)
    	counterB <= counterB - 1;
    else begin
      counterB <= uio_in;
      if (uio_in != 0)
      	outputB <= !outputB;
      else outputB <= 0;
    end
  
  always @(posedge clk)
    sum <= outputA + outputB;
  
  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[0] = outputA;
  assign uo_out[1] = outputB;
  assign uo_out[2] = sum[0];
  assign uo_out[3] = sum[1];
  assign uo_out[7:4] = 0;  
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};
    
endmodule
