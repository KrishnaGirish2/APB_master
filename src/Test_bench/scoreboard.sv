`include "defines.sv"
class apb_scoreboard;
apb_transaction ref2sb_trans, mon2sb_trans;
mailbox #(apb_transaction) mbx_rs;
mailbox #(apb_transaction) mbx_ms;
int pass=0;
int fail=0;
function new(mailbox #(apb_transaction) mbx_rs, mailbox #(apb_transaction)mbx_ms);
this.mbx_rs=mbx_rs;
this.mbx_ms=mbx_ms;
endfunction
task start();
for(int i=0;i<`no_of_trans;i++) begin
ref2sb_trans=new();
mon2sb_trans=new();
mbx_ms.get(mon2sb_trans);
mbx_rs.get(ref2sb_trans);
compare_report();
end
endtask
task compare_report();

if((mon2sb_trans.PSEL==ref2sb_trans.PSEL) && (mon2sb_trans.PENABLE==ref2sb_trans.PENABLE) && (mon2sb_trans.PWRITE==ref2sb_trans.PWRITE) &&
(mon2sb_trans.PADDR ==ref2sb_trans.PADDR)&&
(mon2sb_trans.PWDATA ==ref2sb_trans.PWDATA)&&
(mon2sb_trans.PSTRB==ref2sb_trans.PSTRB)&&
(mon2sb_trans.rdata_out==ref2sb_trans.rdata_out)&&
(mon2sb_trans.transfer_done==ref2sb_trans.transfer_done)&&
(mon2sb_trans.error==ref2sb_trans.error)) begin
pass++;
$display("Pass");
end
else begin
fail++;
$display("Fail: scoreboard data: PSEL=%0d PENABLE=%0d PWRITE=%0d PADDR=%0d PWDATA=%0d PSTRB=%0d PRDATA=%0d done=%0d error=%0d",ref2sb_trans.PSEL,ref2sb_trans.PENABLE,ref2sb_trans.PWRITE,ref2sb_trans.PADDR,ref2sb_trans.PWDATA,ref2sb_trans.PSTRB,ref2sb_trans.rdata_out,ref2sb_trans.transfer_done,ref2sb_trans.error);
$display("monitor data : PSEL=%0d PENABLE=%0d PWRITE=%0d PADDR=%0d PWDATA=%0d PSTRB=%0d PRDATA=%0d done=%0d error=%0d",mon2sb_trans.PSEL,mon2sb_trans.PENABLE,mon2sb_trans.PWRITE,mon2sb_trans.PADDR,mon2sb_trans.PWDATA,mon2sb_trans.PSTRB,mon2sb_trans.rdata_out,mon2sb_trans.transfer_done,mon2sb_trans.error);
end
$display("Pass:%0d ",pass);
$display("Fail: %0d ",fail);
endtask
endclass
