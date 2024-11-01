module control_unit(
input [6:0] Opcode,
output  reg Branch,
output  reg[1:0] Immsrc, 
output  reg Resultsrc,
output  reg [1:0] ALUOp,
output  reg MemWrite,
output  reg ALUsrc,
output  reg RegWrite);

parameter R_Type=7'b0110011,I_Type_LW=7'b0000011,I_Type_SW=7'b0100011,SB_Type_BEQ=7'b1100011,R_Type_ADDI=7'b0010011;

always@(*)
    begin   
        case(Opcode)
		     R_Type:
			     begin 
		            ALUsrc=0;
						Resultsrc=0;
						Immsrc=2'bxx;
						RegWrite=1;
						MemWrite=0;
						Branch=0;
						ALUOp=2'b10;
				   end
			I_Type_LW:
			     begin 
		            ALUsrc=1;
						Resultsrc=1;
						Immsrc=2'b00;
						RegWrite=1;
						MemWrite=0;
						Branch=0;
						ALUOp=2'b00;
				   end
			I_Type_SW:
			     begin 
		            ALUsrc=1;
						Resultsrc=1'bx;
						Immsrc=2'b01;
						RegWrite=0;
						MemWrite=1;
						Branch=0;
						ALUOp=2'b00;
				   end
			SB_Type_BEQ:
			     begin 
		            ALUsrc=0;
						Resultsrc=1'bx;
						Immsrc=2'b10;
						RegWrite=0;
						MemWrite=0;
						Branch=1;
						ALUOp=2'b01;
				   end			
			R_Type_ADDI:
			     begin 
		            ALUsrc=1;
						Resultsrc=0;
						Immsrc=2'b00;
						RegWrite=1;
						MemWrite=0;
						Branch=0;
						ALUOp=2'b10;
				   end
		endcase
     end	
endmodule 
		  