`include "defines.sv"
class apb_environment;
  virtual apb_if drv_vif;
  virtual apb_if mon_vif;
  mailbox #(apb_transaction) mbx_gd;
  mailbox #(apb_transaction) mbx_ds;
  mailbox #(apb_transaction) mbx_ms;
  apb_generator gen;
  apb_driver drv;
  apb_monitor mon;
  apb_scoreboard scb;
  function new(virtual apb_if drv_vif, virtual apb_if mon_vif);
    this.drv_vif=drv_vif;
    this.mon_vif=mon_vif;
  endfunction
  task build(); begin
    mbx_gd=new();
    mbx_ds=new();
    mbx_ms=new();
    gen=new(mbx_gd);
    drv=new(mbx_gd,mbx_ds,drv_vif);
    mon=new(mon_vif,mbx_ms);  
    scb=new(mbx_ds,mbx_ms);
    end
  endtask
  task start();
    fork
      gen.start();
      drv.start();
      mon.start();
      scb.start();
    join
  endtask
endclass

