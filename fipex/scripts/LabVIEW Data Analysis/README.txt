Data processing for experiments to characterize and de-risk the FIPEX sensor for SWARM-EX. Please read if importing data from FIPEX tests and using scripts for data visualization.

*** If loading data for the first time, follow Steps 1 & 2. Otherwise skip to Step 3 ***
(1) Load data into .mat format and place in the "ExperimentData" directory.

(2) Run "ExperimentDataAnalysis.m" and set 'ComputeFFT=0'. This will enable data visualization as a time series. Take note of important timestamps - primarily start & end timestamps of time segments of interest (e.g., times when hyperthermal beam starts and shuts off). Notate the timestamps in "StartStopIndices.txt" for future reference.

(3) When running analysis code (e.g., fft computation in "ExperimentDataAnalysis.m", epoch analysis in "EpochAnalysis.m"), make sure to set the parameters at the top of the file. This includes start and stop times for time segments to be analyzed, file location, etc. Refer to "StartStopIndices.txt" for previously used timestamps.




** Note: As the code scales, the parameter inputs might be transferred to a config file (e.g., JSON) for ease of access. Stay tuned. Please reach out with any questions.

Grant Kirchhoff, grant.kirchhoff@colorado.edu
University of Colorado Boulder, Department of Aerospace Engineering Sciences
SWARM-EX: https://www.colorado.edu/aerospace/academics/graduates/graduate-projects/2021-2022-projects/space-weather-atmospheric-reconfigurable