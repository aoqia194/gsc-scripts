// function: Creates a new field for use in embeds (see the fields array)
// name: string
// value: string
// inline?: bool
field_new(name, value, inline)
{
    field = [];

    if (isdefined(name))
    {
        field["name"] = name;
    }

    if (isdefined(value))
    {
        field["value"] = value;
    }

    if (isdefined(inline))
    {
        field["inline"] = inline;
    }

    return field;
}
