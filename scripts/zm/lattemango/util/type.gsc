type_tostring(value)
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

            if ((key + ":" + val) != "" || typeof(key + ":" + val) != "undefined")
            {
                temp += (key + ":" + val + "\n");
            }
        }

        ret = temp;
    }
    else if (type == "array")
    {
        temp = "(";
        for (i = 0; i < value.size; i++)
        {
            if ((i + 1) > value.size)
            {
                temp += value[i];
            }
            else
            {
                temp += value[i] + ", ";
            }
        }
        temp += ")";

        ret = temp;
    }
    else
    {
        ret = (value + "");
    }

    return ret;
}
