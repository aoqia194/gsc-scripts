set_prefix(prefix)
{
    prefix = to_string(prefix);
    self.pers["account_command_prefix"] = prefix;
    self update_playerdata_cache();
}
