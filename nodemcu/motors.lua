motor_pins = {
  1,
  2,
  3,
  4,
}

for motor, pin in pairs(motor_pins) do
  pwm.setup(pin, 500, 0)
end

function power_motor(motor, power)
  pin = motor_pins[motor]
  if power > 255 then
    print("Attempt to set motor power too high: " .. power)
    power = 255
  end
  pwm.setduty(pin, 4 * power)
end

function stop_motor(motor)
  pin = motor_pins[motor]
  pwm.setduty(pin, 2)
end
