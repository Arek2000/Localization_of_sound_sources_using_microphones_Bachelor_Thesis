function azimuth = angle_calc2(frequency,phase1,phase2,phase3,phase4)
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
R = 0.5*sqrt(2*R2^2+2*R4^2-(sqrt(2)*L)^2);

cos_alfa = (R^2+0.5*L^2-R2^2)/(0.5*sqrt(2)*R2*L);
azimuth = abs(acosd(cos_alfa))-45;
end

function delta = delta_r(phase,frequency)
wave_length = 1500/frequency;
delta = wave_length*phase/360;
end