#include scripts\zm\lattemango\features\discord_webhook\webhook_data;

chat_listener()
{
    for (;;)
    {
        level waittill("say", message, player);

        // If the message is a command
        if (message[0] == GetDvar("cc_prefix"))
        {
            player thread webhook_command_send(message);
        }
        else
        {
            player thread webhook_message_send(message);
        }
    }
}

init()
{
    level thread chat_listener();
}
