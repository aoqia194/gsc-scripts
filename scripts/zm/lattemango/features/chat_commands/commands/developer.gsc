// Developed by lattemango

#include scripts\chat_commands;

/*devStructOut(struct)
{
    path = "playerData/" + self getGuid() + "/dev.txt";
    file = fopen(path, "w");
    structKeys = getStructKeys(struct);
    for (i = 0; i < structKeys.size; i++)
    {
        key = structKeys[i];
        val = structGet(struct, key);

        if (!((key + " : " + val) == "") || !(typeof((key + " : " + val)) == "undefined"))
        {
            fwrite(file, key + " : " + structGet(struct, key) + " : " + typeof(val) + "\n");
        }
    }
    fclose(file);
    debug_print("^2devStructOut() Completed!");
}*/

dev()
{
    ToggleStatus("chat_commands_debug", "chat_commands_debug", self);
    if (GetStatus("chat_commands_debug", self))
    {
        self enableInvulnerability();
        level.pers["chat_commands_debug"] = true;
    }
    else
    {
        self disableInvulnerability();
        level.pers["chat_commands_debug"] = false;
    }
}

devCommand(args)
{
    if (args.size > 0) { return; }
    error = dev();
    if (IsDefined(error)) { return error; }
}

init()
{
    // Create the chat commands here.
    CreateCommand(level.chat_commands["ports"], "dev", "function", ::devCommand, 3);
}
