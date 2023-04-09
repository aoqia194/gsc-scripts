// Developed by lattemango

// Resxt's base chat commands script.
#include scripts\chat_commands;
// My logic class.
#include scripts\zm\lattemango\features\chat_commands\logic\rankup;
// My utility classes.
#include scripts\zm\lattemango\util\debugprintf;
#include scripts\zm\lattemango\util\error;

rankup_command(args)
{
    debug_printf("rankup args = " + args[0]);

    // If we are not debugging, then don't display command hints.
    debug = level.pers["chat_command_hints"];
    if (!(isDefined(debug) && debug))
    {
        if (!isDefined(args[0]))
        {
            rank_rankup(1);
        }
        else
        {
            rank_rankup(args[0]);
        }
        return;
    }
    else
    {
        debug_printf("^5How did we get here?");
    }

    // Command error checking.
    if (args.size > 1) { return TooManyArgsError(1); }
    if (args.size == 0) { error = rank_rankup(1); }
    else { error = rank_rankup(args[0]); }
    if (IsDefined(error)) { return error; }
}

rank_command(args)
{
    // If we are not debugging, then don't display command hints.
    debug = level.pers["chat_command_hints"];
    if (!(isDefined(debug) && debug))
    {
        rank_display();
        return;
    }

    // Command error checking.
    if (args.size > 0) { return; }
    error = rank_display();
    if (IsDefined(error)) { return error; }
}

init()
{
    // Create the chat commands here.
    CreateCommand(level.chat_commands["ports"], "rank", "function", ::rank_command, 3);
    CreateCommand(level.chat_commands["ports"], "r", "function", ::rank_command, 3);
    CreateCommand(level.chat_commands["ports"], "rankup", "function", ::rankup_command, 3);
    CreateCommand(level.chat_commands["ports"], "rup", "function", ::rankup_command, 3);
}
