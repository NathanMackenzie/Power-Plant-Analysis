
%User Input
% Dialog box for regen in use
choice = questdlg('Is a regenerator being used?', 'No','Yes');
% Handle response
switch choice
    case 'Yes'
        regen = true;
        regen_efficiency = input('Enter regen efficiency as a decimal: ');
    case 'No'
        regen = false;
        regen_efficiency = 0;
end
r_p = input('Enter compressor pressure ratio: ');
t4 = input('Enter turbin inlet temp in rankine: ');

[w_net, cycle_efficiency] = cycle(r_p,t4,regen,regen_efficiency);

disp(w_net);
disp(cycle_efficiency);

