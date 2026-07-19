class apb_test;
  virtual apb_if drv_vif;
  virtual apb_if mon_vif;
  apb_environment env;
  function new(virtual apb_if drv_vif, virtual apb_if mon_vif);
    this.drv_vif=drv_vif;
    this.mon_vif=mon_vif;
  endfunction
  task run();
    env=new(drv_vif,mon_vif);
    env.build();
    env.start();
  endtask
endclass
