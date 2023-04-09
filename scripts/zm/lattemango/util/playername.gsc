playername_get()
{
    return self.pers["account_name"];
}

on_player_connected()
{
    for (;;)
    {
        level waittill("connected", player);
        level endon("disconnect");
        
        player.pers["account_username"] = player.name;
    }
}

init()
{
    level thread on_player_connected();
}