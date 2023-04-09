// Developed by lattemango!

// My utility classes.
#include scripts\zm\lattemango\util\debugprintf;
#include scripts\zm\lattemango\util\mapname;
#include scripts\zm\lattemango\util\string;

create_default_playerdata(guid)
{
    guid = string_tostring(guid);

    default_playerdata = [];
    default_playerdata["players"][guid]["account_name"] = "";
    default_playerdata["players"][guid]["account_bank"] = 0;
    default_playerdata["players"][guid]["account_rank"] = 1;
    default_playerdata["players"][guid]["account_records"]["zm_transit"] = 0;
    default_playerdata["players"][guid]["account_records"]["zm_town"] = 0;
    default_playerdata["players"][guid]["account_records"]["zm_farm"] = 0;
    default_playerdata["players"][guid]["account_records"]["zm_nuked"] = 0;
    default_playerdata["players"][guid]["account_records"]["zm_highrise"] = 0;
    default_playerdata["players"][guid]["account_records"]["zm_prison"] = 0;
    default_playerdata["players"][guid]["account_records"]["zm_buried"] = 0;
    default_playerdata["players"][guid]["account_records"]["zm_tomb"] = 0;
    return default_playerdata;
}

create_default_recorddata()
{
    default_record = [];
    default_record["record"] = 0;
    default_record["record_set_by"] = "";

    default_recorddata = [];
    default_recorddata["records"]["zm_transit"] = default_record;
    default_recorddata["records"]["zm_town"] = default_record;
    default_recorddata["records"]["zm_farm"] = default_record;
    default_recorddata["records"]["zm_nuked"] = default_record;
    default_recorddata["records"]["zm_highrise"] = default_record;
    default_recorddata["records"]["zm_prison"] = default_record;
    default_recorddata["records"]["zm_buried"] = default_record;
    default_recorddata["records"]["zm_tomb"] = default_record;
    return default_recorddata;
}

// The purpose of this function is to read from the json database and return it as usable data.
database_get()
{
    debug_printf("^3Trying to get the database...");

    path = level.server_data["path"];

    file = fopen(path, "r");
    json = fread(file);
    fclose(file);

    debug_printf("^2Database successfully read.");
    return jsonParse(json);
}

// The purpose of this function is to update the database file with the json provided.
database_update(json)
{
    debug_printf("^3Trying to update the database...");

    path = level.server_data["path"];
    file = fopen(path, "w");
    fwrite(file, jsonSerialize(json, 4));
    fclose(file);

    debug_printf("^2Database updated.");
}

// The point of this function is to update the player's data specifically.
database_update_playerdata()
{
    debug_printf("^3Trying to update playerdata...");

    database = database_get();

    player_data = database_get_playerdata();
    player_data["account_name"] = self.pers["account_name"];
    player_data["account_bank"] = self.pers["account_bank"];
    player_data["account_rank"] = self.pers["account_rank"];
    player_data["account_records"] = self.pers["account_records"];

    database["players"][string_tostring(self getGuid())] = player_data;
    database_update(database);

    debug_printf("^2Playerdata updated.");
}

// The point of this function is to update the server's record data specifically.
database_update_recorddata()
{
    debug_printf("^3Trying to update recorddata...");

    database = database_get();

    record_set_by = "";
    for (i = 0; i < level.players.size; i++)
    {
        record_set_by += level.players[i].pers["account_name"];

        if ((i + 1) != level.players.size)
        {
            record_set_by += ", ";
        }
    }

    record_data = database_get_recorddata();
    record_data["record"] = level.round_number;
    record_data["record_set_by"] = record_set_by;

    database["records"][mapname_get()] = record_data;
    database_update(database);

    debug_printf("^2Recorddata updated.");
}

// The purpose of this function is to return the playerdata from the database.
database_get_playerdata()
{
    return database_get()["players"][string_tostring(self getguid())];
}

// The purpose of this function is to return the recorddata for this map from the database.
database_get_recorddata()
{
    return database_get()["records"][mapname_get()];
}

// The goal of database_initialise is to make sure database.json exists
database_initialise()
{
    debug_printf("^3Initialising database...");
    path = level.server_data["path"];

    if (fileExists(path))
    {
        data = string_tostring(readFile(path));
        if (!(data == "" || data == " " || data == "null" || fileSize(path) == 0))
        {
            debug_printf("^2Database file found!");
            return;
        }
    }

    debug_printf("^3Database not found! Trying to create...");

    // If the database doesn't exist, we retry infinitely until we can make it exist.
    while(!fileExists(path))
    {
        writeFile(path, "");
        wait 1;
    }

    debug_printf("^3Writing default JSON...");

    default_data = create_default_playerdata(0);
    default_data["records"] = create_default_recorddata()["records"];

    // Open the file we just created and initialise it with default JSON data.
    file = fopen(path, "w");
    fwrite(file, jsonSerialize(default_data, 4));
    fclose(file);

    debug_printf("^2Database initialised.");
}

// The purpose of this function is to set the player entity's data from the database.
database_initialise_player()
{
    player_data = self database_get_playerdata();

    if (!isdefined(player_data))
    {
        debug_printf("^3Playerdata not defined. Creating new playerdata...");
        guid = string_tostring(self getguid());
        database = database_get();

        database["players"][guid] = create_default_playerdata(guid)["players"][guid];
        database_update(database);
        player_data = database["players"][guid];

        debug_printf("^2Playerdata successfully created.");
    }
    else
    {
        debug_printf("^2Playerdata found.");
    }

    self.pers["account_bank"] = player_data["account_bank"];
    self.pers["account_rank"] = player_data["account_rank"];
    self.pers["account_records"] = player_data["account_records"];
    self.pers["account_name"] = self.name;

    // Set this so the player can't use their in game bank to essentially 'duplicate' their money.
    self.account_value = (self.pers["account_bank"] / 1000);

    debug_printf("^2Playerdata initialised.");
}

on_player_connected()
{
    for (;;)
    {
        level waittill("connected", player);
        level endon("disconnect");
        player thread database_initialise_player();
    }
}

init()
{
    level.server_data["path"] = "server_data/database.json";

    database_initialise();
    level thread on_player_connected();
}
