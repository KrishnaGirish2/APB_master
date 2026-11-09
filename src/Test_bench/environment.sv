`include "defines.sv"
class apb_environment;
  virtual apb_if drv_vif;
  virtual apb_if mon_vif;
  virtual apb_if out_mon_vif;
  mailbox #(apb_transaction) mbx_gd;
  mailbox #(apb_transaction) mbx_im;
  mailbox #(apb_transaction) mbx_om;
  apb_generator gen;
  apb_driver drv;
  apb_monitor mon;
  apb_output_monitor out_mon;
  apb_scoreboard scb;
  function new(virtual apb_if drv_vif, virtual apb_if mon_vif, virtual apb_if out_mon_vif);
    this.drv_vif=drv_vif;
    this.mon_vif=mon_vif;
    this.out_mon_vif=out_mon_vif;
  endfunction
  task build(); begin
    mbx_gd=new();
    mbx_im=new();
    mbx_om=new();
    gen=new(mbx_gd);
    drv=new(mbx_gd,drv_vif);
    mon=new(mon_vif,mbx_im);  
    out_mon=new(out_mon_vif,mbx_om);
    scb=new(mbx_im,mbx_om);
    end
  endtask
  task start();
    fork
      gen.start();
      drv.start();
      mon.start();
      out_mon.start();
      scb.start();
    join
  endtask
endclass
