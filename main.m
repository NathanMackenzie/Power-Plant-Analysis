% created by: Nathan Mackenzie, and Cameron Campbell 
% DATE: 20-Apr-2017
% 
% This program iterates through a series of different input values and
% then outputs them into an excel spreadsheet for analysis.

inputs = []; % Matrix of input values to the power plant simulation
results = []; % Matrix of output values of the power plan

% Iterates through different values of compressor ratios
for r_p = 4:2:10
    % Iterates through different turbine inlet temperatures
    for temp = 1620:360:2700
        
        % Case for when there is no regenerator in use
        [w_net, cycle_efficiency, irrev] = cycle(r_p,temp,0);
        inputs = [inputs; r_p, temp, 0];
        results = [results; w_net, cycle_efficiency, irrev];
        
        % Iterates through different regenerator efficiency values
        for regen_eff = .4:.1:.9
           [w_net, cycle_efficiency, irrev] = cycle(r_p,temp,regen_eff);
           results = [results; w_net, cycle_efficiency, irrev]; 
           inputs = [inputs; r_p, temp, regen_eff];
        end
        
        % Case for when the regenerator has an efficiency of 95%
        [w_net, cycle_efficiency, irrev] = cycle(r_p,temp,.95);
        results = [results; w_net, cycle_efficiency, irrev];
        inputs = [inputs; r_p, temp, .95];
    end
end

% Combine the input and output matricies into one large matrix
results = horzcat(inputs, results);

% Write results to an excel output file
filename = 'power-plant-data.xlsx';
xlswrite(filename, results);
