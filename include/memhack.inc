#include <memhack_const>

native memhack_get_char(address,baseaddress = MEM_DLLBASE, memtype = MEMTYPE_DATA, signtype = MEM_SIGNED);
native memhack_get_short(address,baseaddress = MEM_DLLBASE, memtype = MEMTYPE_DATA, signtype = MEM_SIGNED);
native memhack_get_long(address,baseaddress = MEM_DLLBASE, memtype = MEMTYPE_DATA, signtype = MEM_SIGNED);

native Float:memhack_get_float(address,baseaddress = MEM_DLLBASE, memtype = MEMTYPE_DATA);
native Float:memhack_get_quad(address,baseaddress = MEM_DLLBASE, memtype = MEMTYPE_DATA);
native memhack_get_pointer(address,baseaddress = MEM_DLLBASE, memtype = MEMTYPE_DATA);

native memhack_set_char(address,baseaddress = MEM_DLLBASE, new_val, memtype = MEMTYPE_DATA, signtype = MEM_SIGNED);
native memhack_set_short(address,baseaddress = MEM_DLLBASE, new_val, memtype = MEMTYPE_DATA, signtype = MEM_SIGNED);
native memhack_set_long(address,baseaddress = MEM_DLLBASE, new_val, memtype = MEMTYPE_DATA, signtype = MEM_SIGNED);

native memhack_set_float(address,baseaddress = MEM_DLLBASE, Float:new_val, memtype = MEMTYPE_DATA);
native memhack_set_quad(address,baseaddress = MEM_DLLBASE,Float:new_val, memtype = MEMTYPE_DATA);
native memhack_set_pointer(address,baseaddress = MEM_DLLBASE, new_val, memtype = MEMTYPE_DATA);

native memhack_get_base(func_addr,&success);
native memhack_get_realaddr(address,baseaddress,memtype = MEMTYPE_DATA);
native memhack_return_addr(baseaddress = MEM_DLLBASE)