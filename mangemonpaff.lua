local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("LE KZ", "DarkTheme")
local Tab = Window:NewTab("LE PAFF A NEYZ")
local Section = Tab:NewSection("LE ZIZOU ESP")
Section:NewToggle("TU T'ENVOLES DANS LE CIEL ", "DEBUG BY INTERPOL 👹", function(state)
    if state then
        print("Toggle On")
    else
        print("Toggle Off")
    end
end)
