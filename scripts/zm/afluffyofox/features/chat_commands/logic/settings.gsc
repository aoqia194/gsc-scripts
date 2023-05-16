#include scripts\zm\afluffyofox\util\database;

set_prefix(prefix)
{
    self.pers["account_command_prefix"] = prefix;
    self update_playerdata_cache();
}
