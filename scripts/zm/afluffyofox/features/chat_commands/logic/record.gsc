// afluffyofox

#include scripts\zm\afluffyofox\util\database;
#include scripts\zm\afluffyofox\util\debugprintf;
#include scripts\zm\afluffyofox\util\mapname;

get_player_record()
{
    record = self.pers["account_records"][get_map_name()];

    if (!isdefined(record))
    {
        debugprintf("RECORD::PLAYER", "^1NOT_FOUND");
        return undefined;
    }

    return record;
}

display_player_record()
{
    record = self get_player_record();
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
        say("^6" + player_name + "^7 has no record for ^1" + get_map_name_fancy() + "^7.");
    }
}

get_server_record()
{
    database_cache_struct = get_database_cache();
    record = database_cache_struct["records"][get_map_name()];

    if (!isdefined(record))
    {
        debugprintf("RECORD::SERVER", "^1NOT_FOUND");
        return undefined;
    }

    return record;
}

display_server_record()
{
    record = get_server_record();
    if (!isdefined(record))
    {
        say("^1There was an error getting the server records.");
        return;
    }

    mapname = get_map_name_fancy();

    if (int64_op(record["record"], "==", 0) || int64_op(record["record_set_by"], "==", ""))
    {
        say("There are no records stored for ^1" + mapname + "^7.");
    }
    else
    {
        say("The server's record for ^1" + mapname + "^7 is set by ^6" + record["record_set_by"] + "^7 at ^2Round " + record["record"] + "^7.");
    }
}

server_milestone()
{
    if (level.round_number == get_recorddata_cache()["record"] && level.round_number != 1)
    {
        say("You are about to beat the server record! Good luck.");
        display_server_record();
    }
}

start_of_round()
{
    for (;;)
    {
        level waittill("start_of_round");
        level endon("end_game");

        level thread server_milestone();
    }
}

player_milestone()
{
    level waittill("start_of_round");
    level endon("end_game");

    record = self.pers["account_records"][get_map_name()];
    if (record == 0)
    {
        return;
    }

    if (level.round_number == record && level.round_number != 1)
    {
        say("^6" + self.pers["account_name"] + "^7 is about to beat their personal record!");
        self thread display_player_record();
    }
}

on_player_connect()
{
    for (;;)
    {
        level waittill("connected", player);

        player thread player_milestone();
    }
}

init()
{
    level thread on_player_connect();
    level thread start_of_round();
}

