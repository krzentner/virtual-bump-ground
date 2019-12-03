import socket
import time

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
addr = ("192.168.1.1", 18000)

def pulse(motor, duration, power=0x2f):
    data = 8 * [0]
    m = motor - 1
    data[2 * m] = power
    data[2 * m + 1] = 0xff
    data = bytes(data)
    while duration > 0:
        sock.sendto(data, addr)
        time.sleep(0.2)
        duration -= 0.2

for motor in range(1, 5):
    print("pulsing motor #{}".format(motor))
    for pulses in range(motor):
        print("pulse!")
        pulse(motor, 1)
        time.sleep(1)
