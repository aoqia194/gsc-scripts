// afluffyofox

#include scripts\zm\afluffyofox\util\type;

// Use this as a reference if you're confused! https://birdie0.github.io/discord-webhooks-guide/structure/allowed_mentions.html

// function: This function allows the ability to suppress pings by certain users/roles.
// data: array (HTTP)
// parse: array (string)
// users: array (string)
// roles: array (string)
set_allowed_mentions(data, parse, users, roles)
{
    allowed_mentions = [];

    if (isdefined(parse))
    {
        allowed_mentions += parse;
    }

    if (isdefined(users))
    {
        allowed_mentions += users;
    }

    if (isdefined(roles))
    {
        allowed_mentions += roles;
    }

    data["allowed_mentions"] = allowed_mentions;
}
