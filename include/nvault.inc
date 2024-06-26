/* nVault functions
*
* by the AMX Mod X Development Team
*
* This file is provided as is (no warranties).
*/

#if defined _nvault_included
  #endinput
#endif
#define _nvault_included

#pragma library nvault

//Opens a vault by name (such as "myvault")
//Returns a vault id, INVALID_HANDLE otherwise (-1)
native nvault_open(const name[]);

//Gets a vault value by returning an int
// setting a byref float
// or setting a string + maxlength
native nvault_get(vault, const key[], ...);

//Looks up a vault value for full information
//Returns 0 if the entry is not found
native nvault_lookup(vault, const key[], value[], maxlen, &timestamp)

//Sets a vault value (with current timestamp)
native nvault_set(vault, const key[], const value[]);

//Sets a permanent vault value (no timestamp)
native nvault_pset(vault, const key[], const value[]);

//Prunes the vault for entries that are within the given timestamps.
//This will not erase values set with pset
native nvault_prune(vault, start, end);

//Closes a vault
native nvault_close(vault);
