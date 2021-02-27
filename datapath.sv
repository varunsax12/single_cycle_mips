module datapath
    (input logic clk, reset, memtoreg, pcsrc, alusrc, regdst, regwrite, jump,
    input logic [2:0] alucontrol,
    input logic [31:0] instr, readdata,
    output logic zero,
    output logic [31:0] pc, aluout, writedata);

    // logic related to program counter segment
    logic [31:0] nextpc, pcplus4, signimm, signimmshift, pcbranch, pcnextbranch;

    // logic related to the regfile segment
    logic [4:0] writereg;
    logic [31:0] srca, srcb, result;

    // program counter logic
    mux2x1 #(32)    m1       (.ina(pcplus4), .inb(pcbranch), .control(pcsrc), .outdata(pcnextbranch));
    mux2x1 #(32)    m2       (.ina(pcnextbranch), .inb({pcplus4[31:28], instr[25:0], 2'b00}), .control(jump), .outdata(nextpc));
    dff             pcdff    (.clk(clk), .reset(reset), .q(pc), .d(nextpc));
    adder           pc4addr  (.ina(pc), .inb(32'b100), .outdata(pcplus4));
    adder           pcbr     (.ina(pcplus4), .inb(signimmshift), .outdata(pcbranch));
    shiftleft       sl1      (.indata(signimm), .outdata(signimmshift));

    // register file logic
    regfile         rf       (.clk(clk), .we(regwrite), .a1(instr[25:21]), .a2(instr[20:16]), .a3(writereg), .rd1(srca), .rd2(writedata), .wd3(result));
    mux2x1 #(5)     writemux (.ina(instr[20:16]), .inb(instr[15:11]), .control(regdst), .outdata(writereg));
    mux2x1 #(32)    srcbmux  (.ina(writedata), .inb(signimm), .control(alusrc), .outdata(srcb));
    signext         se       (.data(instr[15:0]), .outdata(signimm));

    // writeback logic
    mux2x1 #(32)    resmux   (.ina(aluout), .inb(readdata), .control(memtoreg), .outdata(result));

    // alu segment
    alu             mipsalu  (.srca(srca), .srcb(srcb), .control(alucontrol), .result(aluout), .zero(zero));

endmodule
