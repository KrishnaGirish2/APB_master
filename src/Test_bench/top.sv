module top();
import apb_pkg::*;
bit PCLK;
bit PRESETn;
initial begin
PCLK=0;
forever  #10 PCLK=~PCLK;
end
initial begin
PRESETn=0;
repeat(2)@(posedge PCLK);
PRESETn=1;
end

apb_if intrf(PCLK,PRESETn);
apb_master #(.ADDR_WIDTH(8), .DATA_WIDTH(32)) DUV (.PCLK(PCLK),.PRESETn(PRESETn),.transfer(intrf.transfer),.write_read(intrf.write_read),.addr_in(intrf.addr_in),.wdata_in(intrf.wdata_in),.strb_in(intrf.strb_in),.PRDATA(intrf.PRDATA),.PREADY(intrf.PREADY),.PSLVERR(intrf.PSLVERR),.PADDR(intrf.PADDR),.PSEL(intrf.PSEL),.PENABLE(intrf.PENABLE),.PWRITE(intrf.PWRITE),.PWDATA(intrf.PWDATA),.PSTRB(intrf.PSTRB),.rdata_out(intrf.rdata_out),.transfer_done(intrf.transfer_done),.error(intrf.error));
apb_test tb=new(intrf.DRV,intrf.MON,intrf.REF_SB);
initial begin
tb.run();
#1000;
$finish;
end
endmodule
