`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 			YTM Enterprises
// Engineer: 			Maciej Witkowiak
// 
// Create Date:    	2024-09-14
// Design Name: 
// Module Name:		Fake6523 (Fake1551Paddle)
// Project Name: 
// Target Devices: 	XC9572XL VQ64
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision:			0.1 first revision loosely based on Fake6523 and CIA clone code
// Additional Comments: 
//	combination of F+B+D+G+I - tcbm pcb v1.1 without h/w modifications
// combination of E+A+C+G+I - would make most sense for tcbm pcb v1.2 to use with phi2, but it doesn't work with 6510
//
//////////////////////////////////////////////////////////////////////////////////

module Fake6523(
                input _reset,
                input [2:0]rs,
                input _write,
                inout [7:0]data,
                inout [7:0]port_a,
                inout [1:0]port_b,
                inout [7:6]port_c,
                input [15:1]pla_i,	// PLA pins
                input [4:3]addr,		// remaining addr lines
                input phi2,
                input aec,
                input ba,
               output _resetout,		// 3.3V /RESET
					input c1lo,
					input c1hi,
					input c2lo,
					input c2hi,
               output rom_a15,
					output rom_cs
					);

// ROM

assign rom_cs = !(!c1lo || !c1hi || !c2lo || !c2hi);
assign rom_a15 =!(!c1lo || !c1hi); // 1 for C1 (high 32K half, default for 32K ROM), 0 for C2 (low 32K half)

// Fake6523

reg [7:0] data_out;

// Ports A/B/C
reg [7:0] ddra;
reg [7:0] pra;

reg [7:0] ddrb;	// 1:0
reg [7:0] prb;		// 1:0

reg [7:0] ddrc;	// 7:6
reg [7:0] prc;		// 7:6

assign port_a[0] = ddra[0] ? pra[0] : 1'bz;
assign port_a[1] = ddra[1] ? pra[1] : 1'bz;
assign port_a[2] = ddra[2] ? pra[2] : 1'bz;
assign port_a[3] = ddra[3] ? pra[3] : 1'bz;
assign port_a[4] = ddra[4] ? pra[4] : 1'bz;
assign port_a[5] = ddra[5] ? pra[5] : 1'bz;
assign port_a[6] = ddra[6] ? pra[6] : 1'bz;
assign port_a[7] = ddra[7] ? pra[7] : 1'bz;

assign port_b[0] = ddrb[0] ? prb[0] : 1'bz;
assign port_b[1] = ddrb[1] ? prb[1] : 1'bz;

assign port_c[6] = ddrc[6] ? prc[6] : 1'bz;
assign port_c[7] = ddrc[7] ? prc[7] : 1'bz;


// 3.3V RESET only low or floating
assign _resetout = !_reset ? _reset : 1'bz;

assign seladr = (
 			pla_i[1] && pla_i[2] && pla_i[3] && pla_i[4] && pla_i[5] && // A[15:11]=1
			pla_i[11] && pla_i[14] && pla_i[9] && pla_i[13] &&          // A[10:9,7:6]=1
			!addr[3] && // A3=0
			!pla_i[12] // A8=0
		) &&
		(
			(!addr[4] && !pla_i[15] && !pla_i[8]) || // A4==0 && A5==0 && DEV==0 // FEC0-FEC7 TCBM:0 IEC:9
			( addr[4] &&  pla_i[15] &&  pla_i[8])    // A4==1 && A5==1 && DEV==1 // FEF0-FEF7 TCBM:1 IEC:8
		);

//wire drive_data_out = phi2 && aec && ba && seladr && _write; // E
wire drive_data_out = seladr && _write && !pla_i[10]; // F
assign data = drive_data_out ? data_out : 8'bz;

//always @(negedge phi2 or negedge _reset) begin // A
always @(negedge pla_i[6] or negedge _reset) begin // B
	if (!_reset) begin
		pra <= 8'd0;
		prb <= 8'd0;
		prc <= 8'd0;
		ddra <= 8'd0;
		ddrb <= 8'd0;
		ddrc <= 8'd0;
	end
//	else if (aec && seladr && !_write) begin // register write // C
	else if (seladr && !_write) begin // register write // D
		case (rs)
			0: pra <= data;
			1: prb <= data;
			2: prc <= data;
			3: ddra <= data;
			4: ddrb <= data;
			5: ddrc <= data;
		endcase
	end
end

// reading
always @(*) begin
	case (rs)
      0: data_out = port_a;
      1: begin data_out[1:0] = port_b[1:0]; data_out[7:2] = 0; end // G
      2: begin data_out[7:6] = port_c[7:6]; data_out[5:0] = 0; end // G
      3: data_out = ddra;
      4: data_out = ddrb; // I
      5: data_out = ddrc; // I
//      4: begin data_out[1:0] = ddrb[1:0]; data_out[7:2] = 0; end // J
//      5: begin data_out[7:6] = ddrc[7:6]; data_out[5:0] = 0; end // J
      default: data_out = 8'bz;
	endcase
end
endmodule
