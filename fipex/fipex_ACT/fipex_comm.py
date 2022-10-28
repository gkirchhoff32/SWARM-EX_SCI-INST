#
# FIPEX Command Dictionary
# fipex_comm.py
#
# Grant Kirchhoff
# Last updated: 10.28.2022
# SWARM-EX SCI/INST
# University of Colorado Boulder
#
"""

Command dictionary that functionalizes commands/responses for the FIPEX sensor.

"""

import serial
import time


class FIPEXSensor:
    def __init__(self):
        # Initialize serial comm parameters
        self.baudrate = 115200
        self.timeout = None
        self.xonxoff = False
        self.parity = serial.PARITY_NONE
        self.bytesize = serial.EIGHTBITS
        self.port = 'COM3'

        self.ser = serial.Serial(port=self.port, baudrate=self.baudrate, timeout=self.timeout, xonxoff=self.xonxoff,
                                 parity=self.parity, bytesize=self.bytesize)

        if self.ser.is_open:
            print('Serial port open from previous session. Closing...')
            self.close()

    def open(self):
        self.ser.open()
        print('Opened serial port.')

    def close(self):
        self.ser.close()
        print('Closed serial port.')

    def heatup(self, sensor=1, encoding='utf-8'):
        response_num_byte = self.ser.write(bytearray('F{}0001'.format(sensor), encoding=encoding))
        response = self.ser.read(response_num_byte)
        return response.decode()

    def cooldown(self, sensor=1, encoding='utf-8'):
        response_num_byte = self.ser.write(bytearray('F{}0000'.format(sensor), encoding=encoding))
        response = self.ser.read(response_num_byte)
        return response.decode()

    def heater_resistance(self, sensor=1, resistance='150.0', encoding='utf-8'):
        """
        Define heater resistance.
        :param sensor: (int) Sensor number (1 or 2)
        :param resistance: (str) Ensure that the resistance value (in Ohms) follows the format 'iii.i', as a string. For
        example, 150 Ohms --> '150.0' ; 25.2 Ohms --> '025.2' ; 2 Ohms --> '002.0'
        :param encoding: (str) standard utf-8 (unless specified)
        :return: (str) response from sensor. Should ECHO if the command execution was successful.
        """
        if type(resistance) != str:
            try:
                str(resistance)
            except:
                print('make sure resistance value is inputted as a string')
                self.ser.close()
                quit()
        response_num_byte = self.ser.write(bytearray('H{}{}'.format(sensor, resistance), encoding=encoding))
        response = self.ser.read(response_num_byte)
        return response.decode()

    def heater_resistance_FRAM(self, sensor=1, resistance='1500', encoding='utf-8'):
        """
        Define heater resistance and store the value in FRAM for next heatup.
        :param sensor: (int) Sensor number (1 or 2)
        :param resistance: (str) Ensure that the resistance value (in Ohms) follows the format 'iii.i', as a string. For
        example, 150 Ohms --> '1500' ; 25.2 Ohms --> '0252' ; 2 Ohms --> '0020'
        :param encoding: (str) standard utf-8 (unless specified)
        :return: (str) response from sensor. Should ECHO if the command execution was successful.
        """
        if type(resistance) != str:
            try:
                str(resistance)
            except:
                print('make sure resistance value is inputted as a string')
                self.ser.close()
                quit()
        response_num_byte = self.ser.write(bytearray('H{}{}'.format(sensor, resistance), encoding=encoding))
        response = self.ser.read(response_num_byte)
        return response.decode()

    def reference_voltage(self, sensor=1, voltage='300', encoding='utf-8'):
        """
        Define reference voltage value. Reference voltage regulated by anode voltage.
        :param sensor: (int) Sensor number (1 or 2)
        :param voltage: (str or int) Reference voltage value (mV) as a whole number. Max is 750mV. For example, 302mV
        --> '302' ; 45mV --> '045'
        :param encoding: (str) standard utf-8 (unless specified)
        :return: (str) response from sensor. Should ECHO if the command execution was successful.
        """
        if type(voltage) != str:
            try:
                str(voltage)
            except:
                print('make sure resistance value is inputted as a string')
                self.ser.close()
                quit()

        if len(voltage) != 3:
            print('make sure voltage inputted as a string with 3 digits')
            self.ser.close()
            quit()

        response_num_byte = self.ser.write(bytearray('U{}0{}'.format(sensor, voltage), encoding=encoding))
        response = self.ser.read(response_num_byte)
        return response.decode()


if __name__ == '__main__':
    fipex = FIPEXSensor()
    fipex.open()

    time.sleep(0.5)
    response = fipex.heatup(sensor=1)
    print('Heatup response: {}'.format(response))
    print('Sleeping for 3 sec...')
    time.sleep(3)
    response = fipex.heater_resistance(sensor=4, resistance='0311')
    print('Set heater resistance response: {}'.format(response))
    print('Sleeping for 3 sec...')
    time.sleep(3)
    response = fipex.cooldown(sensor=1)
    print('Cooldown response: {}'.format(response))
    print('Sleeping for 1 sec...')
    time.sleep(1)

    fipex.close()
