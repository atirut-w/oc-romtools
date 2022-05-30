local args = {}
do
    local parser = require("argparse")()
    parser:description("ROM dumping utility for OpenComputers")

    parser:argument("output", "Output file")

    args = parser:parse({...})
end

local component = require("component")

local success, proxy = pcall(function() return component.proxy(component.list("eeprom")()) end)
if not success then
    print("No EEPROM found")
    return
end

local file = io.open(args.output, "wb")
if not file then
    print("Could not open output file")
    return
end
file:write(proxy.get())
file:close()
