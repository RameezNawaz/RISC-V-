 // RISC-V SINGLE CYCLE PROCESSOR

 module RISCV_SCP(clk, rst);

    input clk;
    input rst;

    wire [31:0] PC_OUT, instruction, d, PC_next, PC_TARGET, PC_PLUS4, b;
    wire [31:0] readdata1, readdata2, SRC_B, ALUResult, Read_Data, Result;
    wire PC_src, Resultsrc, MemWrite, ALUsrc, RegWrite, branchsel, zero;
    wire [1:0] ALUOp, Immsrc;
    wire [2:0] Operation;

    and a11(branchsel, PC_src, zero);
    assign b = 32'h00000004; // CONSTANT 4 FOR PROGRAM COUNTER

    // FOR SELECTING PROGRAM COUNTER INPUT
    Mux_2to1 m1(PC_PLUS4, PC_TARGET, branchsel, PC_next); 

    // PROGRAM COUNTER (PC)
    PC pc1(clk, PC_next, rst, PC_OUT); 

    // INSTRUCTION MEMORY
    Instruction_memory i1(PC_OUT, instruction); 

    // REGISTER FILE
    registerfile r1(clk, instruction[19:15], instruction[24:20], instruction[11:7], RegWrite, Result, readdata1, readdata2);
    
    // CONTROL UNIT
    control_unit c1(instruction[6:0], PC_src, Immsrc, Resultsrc, ALUOp, MemWrite, ALUsrc, RegWrite); 

    // IMMEDIATE DATA GENERATOR
    IDG I2(instruction, Immsrc, d); 

    // ADDER FOR PROGRAM COUNTER (ADD BY 4)
    Adder a1(PC_OUT, b, PC_PLUS4); 

    // ADDER FOR BRANCH INSTRUCTION 
    Adder a2(d, PC_OUT, PC_TARGET); 

    // FOR SELECTING THE ALU INPUT2
    Mux_2to1 m2(readdata2, d, ALUsrc, SRC_B); 

    // ALU DECODER
    ALU_control al1(ALUOp, instruction[14:12], instruction[31:25], instruction[6:0], Operation);

    // ALU
    ALU al2(readdata1, SRC_B, Operation, ALUResult, zero); 

    // DATA MEMORY
    Data_Memory d1(clk, MemWrite, ALUResult, readdata2, Read_Data); 
   
    // FOR SELECTING WRITEBACK INPUT FOR REGISTER FILE
    Mux_2to1 m3(ALUResult, Read_Data, Resultsrc, Result); 

endmodule



module RISCV_SCP_tb;

    // Clock and reset signals
    reg clk;
    reg rst;

    // Instantiate the RISCV_SCP module
    RISCV_SCP uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation: 50 MHz (20 ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // toggle clock every 10 ns
    end

    // Reset sequence
    initial begin
        rst = 1;               // Assert reset
        #15 rst = 0;           // Deassert reset after a short delay
    end

    // Load instructions into instruction memory and observe results
    initial begin
        // Monitor the outputs for observation
        $monitor("PC = %h, Instruction = %h, Result = %h, ALUResult = %h", 
                 uut.PC_OUT, uut.instruction, uut.Result, uut.ALUResult);
        
        // Initialize memory with custom instructions and observe register values

        // Example 1: LW (load word)
        #20; // wait for reset and clock
        // Expected Result: Result register should contain the data loaded from memory
        
        // Example 2: SW (store word)
        #40;
        // Expected Result: Memory should update with new data
        
        // Example 3: BEQ (branch if equal)
        #60;
        // Expected Result: PC should change to branch target address if condition is met
        
        // Example 4: ADD (R-type operation)
        #80;
        // Expected Result: ALUResult should show the sum of inputs
        
        // Example 5: ADDI (immediate addition)
        #100;
        // Expected Result: Register file should reflect the addition of a value and immediate

        // End of test
        #120;
        $finish;
    end
endmodule


