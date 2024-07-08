`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    Fake6523-28pin + FakePLA 251641-3 = Fake1551Paddle
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.02 - Fixed for 1551
// Revision 0.03 - added FakePLA 251641-3
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Fake6523(
                input _reset,
//                input _cs,
                input [2:0]rs,
                input _write,
                inout [7:0]data,
                inout [7:0]port_a,
                inout [1:0]port_b,
                inout [7:6]port_c,
					 input [15:1]pla_i,	// PLA pins
					 input [4:3]addr, 	// remaining addr lines
					 output pla_f7, 		// PLA feedback output pin (debug)
					 output _cs, 			// 6523 /CS pin (debug)
					 output _resetout		// 3.3V /RESET
               );

// FakePLA 251641-3
// - can be further simplified:
//		- portb[1:0] is always input (STATUS0/1) 
//		- portc[6] is always output (DAV for drive)
//    - portc[7] is always input (ACK from drive)

// defined in 1551.251641-3.c but not used
// #define F1 I0&&I6&&!I7
// F1 = _cs && Phi0 && !/RAS
// assign pla_f1 = _cs && pla_i[6] && !pla_i[7];

// #define F7 I10||(!I10&&I6&&I0&&!I7)
// F7 = MUX || (!MUX && Phi0 && _cs && !/RAS)
// wired back to I0
//assign pla_f7 = pla_i[10] || (!pla_i[10] && pla_i[6] && _cs && !pla_i[7]);
assign pla_f7 = pla_i[10] || (!pla_i[10] && pla_i[6] && pla_f7 && !pla_i[7]);

//#define F0 !((!I15&&I0&&I1&&I2&&I3&&I4&&I5&&I6&&	\
//	      I11&&I14&&!I12&&!I7&&I9&&!I8&&I13)||	\
//	     (I15&&I0&&I1&&I2&&I3&&I4&&I5&&I6&&		\
//	      I11&&I14&&!I12&&!I7&&I9&&I8&&I13))
// - we don't need pla_f7 can use whole expression here
// - we could use A3+A4 to narrow down memory space down to 8 addresses connected to Fake6523 rs[2:0]
// - DEV is input from device, with Arduino we want to make it output - just copy A5
// - pla F7 routed back to I0? but F7 uses I0 (_cs) in the expression, makes no sense - can be removed?
/*
assign _cs = !(
		( (pla_i[10] || (!pla_i[10] && pla_i[6] && _cs && !pla_i[7])) && // pla_f7 
			pla_i[1] && pla_i[2] && pla_i[3] && pla_i[4] && pla_i[5] && // A[15:11]=1
			pla_i[11] && pla_i[14] && pla_i[9] && pla_i[13] &&          // A[10:9,7:6]=1
			!pla_i[12] && // A8=0 
			pla_i[6] &&   // Phi0
			!pla_i[7]     // /RAS
		) &&
		(
			(!pla_i[15] && !pla_i[8]) || // A5==0 && DEV==0 // FEC0-FECF (but without A4 decoded to FEC0-FEDF) TCBM:0 IEC:9
			( pla_i[15] &&  pla_i[8])    // A5==1 && DEV==1 // FEE0-FEEF (but without A4 decoded to FEE0-FEFF) TCBM:1 IEC:8
		)
		);
*/

assign _cs = !(
//		( (pla_i[10] || (!pla_i[10] && pla_i[6] && !pla_i[7])) && // pla_f7: (MUX || !MUX && Phi0 && !/RAS) && <address> // without feedback
		( (pla_f7) && // pla_f7 - with feedback
			pla_i[1] && pla_i[2] && pla_i[3] && pla_i[4] && pla_i[5] && // A[15:11]=1
			pla_i[11] && pla_i[14] && pla_i[9] && pla_i[13] &&          // A[10:9,7:6]=1
			!addr[3] && // A3=0
			!pla_i[12] // A8=0
		) &&
		(
			(!addr[4] && !pla_i[15] && !pla_i[8]) || // A4==0 && A5==0 && DEV==0 // FEC0-FEC7 TCBM:0 IEC:9
			( addr[4] &&  pla_i[15] &&  pla_i[8])    // A4==1 && A5==1 && DEV==1 // FEF0-FEF7 TCBM:1 IEC:8
		)
		);

// 3.3V RESET
assign _resetout = _reset;

// Fake6523

reg [7:0]data_out;
reg [2:0] rs_r;
wire clock = !_cs;
wire [7:0] data_ddr_a;
wire [1:0] data_ddr_b;
wire [7:6] data_ddr_c;

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
								
ioport2bit     ioport_b(
								.clock(clock), 
								.reset(!_reset), 
								.data_in(data[1:0]), 
								.we_ddr(we_ddr_b), 
								.data_ddr(data_ddr_b), 
								.we_port(we_port_b), 
								.pins(port_b)
								);
								
ioport2bit     ioport_c(
								.clock(clock), 
								.reset(!_reset), 
								.data_in(data[7:6]), 
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
      1: data_out[1:0] = port_b[1:0];
      2: data_out[7:6] = port_c[7:6];
      3: data_out = data_ddr_a;
      4: data_out[1:0] = data_ddr_b[1:0];
      5: data_out[7:6] = data_ddr_c[7:6];
      default: data_out = 8'bz;
   endcase
end

endmodule
