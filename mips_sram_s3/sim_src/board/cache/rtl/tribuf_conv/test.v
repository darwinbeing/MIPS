`define test2

`ifdef test1

// the fan-out from the node tribuf to the AND gate is converted to an OR gate.
module test (input oe1, data1, in, output out, inout bidir);
wire tribuf, tmp;
assign tribuf = oe1 ? data1 : 1'bz;
and(tmp, in, tribuf);
assign bidir = tribuf;
assign out = tmp;
endmodule

`else

// In the following design, the node triwire is converted to a selector.
module test (input oe1, data1, oe2, data2, in, output out);
wire triwire, tmp;
assign triwire = oe1 ? data1 : 1'bz;
assign triwire = oe2 ? data2 : 1'bz;
and(tmp, in, triwire);
assign out = tmp;
endmodule
`endif