function [w_net, cycle_efficiency, irrev] = cycle( r_p, t4, regen, regen_efficiency )
%Constants
COMP_EFFICIENCY = .81;
TURB_EFFICIENCY = .87;
Cp = .24;
Cpw = 1;
K = 1.4;
R = 53.34;
T0 = 540;

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

th2 = th1 + 180;

%Calculating regen exit temp
if(regen)
    t6 = -((t3-t2)/regen_efficiency)+t5;
else
    t6 = t5;
end
p6 = p5;

%Calculating irreversibility
m_h = (t4-t3)/(th1-th2); %relates mass flow rate through hex to mass flow rate of cycle air
m_l = (Cp*(t6-t1))/(Cpw*(tl2-tl1)); %relates mass flow rate through  low hex to mass flow rate of cycle air

compressor_i = T0*(Cp*(log(t2/t1))-((R/778)*(log(p2/p1)))); 
turbine_i = T0*(Cp*(log(t5/t4))-((R/778)*(log(p5/p4))));
regen_i = T0*(Cp*(log(t3/t2)+log(t5/t6))-((R/788)*(log(p3/p2)+log(p5/p6))));
hhex_i = T0*((Cp*log(t4/t3))+m_h*(Cp*log(th2/th1))+(m_h*(Cp*(th1-th2)))/t4);
lhex_i = T0*((Cp*log(t1/t6))+m_l*(Cpw*log(tl2/tl1))+(m_l*(Cpw*(tl1-tl2)))/t1);



irrev = (compressor_i + turbine_i + regen_i + hhex_i + lhex_i)/w_net;
end

function [delta_p] = findDeltaP(regen_efficiency)
    delta_p = (.5*regen_efficiency)/(1-regen_efficiency);
end