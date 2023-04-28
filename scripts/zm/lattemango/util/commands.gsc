#include scripts\zm\afluffyofox\util\database;
#include scripts\zm\afluffyofox\util\debugprintf;
#include scripts\zm\afluffyofox\util\dvar;
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
    if (message[0] != self.pers["account_access_level"])
    {
        return;
    }

    command_array = strtok(message, " ");
    command = level.server_data["commands"][getsubstr(command_array[0], 1)];

    args = [];
    for (i = 1; i < command_array.size; i++)
    {
        args += command_array[i];
    }

    if (isdefined(command))
    {
        if (self.pers["account_access_level"] >= command["access_level"])
        {
            ret = self [[command["callback"]]](args);
            debugprintf("^5Called function " + command["name"] + " with args " + to_string(args));
            self tell("^2You executed a command!");
        }
        else
        {
            self tell("^1You don't have access to that command.");
        }
    }
}

init()
{
    init_dvar("command_access_default", 1);
    init_dvar("command_prefix_default", "!");
}
