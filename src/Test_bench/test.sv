class apb_test;
virtual apb_if drv_vif;
virtual apb_if mon_vif;
virtual apb_if ref_vif;
apb_environment env;
function new(virtual apb_if drv_vif, virtual apb_if mon_vif, virtual apb_if ref_vif);
this.drv_vif=drv_vif;
this.mon_vif=mon_vif;
this.ref_vif=ref_vif;
endfunction
task run();
env=new(drv_vif,mon_vif,ref_vif);
env.build();
env.start();
endtask
endclass
