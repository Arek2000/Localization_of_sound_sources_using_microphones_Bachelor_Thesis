function [azimuth,elevation] = angle_calc(frequency,phase1,phase2,phase3,phase4)
L = 0.015;      %length of the side of the square
x = 10000*L;    %length of the first side of pyramid

%Phase differences of signals with respect to the first signal:
phase_shift2_1 = phase2-phase1;
phase_shift3_1 = phase3-phase1;
phase_shift4_1 = phase4-phase1;

%
delta21 = delta_r(phase_shift2_1,frequency);
delta31 = delta_r(phase_shift3_1,frequency);
delta41 = delta_r(phase_shift4_1,frequency);

%Calculations:
R1 = x;
R2 = x + delta21;
R3 = x + delta31;
R4 = x + delta41;
    
d12 = 0.5*sqrt(2*R1^2+2*R2^2-L^2);
d14 = 0.5*sqrt(2*R1^2+2*R4^2-L^2);
% d23 = 0.5*sqrt(2*R2^2+2*R3^2-L^2);
% d34 = 0.5*sqrt(2*R3^2+2*R4^2-L^2);
R = 0.5*sqrt(2*R2^2+2*R4^2-(L*sqrt(2))^2);
    
cos_alfa = (R^2+0.25*L^2-d12^2)/(2*R*L);
cos_beta = (R^2+0.25*L^2-d14^2)/(2*R*L);
x1 = R*cos_alfa;
x2 = R*cos_beta;
D = sqrt(x1^2+x2^2);
azimuth=rad2deg(atan(x2/x1));
if cos_alfa<=0 && cos_beta<=0
    azimuth = azimuth-180;
end
if cos_alfa<=0 && cos_beta>=0
    azimuth = azimuth+180;
end
elevation = abs(acosd(D/R));
ph_32 = deg2rad(phase3-phase2);
ph_31 = deg2rad(phase3-phase1);
angle2 = rad2deg(atan(ph_32/(2*ph_31-ph_32)));
end

function delta = delta_r(phase,frequency)
wave_length = 1500/frequency;
delta = wave_length*phase/360;
end

