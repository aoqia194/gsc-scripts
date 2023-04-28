#include scripts\zm\afluffyofox\features\chat_commands\logic\settings;
#include scripts\zm\afluffyofox\util\commands;

set_prefix_command(args)
{
    if (args.size != 1)
    {
        return;
    }

    set_prefix(args[0]);
}

init()
{
    create_command("setprefix", ::set_prefix_command, 1);
}
