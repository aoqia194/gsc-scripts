// function: Creates a new thread if the webhook channel is a forum channel.
// name: string
thread_new(data, name)
{
    if (isdefined(name))
    {
        data["thread_name"] = name;
    }

    return data;
}
