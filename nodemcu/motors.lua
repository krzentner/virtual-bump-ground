motor_pins = {
  1,
  2,
  3,
  4,
}

pin_hz = 500
pin_idle = 2
for motor, pin in pairs(motor_pins) do
  print(string.format("pwm.setup(%d, %d, %d)", motor, pin_hz, pin_idle))
  pwm.setup(pin, pin_hz, pin_idle)
  pwm.stop(pin)
end

function power_motor(motor, power)
  print(string.format("power_motor(%d, %d)", motor, power))
  pin = motor_pins[motor]
  if power < 1 then
    power = 1
  end
  if power > 255 then
    print("Attempt to set motor power too high: " .. power)
    power = 255
  end
  pwm.stop(pin)
  pwm.setduty(pin, 4 * power)
  pwm.start(pin)
end

function stop_motor(motor)
  print(string.format("stop_motor(%d)", motor))
  pin = motor_pins[motor]
  pwm.stop(pin)
  pwm.setduty(pin, 2)
end
