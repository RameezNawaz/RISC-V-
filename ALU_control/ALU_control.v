module ALU_control(
input [1:0] ALUOp,
input [2:0] Funct3,
input [6:0] Funct7,
input [6:0] op,
output reg [2:0] Operation);

parameter ADD=3'b000,SUB=3'b001,SET_LESS_THAN=3'b101,OR=3'b011,AND=3'b010;

always@(*)
     begin 
	    if(ALUOp==2'b00)
		    begin Operation =ADD; end
			
		 else if(ALUOp==2'b01)
		    begin Operation =SUB; end
			 
		 else if(ALUOp==2'b10 && ({op[5],Funct7[5]}==2'b00 || {op[5],Funct7[5]}==2'b01 ||{op[5],Funct7[5]}==2'b10) && Funct3==3'b000)
		    begin Operation =ADD; end
			 
		 else if(ALUOp==2'b10 && {op[5],Funct7[5]}==2'b11 && Funct3==3'b000)
		    begin Operation =SUB; end
			 
		 else if(ALUOp==2'b10  && Funct3==3'b010)
		    begin Operation =SET_LESS_THAN; end
			 
		 else if(ALUOp==2'b10  && Funct3==3'b110)
		    begin Operation =OR; end
			 
		 else if(ALUOp==2'b10  && Funct3==3'b111)
		    begin Operation =AND; end 
     end 
	  
endmodule 

/*module ALU_control_tb();
reg [1:0] ALUOp;
reg [2:0] Funct3;
reg Funct7;
reg op;
wire  [2:0] Operation;

ALU_control dut( ALUOp,Funct3,Funct7,op,Operation);
initial begin
ALUOp=2'b00;Funct3=3'b000;	Op=0;Funct7=0;
#5 ALUOp=2'b01;Funct3=3'b000;Op=0;Funct7=0;*/

