#include scripts\zm\afluffyofox\util\array;
#include scripts\zm\afluffyofox\util\database;
#include scripts\zm\afluffyofox\util\debugprintf;
#include scripts\zm\afluffyofox\util\type;

create_command(name, callback, access_level)
{
    if (!isarray(name))
    {
        name = array(name);
    }

    foreach (command in name)
    {
        level.server_data["commands"][command]["name"] = command;
        level.server_data["commands"][command]["callback"] = callback;
        level.server_data["commands"][command]["access_level"] = access_level;
    }
}

on_player_message(message)
{
    if (message[0] != self.pers["account_command_prefix"])
    {
        debugprintf(undefined, "^1Isn't a command.");
        return;
    }

    message_array = strtok(message, " ");
    command_name = getsubstr(message_array[0], 1);
    command_struct = level.server_data["commands"][command_name];

    args = [];
    for (i = 1; i < message_array.size; i++)
    {
        args[i - 1] = message_array[i];
    }

    debugprintf(undefined, "^3Is command struct defined? " + isdefined(command_struct));
    if (isdefined(command_struct))
    {
        if (self.pers["account_access_level"] >= command_struct["access_level"])
        {
            debugprintf(undefined, "^2Has access!");
            ret = self [[command_struct["callback"]]](args);
        }
        else
        {
            self tell("^1You don't have access to that command.");
        }
    }
}
