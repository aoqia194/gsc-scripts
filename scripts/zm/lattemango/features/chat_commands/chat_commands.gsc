init()
{
    // Bank
    scripts\zm\lattemango\features\chat_commands\commands\bank::init();
    // Other
    scripts\zm\lattemango\features\chat_commands\commands\developer::init();
    // Rankup
    scripts\zm\lattemango\features\chat_commands\commands\rankup::init();
    scripts\zm\lattemango\features\chat_commands\logic\rankup::init();
    // Record
    scripts\zm\lattemango\features\chat_commands\commands\record::init();
    scripts\zm\lattemango\features\chat_commands\logic\record::init();
}
