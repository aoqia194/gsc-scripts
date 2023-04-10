#include scripts\zm\lattemango\features\discord_webhook\webhook_data;

chat_listener()
{
    for (;;)
    {
        level waittill("say", message, player);

        // If the message is a command
        if (message[0] == GetDvar("cc_prefix"))
        {
            player thread webhook_send_command(message);
        }
        else
        {
            player thread webhook_send_chat(message);
        }
    }
}

init()
{
    level thread chat_listener();
}
