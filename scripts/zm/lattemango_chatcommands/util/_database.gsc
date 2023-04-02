// Developed by lattemango!

#include scripts\zm\lattemango_chatcommands\util\_debugprint;
#include scripts\zm\lattemango_chatcommands\util\_tostring;

create_default_json(guid)
{
    default_json = [];
    default_json["players"][tostring(guid)]["account_bank"] = 0;
    default_json["players"][tostring(guid)]["account_rank"] = 1;
    debug_print("default_json=" + jsonSerialize(default_json, 4));
    return default_json;
}

// The purpose of this function is to read from the json database and return it as usable data.
database_get()
{
    path = level.server_data["path"];

    file = fopen(path, "r");
    json = fread(file);
    fclose(file);

    return jsonParse(json);
}

// The purpose of this function is to update the database file with the json provided.
database_update(json)
{
    path = level.server_data["path"];
    file = fopen(path, "w");
    fwrite(file, jsonSerialize(json, 4));
    fclose(file);
    debug_print("^2Database updated!");
}

// The point of this function is to update the player's data specifically.
database_update_playerdata()
{
    database = database_get();

    player_database = database_get_playerdata();
    player_database["account_bank"] = self.pers["account_bank"];
    player_database["account_rank"] = self.pers["account_rank"];

    database["players"][tostring(self getGuid())] = player_database;
    database_update(database);
}

// The purpose of this function is to return the playerdata from the database.
database_get_playerdata()
{
    return database_get()["players"][tostring(self getguid())];
}

// The purpose of this function is to set the player entity's data from the database.
database_initialise_player()
{
    player_data = self database_get_playerdata();

    if (!isdefined(player_data))
    {
        guid = self getguid();
        database = database_get();

        default_json = create_default_json(guid);
        database["players"][tostring(guid)] = default_json["players"][tostring(guid)];
        database_update(database);

        debug_print("^2Created new playerdata!");

        player_data = database;
    }

    self.pers["account_bank"] = player_data["account_bank"];
    self.pers["account_rank"] = player_data["account_rank"];

    // Set this so the player can't use their in game bank.
    // If you want them to use their in game bank, you have to modify maps\mp\zombies\_zm_banking.gsc
    self.account_value = (self.pers["account_bank"] / 1000);
    debug_print("^2Playerdata initialised!");
}

on_player_connected()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread database_initialise_player();
    }
}

// The goal of database_initialise is to make sure database.json exists
database_initialise()
{
    path = level.server_data["path"];

    if (fileExists(path))
    {
        data = tostring(readFile(path));
        if (!(data == "" || data == " " || fileSize(path) == 0))
        {
            debug_print("^2Database found.");
            return;
        }

        debug_print("^1Database was corrupted. Creating new database...");
    }

    // If the database doesn't exist, we retry infinitely until we can make it exist.
    while(!fileExists(path))
    {
        writeFile(path, "");
        wait 1;
    }

    default_json = create_default_json(0);

    // Open the file we just created and initialise it with default JSON data.
    file = fopen(path, "w");
    fwrite(file, jsonSerialize(default_json, 4));
    fclose(file);
    debug_print("^2New database initialised.");
}

init()
{
    printf("Executed \'scripts/zm/lattemango_chatcommands/util/_database::init\'");
    level.server_data["path"] = "server_data/database.json";
    database_initialise();
    thread on_player_connected();
}
