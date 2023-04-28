// afluffyofox

#include scripts\zm\afluffyofox\features\chat_commands\logic\rankup;
#include scripts\zm\afluffyofox\util\commands;

rankup_command(args)
{
    if (args.size > 1)
    {
        return;
    }

    if (!isdefined(args[0]))
    {
        player_rankup(1);
    }
    else
    {
        player_rankup(args[0]);
    }
}

rank_command(args)
{
    if (args.size > 0)
    {
        return;
    }

    display_rank();
}

init()
{
    create_command(array("rank", "r"), ::rank_command, 1);
    create_command("rankup", ::rankup_command, 1);
}
