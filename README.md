# Localization of sound sources using microphones
The purpose of this work is to build a device capable of detecting the direction of the highest amplitude sound. As part of the project, I will design a measurement system that will continuously monitor audio signals from the environment. This system will be able to transmit measurement data to a computer in real time.

On the PC side, an algorithm will be implemented that will calculate the direction of the sound based on audio signals from microphones. The system will be capable of displaying the results of calculations in real time in a graphical form.

This device has potential applications in numerous fields, such as recording studios, surveillance, wildlife studies, and any other area where identifying the direction of a sound source could be beneficial.

Detecting the source of a sound involves using an array of sensors tuned to receive a specific signal. Then, by analyzing the data from each sensor, the time delay between the arrival of a wave to each sensor in the array must be determined. With access to all the time delays and the exact positions of the sensors relative to each other, it is possible to geometrically calculate the angle of incidence of the signal. 

d - Distance between the microphones
Δs - The difference in the distance traveled by the sound between the two microphones
x - A random value greater than 2d. This does not affect the calculation results
vs - Speed of sound in air, which equals 343 m/s
These variables will be used in the algorithm for calculating the direction of the sound based on audio signals from the microphones.

$$ x^2 = {(2d)^2 + (x+Δs)^2 - 2d(x+Δs)cosa} $$
Δs = vs / f * Δphase_difference / 360
x^2 = (2d)^2 + (x+Δs)^2 - 2d(x+Δs)cosa
a = cos(cosa)^-1
