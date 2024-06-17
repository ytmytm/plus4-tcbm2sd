`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    ioport 
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
module ioport(
              input clock,
              input reset,
              input [7:0]data_in,
              input we_ddr,
              output [7:0]data_ddr,
              input we_port,
              output [7:0]data_port,
              inout [7:0]pins
             );

register       reg_ddr(
                       (!we_ddr | !clock), 
                       reset, 
                       1, 
                       data_in, 
                       data_ddr
                      );
register	      reg_a(
                     (!we_port | !clock), 
                     reset, 
                     1, 
                     data_in, 
                     data_port
                    );
                                            
assign pins[0] = (data_ddr[0] ? data_port[0] : 'bz);
assign pins[1] = (data_ddr[1] ? data_port[1] : 'bz);
assign pins[2] = (data_ddr[2] ? data_port[2] : 'bz);
assign pins[3] = (data_ddr[3] ? data_port[3] : 'bz);
assign pins[4] = (data_ddr[4] ? data_port[4] : 'bz);
assign pins[5] = (data_ddr[5] ? data_port[5] : 'bz);
assign pins[6] = (data_ddr[6] ? data_port[6] : 'bz);
assign pins[7] = (data_ddr[7] ? data_port[7] : 'bz);

endmodule
