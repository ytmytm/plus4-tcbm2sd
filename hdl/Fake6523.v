`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    Fake6523 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.02 - Fixed for 1551
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Fake6523(
                input _reset,
                input _cs,
                input [2:0]rs,
                input _write,
                inout [7:0]data,
                inout [7:0]port_a,
                inout [7:0]port_b,
                inout [7:0]port_c
               );

reg [7:0]data_out;
reg [2:0] rs_r;
wire clock = !_cs;
wire [7:0] data_ddr_a;
wire [7:0] data_ddr_b;
wire [7:0] data_ddr_c;

wire we_ddr_a;
wire we_ddr_b;
wire we_ddr_c;
wire we_port_a;
wire we_port_b;
wire we_port_c;

assign we_ddr_a = !_write & (rs_r == 3'd3);
assign we_ddr_b = !_write & (rs_r == 3'd4);
assign we_ddr_c = !_write & (rs_r == 3'd5);
assign we_port_a = !_write & (rs_r == 3'd0);
assign we_port_b = !_write & (rs_r == 3'd1);
assign we_port_c = !_write & (rs_r == 3'd2);

ioport         ioport_a(
								.clock(clock), 
								.reset(!_reset), 
								.data_in(data), 
								.we_ddr(we_ddr_a), 
								.data_ddr(data_ddr_a), 
								.we_port(we_port_a), 
								.pins(port_a)
								);
								
ioport         ioport_b(
								.clock(clock), 
								.reset(!_reset), 
								.data_in(data), 
								.we_ddr(we_ddr_b), 
								.data_ddr(data_ddr_b), 
								.we_port(we_port_b), 
								.pins(port_b)
								);
								
ioport         ioport_c(
								.clock(clock), 
								.reset(!_reset), 
								.data_in(data), 
								.we_ddr(we_ddr_c), 
								.data_ddr(data_ddr_c), 
								.we_port(we_port_c), 
								.pins(port_c)
								);


assign data =  (!_cs & _write ? data_out : 8'bz);

always @(posedge clock)
begin
   rs_r = rs;
	case(rs_r)
      0: data_out = port_a;
      1: data_out = port_b;
      2: data_out = port_c;
      3: data_out = data_ddr_a;
      4: data_out = data_ddr_b;
      5: data_out = data_ddr_c;
      default: data_out = 8'bz;
   endcase
end

endmodule
