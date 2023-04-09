// Developed by lattemango

// Resxt's base chat commands script.
#include scripts\chat_commands;
// My logic class.
#include scripts\zm\lattemango\features\chat_commands\logic\record;
// My utility classes.
#include scripts\zm\lattemango\util\error;

record_command(args)
{
    if (args.size > 0) { return; }
    
    // If we are not debugging, then don't display command hints.
    debug = level.pers["chat_command_hints"];
    if (!(isDefined(debug) && debug))
    {
        level record_display_server();
        self record_display_player();
        return;
    }

    // Command error checking.
    error = level record_display_server();
    error_two = self record_display_player();
    if (IsDefined(error)) { return error; }
    if (IsDefined(error_two)) { return error_two; }
}

init()
{
    // Create the chat commands here.
    CreateCommand(level.chat_commands["ports"], "record", "function", ::record_command, 3);
}
