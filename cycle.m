function [w_net, cycle_efficiency] = cycle( r_p, t4, regen, regen_efficiency )
%Constants
COMP_EFFICIENCY = .81;
TURB_EFFICIENCY = .86;
Cp = .24;
Cpw = 1;
K = 1.4;

%Known Values
t1 = 540;
tl1 = 500;
tl2 = 620;
th1 = 3060;
p1 = 14.7;
p5 = 14.7;

%Set Delta P through the regenerator
if(regen)
    delta_p = findDeltaP(regen_efficiency);
else
    delta_p = 0;
end

%Calculations through the compressor
p2 = p1*r_p;
t2s = (r_p^((K-1)/K))*t1;
w_comp = (Cp*(t2s-t1))/ COMP_EFFICIENCY;
t2 = ((t2s-t1)/COMP_EFFICIENCY) + t1;

%Pressure after regen
p3 = p2 - delta_p;
p4 = p3;

%Calculations through the turbine
t5s = t4/((p4/p5)^((K-1)/K));
w_turb = TURB_EFFICIENCY*Cp*(t4 - t5s);
t5 = t4 - TURB_EFFICIENCY*(t4 - t5s);

%Net work output of turbine
w_net = w_turb - w_comp;

%Finding temp after regenerator 
t3 = regen_efficiency*(t5 - t2)+t2;

%Calculating thermal efficiency of cycle
cycle_efficiency = w_net/(Cp*(t4-t3));
end

function [delta_p] = findDeltaP(regen_efficiency)
    delta_p = (.5*regen_efficiency)/(1-regen_efficiency);
end