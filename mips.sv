module mips
    (input logic clk, reset,
    input logic [31:0] instr, readdata,
    output logic memwrite,
    output logic [31:0] pc, aluout, writedata);

    logic memtoreg, pcsrc, alusrc, regdst, regwrite, jump, zero;
    logic [2:0] alucontrol;

    datapath       dp(.clk(clk), .reset(reset), .memtoreg(memtoreg), .pcsrc(pcsrc), .alusrc(alusrc), .regdst(regdst), .regwrite(regwrite), .jump(jump), .zero(zero), .instr(instr), .readdata(readdata), .alucontrol(alucontrol), .pc(pc), .aluout(aluout), .writedata(writedata));

    controlunit    cl(.opcode(instr[31:26]), .funct(instr[5:0]), .Zero(zero), .RegWrite(regwrite), .RegDst(regdst), .ALUSrc(alusrc), .MemWrite(memwrite), .MemtoReg(memtoreg), .Jump(jump), .PCSrc(pcsrc), .alucontrol(alucontrol));

endmodule
