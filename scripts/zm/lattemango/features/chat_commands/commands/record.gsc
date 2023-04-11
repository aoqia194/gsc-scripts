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
    if (!isdefined(debug))
    {
        level thread record_server_display();
        self thread record_player_display();
        return;
    }

    // Command error checking.
    error = level thread record_server_display();
    error_two = self thread record_player_display();
    if (IsDefined(error)) { return error; }
    if (IsDefined(error_two)) { return error_two; }
}

init()
{
    // Create the chat commands here.
    CreateCommand(level.chat_commands["ports"], "record", "function", ::record_command, 3);
}
