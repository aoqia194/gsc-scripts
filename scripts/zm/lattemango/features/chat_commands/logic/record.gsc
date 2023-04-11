// Developed by lattemango

// My utility classes.
#include scripts\zm\lattemango\util\database;
#include scripts\zm\lattemango\util\debugprintf;
#include scripts\zm\lattemango\util\mapname;
#include scripts\zm\lattemango\util\type;

record_player_get()
{
    record = self.pers["account_records"][mapname_get()];

    if (!isdefined(record))
    {
        debugprintf("RECORD::PLAYER", "^1NOT_FOUND");
        return undefined;
    }

    return record;
}

record_player_display()
{
    record = self record_player_get();
    if (!isdefined(record))
    {
        say("^1There was an error getting the player records.");
        return;
    }

    player_name = self.pers["account_name"];
    
    if (int64_op(record, ">", 0))
    {
        say("^6" + player_name + "^7's personal record is at ^2Round " + record + "^7.");
    }
    else
    {
        say("^6" + player_name + "^7 has no record for ^1" + mapname_get_fancy() + "^7.");
    }
}

record_server_get()
{
    database_cache_struct = database_cache_get();
    record = database_cache_struct["records"][mapname_get()];

    if (!isdefined(record))
    {
        debugprintf("RECORD::SERVER", "^1NOT_FOUND");
        return undefined;
    }
    
    return record;
}

record_server_display()
{
    record = record_server_get();
    if (!isdefined(record))
    {
        say("^1There was an error getting the server records.");
        return;
    }

    mapname = mapname_get_fancy();

    if (int64_op(record["record"], "==", 0) || int64_op(record["record_set_by"], "==", ""))
    {
        say("There are no records stored for ^1" + mapname + "^7.");
    }
    else
    {
        say("The server's record for ^1" + mapname + "^7 is set by ^6" + record["record_set_by"] + "^7 at ^2Round " + record["record"] + "^7.");
    }
}

record_update()
{
    for (;;)
    {
        level waittill("end_game");

        if (level.players.size != 0)
        {
            foreach (player in level.players)
            {
                player.pers["account_records"][mapname_get()] = level.round_number;
                    player database_cache_playerdata_update();
            }
            
            database_cache_recorddata_update();
        }
        else
        {
            debugprintf("RECORD", "^3NO_PLAYERS CANT_SAVE CONTINUE");
        }

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
            level thread record_server_display();
        }
    }
}

record_player_milestone()
{
    record = self.pers["account_records"][mapname_get()];
    if (record == 0)
    {
        return;
    }

    if (level.round_number == record && level.round_number != 1)
    {
        say("^6" + self.pers["account_name"] + "^7 is about to beat their personal record!");
        self thread record_player_display();
    }
}

on_player_connect()
{
    for (;;)
    {
        level waittill("connected", player);
        level waittill("start_of_round");

        player thread record_player_milestone();
    }
}

init()
{
    level thread record_update();
    level thread round_update();
    level thread on_player_connect();
}

