init()
{
    scripts\zm\lattemango\util\database::init();
    scripts\zm\lattemango\util\playername::init();
    
    scripts\zm\lattemango\features\chat_commands\chat_commands::init();
    scripts\zm\lattemango\features\discord_webhook\discord_webhook::init();
}
