// afluffyofox

#include scripts\zm\afluffyofox\features\chat_commands\logic\record;
#include scripts\zm\afluffyofox\util\commands;

record_command(args)
{
    if (args.size > 0)
    {
        return;
    }

    self display_player_record();
}

init()
{
    create_command("record", ::record_command, 1);
}
