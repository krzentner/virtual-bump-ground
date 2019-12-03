print("Starting...")
local socket = require("socket")
local s1 = socket.udp()
local inPort = 8000
local localIP = assert(socket.dns.toip("localhost"))
local inSocket = assert(socket.udp());
inSocket:setsockname('*', inPort)
inSocket:settimeout(0.001)
s1:setpeername( "192.168.1.1", 18000)
local models = {}

local x_offset = 0
local y_offset = 0
local z_offset = 0
local angle_offset = 3.14

function lovr.load()
  print("Loading...")
  --models['mountains'] = lovr.graphics.newModel('mountains.glb')
  --models['mountains'] = lovr.graphics.newModel('mountains3.glb')
  models['maze'] = lovr.graphics.newModel('maze.glb')
  -- models['minecraft'] = lovr.graphics.newModel('minecraft.glb')
  lovr.headset.setClipDistance(0.1, 1000)
  print("Done loading.")
end

function draw_controllers()
  for hand in ipairs(lovr.headset.getHands()) do
    if hand == 1 then
      hand = 'hand/left'
    elseif hand == 2 then
      hand = 'hand/right'
    end
    models[hand] = models[hand] or lovr.headset.newModel(hand)

    if models[hand] then
      local x, y, z, angle, ax, ay, az = lovr.headset.getPose(hand)
      models[hand]:draw(x, y, z, 1, angle, ax, ay, az)
    end
  end
end

function draw_sky()
  lovr.graphics.setBackgroundColor(.7, .8, 1)
  lovr.graphics.setColor(1.0, 1.0, 1.0)
  lovr.graphics.sphere(0, 700, 0, 20.)
end

function lovr.draw()
  draw_sky()
  draw_controllers()

  -- Must draw "environment" objects after this.
  lovr.graphics.rotate(angle_offset, 0, 1, 0)
  lovr.graphics.translate(x_offset, y_offset, z_offset)
  if models['mountains'] ~= nil then
    models['mountains']:draw(0, 0, 0, 10.0)
  end
  if models['maze'] ~= nil then
    models['maze']:draw(0, 0, 0, 1.0)
  end
  if models['minecraft'] ~= nil then
    models['minecraft']:draw(0, -55, 0, 1.0)
  end
end

local MOVE_COEF = 20
local TURN_COEF = 2000.0
local DX_BOARD_COEFF = 0.5
local DX_COEF = 0.005
local DY_COEF = 0.001
local DEAD_ZONE = 0.05
local MAX_ZONE = 0.6
--local VIBRATION_COEF = 0.05
local VIBRATION_COEF = 50.0

local VIBRATION_PACKET_RATE = 0.1
local time_to_next_vibration = VIBRATION_PACKET_RATE

function move(frame_q, dt, dx, dz)
  local vl = math.floor(VIBRATION_COEF * dt * math.abs(dz) * 255)
  dx = MOVE_COEF * dt * dx * DX_COEF
  dz = -MOVE_COEF * dt * dz
  da = TURN_COEF * dt * dx
    
  if time_to_next_vibration < 0 then
	  local vibration = string.char(vl, 0xff, vl, 0xff,0,0,0,0)
	  s1:send(vibration) -- start session
  	  print("sent:", vibration)
	time_to_next_vibration = VIBRATION_PACKET_RATE
  else
	time_to_next_vibration = time_to_next_vibration - dt
  end
  local rotate_q = lovr.math.quat(-angle_offset, 0, 1, 0)
  local head_v = lovr.math.vec3(dx, 0, dz)
  --head_v = frame_q:mul(head_v)
  head_v = rotate_q:mul(head_v)
  --head_v = rotate_q:mul(head_v)
  local hdx, hdy, hdz = head_v:unpack()
  x_offset = x_offset - MOVE_COEF * dt * hdx
  z_offset = z_offset - MOVE_COEF * dt * hdz
  y_offset = y_offset - MOVE_COEF * dt * hdy * DY_COEF
  angle_offset = angle_offset + da
end

function dead_clip(v)
  if math.abs(v) < DEAD_ZONE then
    return 0
  elseif math.abs(v) > MAX_ZONE then
    if v > 0 then
      return MAX_ZONE
    else
      return -MAX_ZONE
    end
  else
    return v
  end
end

function lovr.update(dt)
  -- Large dt values cause problems.
  if dt > 0.1 then
    dt = 0.1
  end
  local head_x, head_y, head_z, head_angle, head_ax, head_ay, head_az = lovr.headset.getPose('head')
  local head_q = lovr.math.quat(head_angle, head_ax, head_ay, head_az)
  --local dx, dz = lovr.headset.getAxis('hand/left', 'touchpad')
  --print("got controller")

  --move(head_q, dt, dx, dz)

  local boardData = inSocket:receive()
  while boardData ~= nil do
    dx = -(string.byte(boardData, 1) - 127) / 127
    dz = (string.byte(boardData, 2) - 127) / 127
    dz = dead_clip(dz)
    dz = dz + 0.2
    if dz < 0 then
      dz = 0
    end

    move(head_q, dt, DX_BOARD_COEFF * dx, dz * dz)
    boardData = inSocket:receive()
  end
end
