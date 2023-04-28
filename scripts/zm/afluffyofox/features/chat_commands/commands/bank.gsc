// afluffyofox

#include scripts\zm\afluffyofox\features\chat_commands\logic\bank;
#include scripts\zm\afluffyofox\util\commands;

deposit_command(args)
{
    if (args.size < 1 || args.size > 1)
    {
        return;
    }

    bank_deposit(args[0]);
}

withdraw_command(args)
{
    if (args.size < 1 || args.size > 1)
    {
        return;
    }

    bank_withdraw(args[0]);
}

balance_command(args)
{
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
