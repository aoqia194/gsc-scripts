// afluffyofox

// function: Creates a new provider for use in embeds.
// name?: string
// url?: string
create_provider(name, url)
{
    provider = [];

    if (isdefined(name))
    {
        provider["name"] = name;
    }

    if (isdefined(url))
    {
        provider["url"] = url;
    }

    return provider;
}
