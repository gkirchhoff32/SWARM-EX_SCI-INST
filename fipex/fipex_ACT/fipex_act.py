#
# FIPEX Advanced Communications Test (ACT)
# fipex_act.py
#
# Grant Kirchhoff
# Last updated: 10.27.2022
# SWARM-EX SCI/INST
# University of Colorado Boulder
#
"""

Main script for interfacing with the FIPEX instrument for the SWARM-EX Mission. Purpose of the Advanced Communications
Test (ACT) is to serve as the interface between the flight software team (CD&H) and the instruments team (INST). The
functions adhere to INST guidelines for flight operations and are adaptable in CD&H's flight software.

"""

import numpy as np
import pyvisa as visa

rm = visa.ResourceManager()
rm.list_resources()


