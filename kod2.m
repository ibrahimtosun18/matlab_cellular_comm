clc;
clear;

% Define longer chip patterns for detailed simulation for each station
chip_patterns = {
    [1 1 1 -1 -1 1 1 -1],  % Chip pattern for Station J
    [-1 1 -1 1 -1 1 1 -1], % Chip pattern for Station K
    [-1 -1 1 -1 1 1 1 -1]  % Chip pattern for Station L
};

% Generate a sequence of 20 random bits
r = round(rand(1, 20)); % Random bits to transmit

% Initialize the CDMA sequence array to store chip sequences
cdma_seq = zeros(1, 20 * length(chip_patterns{1})); 

% Define fixed colors for the plot corresponding to each station
colorMap = [1 0 0; 0 1 0; 0 0 1];  % Red for J, Green for K, Blue for L

% Set up the plot for visualizing the CDMA encoding
figure;
hold on;
title('Interactive CDMA Encoded Signal for Simulation');
xlabel('Chip Index');
ylabel('Value');

% Encode and visualize the CDMA sequence
for counter = 1:20
    station = randi([1 3]); % Randomly select a station for each bit
    bit_pattern = chip_patterns{station}; % Select chip pattern based on the chosen station
    if r(counter) == 0
        bit_pattern = -bit_pattern; % Use the inverse pattern for bit 0
    end
    % Determine the indices in the CDMA sequence array
    start_index = (counter - 1) * length(bit_pattern) + 1;
    end_index = start_index + length(bit_pattern) - 1;
    % Insert the chip pattern into the CDMA sequence
    cdma_seq(start_index:end_index) = bit_pattern;
    % Plot the bit's chip pattern with the station's color
    area(start_index:end_index, cdma_seq(start_index:end_index), 'FaceColor', colorMap(station, :), 'EdgeColor', 'none');
end

hold off;

% Decoding the CDMA sequence
decoded_bits = zeros(1, 20);
decoded_info = '';

% Decode each bit in the sequence
for idx = 1:20
    segment = cdma_seq((idx-1) * 8 + 1 : idx * 8); % Extract the segment for each bit
    correlation = zeros(1, 3);
    % Compute the correlation with each station's chip pattern
    for station = 1:3
        correlation(station) = dot(segment, chip_patterns{station});
    end
    [~, max_idx] = max(correlation); % Identify the station with the highest correlation
    decoded_bits(idx) = max_idx; % Assign the decoded station
    % Append information about the decoded bit
    decoded_info = [decoded_info sprintf('\nBit %d comes from Station %c', idx, 'J' + max_idx - 1)];
end

% Display the decoded sequence and associated station information
disp('Decoded sequence:');
disp(decoded_info);
