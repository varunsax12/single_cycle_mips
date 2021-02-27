module single_cycle_mips
    (input logic clk, reset,
    output logic [31:0] writedata, dataaddr,
    output logic memwrite);

    logic [31:0] instr, readdata, pc, aluout;

    mips mips (.clk(clk), .reset(reset), .instr(instr), .readdata(readdata), .memwrite(memwrite), .pc(pc), .aluout(dataaddr), .writedata(writedata));

    // memory init
    dmem dmem (.clk(clk), .we(memwrite), .addr(dataaddr), .writedata(writedata), .readdata(readdata));
    // using a part of the pc to  access the imem for smaller imem
    imem imem (.addr(pc[7:2]), .rd(instr));

endmodule
