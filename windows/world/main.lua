print("Starting...")
local socket = require("socket")
local inPort = 8000
local localIP = assert(socket.dns.toip("localhost"))
local inSocket = assert(socket.udp());
inSocket:setsockname('*', inPort)
inSocket:settimeout(0.001)

local models = {}

local x_offset = 0
local y_offset = 0
local z_offset = 0

function lovr.load()
  print("Loading...")
  models['mountains'] = lovr.graphics.newModel('mountains.glb')
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
  lovr.graphics.translate(x_offset, y_offset, z_offset)

  if models['mountains'] ~= nil then
    models['mountains']:draw(0, 0, 0, 10.0)
  end
  if models['minecraft'] ~= nil then
    models['minecraft']:draw(0, -55, 0, 1.0)
  end
end

local MOVE_COEF = 20

function move(frame_q, dt, dx, dz)
  dx = MOVE_COEF * dt * dx
  dz = -MOVE_COEF * dt * dz

  local hdx, hdy, hdz = frame_q:mul(lovr.math.vec3(dx, 0, dz)):unpack()
  x_offset = x_offset - MOVE_COEF * dt * hdx
  z_offset = z_offset - MOVE_COEF * dt * hdz
  y_offset = y_offset - MOVE_COEF * dt * hdy
end

function lovr.update(dt)
  -- Large dt values cause problems.
  if dt > 0.1 then
    dt = 0.1
  end
  local head_x, head_y, head_z, head_angle, head_ax, head_ay, head_az = lovr.headset.getPose('head')
  local head_q = lovr.math.quat(head_angle, head_ax, head_ay, head_az)
  local dx, dz = lovr.headset.getAxis('hand/left', 'touchpad')

  move(head_q, dt, dx, dz)

  local boardData = inSocket:receive()
  print('boardData:')
  print(boardData)
  while boardData ~= nil do
    dx = -(string.byte(boardData, 1) - 127) / 127
    dz = (string.byte(boardData, 2) - 127) / 127
    print("boardData.dx: " .. dx)
    print("boardData.dz: " .. dz)
    move(head_q, dt, dx, dz)
    boardData = inSocket:receive()
  end
end
