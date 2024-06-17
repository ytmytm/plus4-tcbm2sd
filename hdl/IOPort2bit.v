`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    ioport2bit
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.02 - Fixed for 1551
// Revision 0.03 - 2 bit port PB/PC for 28-pin
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ioport2bit(
              input clock,
              input reset,
              input [1:0]data_in,
              input we_ddr,
              output [1:0]data_ddr,
              input we_port,
              output [1:0]data_port,
              inout [1:0]pins
             );

register2bit       reg_ddr(
                       (!we_ddr | !clock), 
                       reset, 
                       1, 
                       data_in, 
                       data_ddr
                      );
register2bit	      reg_a(
                     (!we_port | !clock), 
                     reset, 
                     1, 
                     data_in, 
                     data_port
                    );
                                            
assign pins[0] = (data_ddr[0] ? data_port[0] : 'bz);
assign pins[1] = (data_ddr[1] ? data_port[1] : 'bz);

endmodule
