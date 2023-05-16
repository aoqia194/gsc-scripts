// afluffyofox

#include scripts\zm\afluffyofox\features\chat_commands\logic\bank;
#include scripts\zm\afluffyofox\util\commands;
#include scripts\zm\afluffyofox\util\debugprintf;

deposit_command(args)
{
    if (args.size > 1)
    {
        return;
    }

    points = "all";
    if (isdefined(args[0]))
    {
        points = int(args[0]);
    }

    bank_deposit(points);
}

withdraw_command(args)
{
    if (args.size > 1)
    {
        return;
    }

    points = "all";
    if (isdefined(args[0]))
    {
        points = int(args[0]);
    }

    bank_withdraw(points);
}

balance_command(args)
{
    debugprintf("balance called with args " + args);

    if (args.size > 0)
    {
        return;
    }

    bank_balance();
}

init()
{
    // Create the chat commands here.
    create_command(array("deposit", "d"), ::deposit_command, 1);
    create_command(array("withdraw", "w"), ::withdraw_command, 1);
    create_command(array("balance", "b"), ::balance_command, 1);
}
