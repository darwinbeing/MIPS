Sdram_Controller.v

For burst 4

//=================================================================================================
// A simplification:
//
// DQM is set high after the second burst beat assuming UNALIGNED write 
// For the first two burst beats, DQM is the registered value of DM 
//=================================================================================================
DQM <= ( ACT && (ST>=SC_CL) )	?	((Write ? ((ST >= SC_CL+LENGTH/2) ?	2'b11 : DM) : 2'b00))	: 2'b11	;
