// Developed by lattemango

// My utility classes.
#include scripts\zm\lattemango\util\database;
#include scripts\zm\lattemango\util\debugprintf;
#include scripts\zm\lattemango\util\mapname;
#include scripts\zm\lattemango\util\playername;
#include scripts\zm\lattemango\util\string;

record_display_player()
{
    account_record = self.pers["account_records"][mapname_get()];
    player_name = self playername_get();
    
    if (int64_op(account_record, ">", 0))
    {
        say("^6" + player_name + "^7's personal record is at ^2Round " + account_record + "^7.");
    }
    else
    {
        say("^6" + player_name + "^7 has no record for ^1" + mapname_get_fancy() + "^7.");
    }
}

record_display_server()
{
    server_record = database_recorddata_get();
    mapname = mapname_get_fancy();

    if (int64_op(server_record["record"], "==", 0) || int64_op(server_record["record_set_by"], "==", ""))
    {
        say("There are no records stored for ^1" + mapname + "^7.");
    }
    else
    {
        say("The server's record for ^1" + mapname + "^7 is set by ^6" + server_record["record_set_by"] + "^7 at ^2Round " + server_record["record"] + "^7.");
    }
}

record_update()
{
    for (;;)
    {
        level waittill("end_game");

        if (level.players.size == 0)
        {
            debugprintf("RECORD", "^3NO_PLAYERS CANT_SAVE CONTINUE");
            return;
        }

        foreach (player in level.players)
        {
            player.pers["account_records"][mapname_get()] = level.round_number;
            player database_cache_playerdata_update();
        }

        // Update the server's record.
        database_cache_recorddata_update();
        level notify("record_update_done");
    }
}

round_update()
{
    for (;;)
    {
        level waittill("start_of_round");
        level endon("end_game");

        if (level.round_number == database_cache_recorddata_get()["record"] && level.round_number != 1)
        {
            say("You are about to beat the server record! Good luck.");
            level thread record_display_server();
        }
    }
}

on_player_connect()
{
    for (;;)
    {
        level waittill("connected", player);
        level waittill("start_of_round");
        player endon("disconnect");

        if (level.round_number == player.pers["account_records"][mapname_get()] && level.round_number != 1)
        {
            say("^6" + player playername_get() + "^7 is about to beat their personal record!");
            player thread record_display_player();
        }
    }
}

init()
{
    level thread record_update();
    level thread round_update();
    level thread on_player_connect();
}

