`include "defines.sv"

class apb_reference_model;
apb_transaction ref_trans;
mailbox #(apb_transaction) mbx_dr;
mailbox #(apb_transaction) mbx_rs;
virtual apb_if.REF vif;
function new(mailbox #(apb_transaction) mbx_dr,mailbox #(apb_transaction) mbx_rs,virtual apb_if.REF vif);
this.mbx_dr=mbx_dr;
this.mbx_rs= mbx_rs;
this.vif = vif;
endfunction

task start();
wait(vif.ref_cb.PRESETn);
for(int i=0;i<`no_of_trans;i++) begin
ref_trans=new();
mbx_dr.get(ref_trans);
ref_trans.PSEL=1;
ref_trans.PENABLE= 1;
ref_trans.PWRITE= ref_trans.write_read;
ref_trans.PADDR = ref_trans.addr_in;
if(ref_trans.write_read) begin
ref_trans.PWDATA= ref_trans.wdata_in;
ref_trans.PSTRB= ref_trans.strb_in;
end
else begin
ref_trans.PWDATA=0;
ref_trans.PSTRB= 0;
end
ref_trans.transfer_done = 0;
ref_trans.error = 0;
ref_trans.rdata_out = vif.ref_cb.PRDATA;
mbx_rs.put(ref_trans);
end
endtask
endclass


