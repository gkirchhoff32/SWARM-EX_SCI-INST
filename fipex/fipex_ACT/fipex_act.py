#
# FIPEX Advanced Communications Test (ACT)
# fipex_act.py
#
# Grant Kirchhoff
# Last updated: 10.28.2022
# SWARM-EX SCI/INST
# University of Colorado Boulder
#
"""

Main script for interfacing with the FIPEX instrument for the SWARM-EX Mission. Purpose of the Advanced Communications
Test (ACT) is to serve as the interface between the flight software team (CD&H) and the instruments team (INST). The
functions adhere to INST guidelines for flight operations and are adaptable in CD&H's flight software.

"""

import numpy as np
# import pyvisa as visa
import serial
import time
import serial.tools.list_ports
from fipex_comm import FIPEXSensor

class FIPEXRoutines(FIPEXSensor):
    def __init__(self):
        self.fipex = FIPEXSensor

    def test_heatup_cooldown(self, sensor=1):
        """
        Example routine where the sensor of choice is heated, data is read, and then cooled.
        :param sensor:
        :return:
        """
        self.fipex.open()
        time.sleep(0.5)
        response = self.fipex.heatup(sensor=1)
        print('Heatup response: {}'.format(response))
        print('Sleeping for 3 sec...\n')
        time.sleep(3)
        response = self.fipex.read()
        print('Response: {}'.format(response))
        print('Sleeping for 3 sec...\n')
        time.sleep(3)
        response = self.fipex.cooldown(sensor=1)
        print('Cooldown response: {}'.format(response))
        print('Sleeping for 1 sec...\n')
        time.sleep(1)

        self.fipex.close()








# Graveyard

# ##### PARAMETERS #####
# show_ports = False
# if show_ports:
#     ports = serial.tools.list_ports.comports()
#     for port, desc, hwid in sorted(ports):
#         print("{}: {} [{}]".format(port, desc, hwid))
# else:
#     port = 'COM3'
# baudrate = 115200
# timeout = None
# xonxoff = False
# parity = serial.PARITY_NONE
# bytesize = serial.EIGHTBITS
#
# ser = serial.Serial(port=port, baudrate = baudrate, timeout = timeout, xonxoff = xonxoff, parity = parity,
#                     bytesize = bytesize)
# if ser.is_open:
#     print('okay')
#     ser.close()
#
# ser.open()
#
# response_num_byte = ser.write(bytearray('F10000', encoding='utf-8'))
# print(ser.read(response_num_byte))
#
# time.sleep(1e-3)
# ser.close()

