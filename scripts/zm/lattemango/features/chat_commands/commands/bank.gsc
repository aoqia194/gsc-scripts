// Developed by lattemango

// Resxt's base chat commands script.
#include scripts\chat_commands;
// My logic class.
#include scripts\zm\lattemango\features\chat_commands\logic\bank;
// My utility classes.
#include scripts\zm\lattemango\util\error;

deposit_command(args)
{
    // If we are not debugging, then don't display command hints.
    debug = level.pers["chat_command_hints"];
    if (!isdefined(debug))
    {
        bank_deposit(args[0]);
        return;
    }

    // Command error checking.
    if (args.size < 1) { return NotEnoughArgsError(1); }
    if (args.size > 1) { return TooManyArgsError(1); }
    error = bank_deposit(args[0]);
    if (isdefined(error)) { return error; }
}

withdraw_command(args)
{
    // If we are not debugging, then don't display command hints.
    debug = level.pers["chat_command_hints"];
    if (!isdefined(debug))
    {
        bank_withdraw(args[0]);
        return;
    }

    // Command error checking.
    if (args.size < 1) { return NotEnoughArgsError(1); }
    if (args.size > 1) { return TooManyArgsError(1); }
    error = bank_withdraw(args[0]);
    if (isdefined(error)) { return error; }
}

balance_command(args)
{
    // If we are not debugging, then don't display command hints.
    debug = level.pers["chat_command_hints"];
    if (!isdefined(debug))
    {
        bank_balance();
        return;
    }

    // Command error checking.
    if (args.size > 0) { return TooManyArgsError(0); }
    error = bank_balance();
    if (isdefined(error)) { return error; }
}

init()
{
    // Create the chat commands here.
    CreateCommand(level.chat_commands["ports"], "deposit", "function", ::deposit_command, 3);
    CreateCommand(level.chat_commands["ports"], "d", "function", ::deposit_command, 3);
    CreateCommand(level.chat_commands["ports"], "withdraw", "function", ::withdraw_command, 3);
    CreateCommand(level.chat_commands["ports"], "w", "function", ::withdraw_command, 3);
    CreateCommand(level.chat_commands["ports"], "balance", "function", ::balance_command, 3);
    CreateCommand(level.chat_commands["ports"], "b", "function", ::balance_command, 3);
}
