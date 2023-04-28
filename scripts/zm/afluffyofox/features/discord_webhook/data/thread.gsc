// afluffyofox

#include scripts\zm\afluffyofox\util\type;

// function: Creates a new thread if the webhook channel is a forum channel.
// name: string
create_thread(data, name)
{
    if (isdefined(name))
    {
        data["thread_name"] = name;
    }

    return data;
}
