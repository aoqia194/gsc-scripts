#include scripts\zm\afluffyofox\features\chat_commands\logic\settings;
#include scripts\zm\afluffyofox\util\commands;

set_prefix_command(args)
{
    if (args.size != 1)
    {
        return;
    }

    prefix = (args[0] + "");
    set_prefix(prefix);
}

init()
{
    create_command(array("setprefix"), ::set_prefix_command, 1);
}
