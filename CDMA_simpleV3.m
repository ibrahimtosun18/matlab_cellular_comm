clc;
clear;

% Define extended chip patterns for a more complex CDMA simulation involving five stations
chip_patterns = {
    [1 1 -1 -1 1 1 1 -1],  % Chip pattern for Station P
    [-1 1 1 -1 -1 1 -1 1], % Chip pattern for Station Q
    [1 -1 -1 1 1 -1 1 -1], % Chip pattern for Station R
    [-1 -1 1 1 -1 -1 1 1], % Chip pattern for Station S
    [1 -1 1 -1 1 -1 1 -1]  % Chip pattern for Station T
};

% Generate 50 random bits to transmit
r = round(rand(1, 50)); 

% Initialize the CDMA sequence to accommodate the maximum possible overlap of patterns
cdma_seq = zeros(1, 50 * length(chip_patterns{1}));

% Create the CDMA sequence with potential overlapping transmissions
for counter = 1:50
    % Randomly select 1-3 stations to be active for each bit
    active_stations = randi([2 5], 1, randi([1 3]));
    for station = active_stations
        bit_pattern = chip_patterns{station}; % Select chip pattern for the active station
        if r(counter) == 0
            bit_pattern = -bit_pattern; % Flip the pattern if the bit is 0
        end
        start_index = (counter - 1) * length(bit_pattern) + 1;
        end_index = start_index + length(bit_pattern) - 1;
        cdma_seq(start_index:end_index) = cdma_seq(start_index:end_index) + bit_pattern; % Add patterns to CDMA sequence
    end
end

% Visualize the distribution of CDMA signal values with a histogram
figure;
histogram(cdma_seq, 'BinWidth', 1);
title('Histogram of CDMA Signal Values with Multiple Stations');
xlabel('Signal Value');
ylabel('Frequency');
grid on;

% Decoding the CDMA sequence to identify contributions from each station
decoded_contributions = zeros(length(chip_patterns), 50);
for idx = 1:50
    segment = cdma_seq((idx - 1) * 8 + 1 : idx * 8); % Extract each bit's segment from the sequence
    for station = 1:length(chip_patterns)
        correlation = dot(segment, chip_patterns{station}); % Calculate correlation for each station
        if abs(correlation) > length(chip_patterns{1}) * 0.7 % Set a threshold to detect significant contribution
            decoded_contributions(station, idx) = sign(correlation); % Record the contribution as 1 or -1
        end
    end
end

% Display detailed contributions from each station
disp('Decoded Contributions:');
for station = 1:length(chip_patterns)
    fprintf('Station %c contributes bits: ', 'P' + station - 1);
    contrib_bits = find(decoded_contributions(station, :) ~= 0);
    fprintf('%d ', contrib_bits);
    fprintf('\n');
end
