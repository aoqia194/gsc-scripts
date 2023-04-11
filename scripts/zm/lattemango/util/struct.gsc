struct_tostring(struct)
{
    struct_string = "";

    structKeys = getStructKeys(struct);
    for (i = 0; i < structKeys.size; i++)
    {
        key = structKeys[i];
        val = structGet(struct, key);
        if ((key + " : " + val) != "" || typeof(key + " : " + val) != "undefined")
        {
            struct_string += (key + " : " + structGet(struct, key) + " : " + typeof(val) + "\n");
        }
    }

    return struct_string;
}
