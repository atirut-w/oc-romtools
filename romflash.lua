local args = {}
do
    local parser = require("argparse")()
    parser:description("ROM flash utility for OpenComputers")

    -- ROM file to flash
    parser:argument("rom", "ROM file to flash")

    -- Set label
    parser:option("-l --label", "Set label for ROM")

    args = parser:parse({...})
end

local component = require("component")

local function flash(data)
    local s, proxy = pcall(function() return component.proxy(component.list("eeprom")()) end)
    if not s then return nil, "No EEPROM found", true end
    if #data > proxy.getSize() then return nil, "ROM too large", false end

    io.write("Flashing ROM... ")
    proxy.set(data)
    print("done")

    if args.label then
        proxy.setLabel(args.label)
    end

    return true
end

local file = io.open(args.rom, "rb")
if not file then
    print("Could not open ROM file")
    return
end

io.write("Put in the EEPROM and press enter to flash it...")
io.read()

local s, e, r
while not s do
    s, e, r = flash(file:read("a"))
    if not s then
        print(e)
        if r then
            print("Press enter to try again...")
            io.read()
        end
    end
end
print("ROM flashed successfully")
