// afluffyofox

to_string(value)
{
    type = typeof(value);

    if (type == "struct")
    {
        temp = "";
        keys = getstructkeys(value);

        for (i = 0; i < keys.size; i++)
        {
            key = keys[i];
            val = structget(value, key);

            pair = (key + ":" + val);
            if (isdefined(pair) && pair != "")
            {
                temp += pair;
                temp += "\n";
            }
        }

        return temp;
    }
    else if (type == "array")
    {
        temp = "(";
        for (i = 0; i < value.size; i++)
        {
            temp += value[i];

            if (i != (value.size - 1))
            {
                temp += value[i] + ", ";
            }
        }
        temp += ")";

        return temp;
    }
    else
    {
        return value + "";
    }

    return;
}

// Converts a type to a boolean based on it's value.
to_bool(value)
{
    type = typeof(value);

    if (type == "string")
    {
        return (tolower(type) == "true");
    }
    else if (type == "int")
    {
        return (type == 1);
    }
    else if (type == "float")
    {
        return (type == 1.0);
    }
}

// Checks a string for common "bad" stuff.
bad_string(string)
{
    return (string == "" || string == " " || string == "null");
}
