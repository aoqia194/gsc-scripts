// afluffyofox

// My utility classes.
#include scripts\zm\afluffyofox\util\debugprintf;
#include scripts\zm\afluffyofox\util\mapname;
#include scripts\zm\afluffyofox\util\type;

get_playerdata_strings()
{
    return array("account_access_level", "account_command_prefix", "account_bank", "account_name", "account_rank", "account_records");
}

// The purpose of this function is to read from the json database and return it as usable data.
get_database()
{
    database_struct = readfile(level.server_data["database_path"]);
    return jsonParse(database_struct);
}

// The purpose of this function is to set the database file with the struct provided.
set_database(database_struct)
{
    writefile(level.server_data["database_path"], jsonserialize(database_struct, 4));
}

// This is the most ghetto way of doing it.
// If anyone has a more reasonable idea of doing backups then please tell me!
backup_database()
{
    backup_path = (level.server_data["path"] + "backups/");
    database_path = level.server_data["database_path"];

    if (!fileexists(database_path) || filesize(database_path) == 0)
    {
        debugprintf("^1Attempted to backup the database but it doesn't exist.");
        return;
    }

    data = readfile(database_path);

    if (!directoryexists(backup_path))
    {
        createdirectory(backup_path);
    }

    backups = listfiles(backup_path);
    if ((backups.size + 1) > 20)
    {
        foreach (file in backups)
        {
            fremove(file);
        }
    }

    writefile((backup_path + "backup_database_" + (backups.size + 1) + ".json"), data);
}

get_database_cache()
{
    return level.server_data["database_cache"];
}

// The purpose of this function is to set the database cache with the struct provided.
set_database_cache(database_struct)
{
    level.server_data["database_cache"] = database_struct;
}

// The purpose of this function is to read from the database.json file and set the cache.
update_database_cache()
{
    database_struct = get_database();
    set_database_cache(database_struct);
}

// The purpose of this function is to return the playerdata from the database.
get_playerdata()
{
    return get_database()["players"][to_string(self getguid())];
}

// The point of this function is to set the player's data specifically.
update_playerdata()
{
    database = get_database();
    playerdata = get_playerdata();

    stats = get_playerdata_strings();
    foreach (stat in stats)
    {
        playerdata[stat] = self.pers[stat];
    }

    database["players"][to_string(self getguid())] = playerdata;
    set_database(database);
}

create_playerdata(guid)
{
    guid = to_string(guid);
    playerdata = [];

    playerdata["players"][guid]["account_access_level"] = 1;
    playerdata["players"][guid]["account_command_prefix"] = "!";
    playerdata["players"][guid]["account_name"] = "";
    playerdata["players"][guid]["account_bank"] = 0;
    playerdata["players"][guid]["account_rank"] = 1;

    account_records = get_map_names();
    foreach (map in account_records)
    {
        playerdata["players"][guid]["account_records"][map] = 0;
    }

    return playerdata;
}

get_playerdata_cache()
{
    database_cache_struct = get_database_cache();
    return database_cache_struct["players"][to_string(self getguid())];
}

update_playerdata_cache()
{
    database = get_database_cache();
    playerdata = get_playerdata_cache();

    stats = get_playerdata_strings();
    foreach (stat in stats)
    {
        playerdata[stat] = self.pers[stat];
    }

    database["players"][to_string(self getguid())] = playerdata;
    set_database_cache(database);
}

// The purpose of this function is to return the recorddata for this map from the database.
get_recorddata()
{
    database_struct = get_database();
    return database_struct["records"][get_map_name()];
}

// The point of this function is to update the server's record data specifically.
update_recorddata()
{
    database = get_database();

    record_set_by = "";
    for (i = 0; i < level.players.size; i++)
    {
        record_set_by += level.players[i].pers["account_name"];

        if ((i + 1) != level.players.size)
        {
            record_set_by += ", ";
        }
    }

    recorddata = get_recorddata();
    recorddata["record"] = level.round_number;
    recorddata["record_set_by"] = record_set_by;

    database["records"][get_map_name()] = recorddata;
    set_database(database);
}

create_recorddata()
{
    recorddata = [];

    record = [];
    record["record"] = 0;
    record["record_set_by"] = "";

    maps = get_map_names();
    foreach (map in maps)
    {
        recorddata["records"][map] = record;
    }
    return recorddata;
}

get_recorddata_cache()
{
    database_cache_struct = get_database_cache();
    return database_cache_struct["records"][get_map_name()];
}

update_recorddata_cache()
{
    database = get_database_cache();

    record_set_by = "";
    for (i = 0; i < level.players.size; i++)
    {
        record_set_by += level.players[i].pers["account_name"];

        if ((i + 1) != level.players.size)
        {
            record_set_by += ", ";
        }
    }

    recorddata = get_recorddata_cache();
    recorddata["record"] = level.round_number;
    recorddata["record_set_by"] = record_set_by;

    database["records"][get_map_name()] = recorddata;
    set_database_cache(database);
}

// The goal of this is to make sure database.json exists
init_database()
{
    path = level.server_data["database_path"];

    if (fileexists(path))
    {
        data = to_string(readfile(path));
        if (!bad_string(data) || filesize(path) != 0)
        {
            update_database_cache();
            debugprintf("^2The database is now snug!");
            return;
        }
    }

    debugprintf("^3Database not found. Creating new database.");

    // If the database doesn't exist, we retry infinitely until we can make it exist.
    while(!fileexists(path))
    {
        writefile(path, "");
        wait 1;
    }

    defaultdata = create_playerdata(0);
    defaultdata["records"] = create_recorddata()["records"];

    // Open the file we just created and initialise it with default JSON data.
    writefile(path, jsonserialize(defaultdata, 4));

    update_database_cache();
    debugprintf("^2The database is now snug!");
}

init_player_cache()
{
    self endon("disconnect");

    playerdata = self get_playerdata_cache();
    guid = to_string(self getguid());

    if (!isdefined(playerdata))
    {
        debugprintf("^3Playerdata was not found. Creating new playerdata.");

        database = get_database_cache();
        database["players"][guid] = create_playerdata(guid)["players"][guid];
        set_database_cache(database);
        playerdata = database["players"][guid];

        debugprintf(guid, "^2New playerdata created!");
    }

    stats = get_playerdata_strings();
    foreach (stat in stats)
    {
        self.pers[stat] = playerdata[stat];
    }
    self.pers["account_name"] = self.name;

    // Set this so the player can't use their in game bank to essentially 'duplicate' their money.
    self.account_value = (self.pers["account_bank"] / 1000);

    debugprintf(guid, "^2Playerdata is now snug!");
}

on_player_connect()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread init_player_cache();
    }
}

save_game_data()
{
    if (level.players.size != 0)
    {
        foreach (player in level.players)
        {
            player.pers["account_records"][get_map_name()] = level.round_number;
            player update_playerdata_cache();
        }

        update_recorddata_cache();
    }
    else
    {
        debugprintf("^3There are no players currently playing, so we can't save any records.");
    }

    database_cache_struct = get_database_cache();
    set_database(database_cache_struct);

    backup_database();
}

on_game_end()
{
    for (;;)
    {
        level waittill("end_game");
        level thread save_game_data();
    }
}

init()
{
    level.server_data["database_path"] = level.server_data["path"] + "database.json";
    level.server_data["database_cache"] = [];

    init_database();
    level thread on_player_connect();
    level thread on_game_end();
}
