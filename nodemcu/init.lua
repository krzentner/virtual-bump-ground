function startup()
    if file.open("init.lua") == nil then
        print("init.lua deleted or renamed")
    else
        print("Running")
        file.close("init.lua")
        dofile("application.lua")
    end
end

print("Starting up! You have 3 seconds to abort.")
tmr.create():alarm(3000, tmr.ALARM_SINGLE, startup)
