clc;
clear;

% Define extended chip patterns for a more complex simulation
chip_patterns = {
    [1 1 -1 -1 1 1 1 -1],  % Station P
    [-1 1 1 -1 -1 1 -1 1], % Station Q
    [1 -1 -1 1 1 -1 1 -1], % Station R
    [-1 -1 1 1 -1 -1 1 1], % Station S
    [1 -1 1 -1 1 -1 1 -1]  % Station T
};

r = round(rand(1, 50)); % Increased number of bits to transmit
cdma_seq = zeros(1, 50 * length(chip_patterns{1})); % Adjusted for more bits and patterns

% Generate the CDMA sequence with overlapping transmissions
for counter = 1:50
    active_stations = randi([2 5], 1, randi([1 3])); % Randomly pick 1-3 stations active per bit
    for station = active_stations
        bit_pattern = chip_patterns{station}; % Select the chip pattern for the chosen station
        if r(counter) == 0
            bit_pattern = -bit_pattern; % Flip the pattern for 0
        end
        start_index = (counter - 1) * length(bit_pattern) + 1;
        end_index = start_index + length(bit_pattern) - 1;
        cdma_seq(start_index:end_index) = cdma_seq(start_index:end_index) + bit_pattern; % Overlap patterns
    end
end

% Visualizing the CDMA signal using a histogram to show distribution of combined signal values
figure;
histogram(cdma_seq, 'BinWidth', 1);
title('Histogram of CDMA Signal Values with Multiple Stations');
xlabel('Signal Value');
ylabel('Frequency');
grid on;

% Decoding the CDMA sequence to identify contributions from each station
decoded_contributions = zeros(length(chip_patterns), 50);
for idx = 1:50
    segment = cdma_seq((idx-1) * 8 + 1 : idx * 8); % Extract segments of the encoded sequence
    for station = 1:length(chip_patterns)
        correlation = dot(segment, chip_patterns{station}); % Compute correlation for each station
        if abs(correlation) > length(chip_patterns{1}) * 0.7 % Threshold for detecting significant contribution
            decoded_contributions(station, idx) = sign(correlation); % Assign contribution as 1 or -1
        end
    end
end

% Display the decoded results with detailed contributions
disp('Decoded Contributions:');
for station = 1:length(chip_patterns)
    fprintf('Station %c contributes bits: ', 'P' + station - 1);
    contrib_bits = find(decoded_contributions(station, :) ~= 0);
    fprintf('%d ', contrib_bits);
    fprintf('\n');
end