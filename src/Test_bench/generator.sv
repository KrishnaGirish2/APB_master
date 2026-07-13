`include "defines.sv"
class apb_generator;
apb_transaction blueprint;
mailbox #(apb_transaction)mbx_gd;
function new(mailbox #(apb_transaction)mbx_gd);
this.mbx_gd=mbx_gd;
blueprint=new();
endfunction

task start();
for(int i=0;i<`no_of_trans;i++) begin
blueprint.randomize();
mbx_gd.put(blueprint.copy());
$display("Generator Randomized transaction %0d",i+1);
$display("transfer=%d write_read=%d addr_in=%d wdata_in=%d strb_in=%d time=%0d",blueprint.transfer, blueprint.write_read,blueprint.addr_in, blueprint.wdata_in, blueprint.strb_in, $time);
end
endtask
endclass
