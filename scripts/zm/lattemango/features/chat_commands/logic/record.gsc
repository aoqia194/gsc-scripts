// Developed by lattemango

// My utility classes.
#include scripts\zm\lattemango\util\database;
#include scripts\zm\lattemango\util\debugprintf;
#include scripts\zm\lattemango\util\mapname;
#include scripts\zm\lattemango\util\playername;
#include scripts\zm\lattemango\util\string;

record_display_player()
{
    mapname = mapname_get_fancy();
    account_record = self.pers["account_records"][mapname_get()];
    player_name = self playername_get();
    if (account_record > 0)
    {
        say("^6" + player_name + "^7's personal record is at ^2Round " + account_record + "^7.");
    }
    else
    {
        say("^6" + player_name + "^7 has no record for ^1" + mapname + "^7.");
    }
}

record_display_server()
{
    server_record = database_get_recorddata();
    mapname = mapname_get_fancy();

    if (server_record["record"] == 0 || server_record["record_set_by"] == "")
    {
        say("There are no records stored for ^1" + mapname + "^7.");
    }
    else
    {
        say("The server's record for ^1" + mapname + "^7 is set by ^6" + server_record["record_set_by"] + "^7 at ^2Round " + server_record["record"] + "^7.");
    }
}

player_update()
{
    for (;;)
    {
        level waittill("connected", player);
        level waittill("start_of_round");
        level endon("disconnect");

        mapname = mapname_get();
        player_record = player.pers["account_records"][mapname];
        if (level.round_number == player_record)
        {
            say("^6" + player playername_get() + "^7 is about to beat their personal record!");
            player thread record_display_player();
        }
    }
}

round_update()
{
    for (;;)
    {
        level waittill("start_of_round");
        level endon("end_game");

        server_record = database_get_recorddata();
        if (level.round_number == server_record["record"])
        {
            say("You are about to beat the server record! Good luck.");
            level thread record_display_server();
        }
    }
}

record_update()
{
    for (;;)
    {
        level waittill("end_game");

        if (level.players.size == 0)
        {
            debug_printf("^1There needs to be at least 1 player to save the recorddata!");
            return;
        }

        // Update everyone's record.
        foreach (player in level.players)
        {
            player.pers["account_records"][mapname_get()] = level.round_number;
            player database_update_playerdata();
        }

        // Update the server's record.
        database_update_recorddata();
    }
}

init()
{
    level thread record_update();
    level thread round_update();
    level thread player_update();
}

