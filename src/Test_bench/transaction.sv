include "defines.sv";
class apb_transaction;
rand bit transfer;
rand bit write_read;
rand bit [`ADDR_WIDTH-1:0]addr_in;
rand bit [`DATA_WIDTH-1:0] wdata_in;
rand bit [`DATA_WIDTH/8 -1:0]strb_in;
bit [`DATA_WIDTH-1:0] PRDATA;
bit PREADY, PSLVERR;
bit [`ADDR_WIDTH-1:0] PADDR;
bit PSEL, PENABLE,PWRITE;
bit [`DATA_WIDTH-1:0]PWDATA;
bit [`DATA_WIDTH/8 -1:0]PSTRB;
bit [`DATA_WIDTH-1:0]rdata_out;
bit transfer_done, error;
int wait_acc;
constraint c{ transfer==1;}
constraint strb{ if(write_read==0) strb_in==0;}
virtual function apb_transaction copy();
copy=new();
copy.transfer=transfer;
copy.write_read=write_read;
copy.addr_in=addr_in;
copy.wdata_in=wdata_in;
copy.strb_in=strb_in;
copy.PRDATA=PRDATA;
copy.PREADY=PREADY;
copy.PSLVERR=PSLVERR;
copy.PADDR=PADDR;
copy.PSEL=PSEL;
copy.PENABLE=PENABLE;
copy.PWRITE=PWRITE;
copy.PWDATA=PWDATA;
copy.PSTRB=PSTRB;
copy.rdata_out=rdata_out;
copy.transfer_done=transfer_done;
copy.error=error;
copy.wait_acc=wait_acc;
return copy;
endfunction
endclass
