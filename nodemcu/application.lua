dofile("start_wifi_ap.lua")
dofile("motors.lua")

sock = net.createUDPSocket()

sock:listen(18000)
sock:on("receive", function(s, data, port, ip)
  print(string.format("received '%s' from %s:%d", data, ip, port))
  handle_data(data)
  s:send(port, ip, "echo: " .. data)
end)

port, ip = sock:getaddr()
print(string.format("local UDP socket address / port: %s:%d", ip, port))

motor_timers = {
  tmr.create(255, tmr.ALARM_SEMI, function() stop_motor(1) end),
  tmr.create(255, tmr.ALARM_SEMI, function() stop_motor(2) end),
  tmr.create(255, tmr.ALARM_SEMI, function() stop_motor(3) end),
  tmr.create(255, tmr.ALARM_SEMI, function() stop_motor(4) end),
}

function handle_data(data)
  for motor=1,4 do
    power = string.byte(data, 2 * motor)
    time = string.byte(data, 2 * motor + 1)
    print(string.format("motor: %d power: %d timeout: %d", motor, power, time))
    power_motor(motor, power)
    motor_timers[motor]:interval(time)
    motor_timers[motor]:start()
  end
end
