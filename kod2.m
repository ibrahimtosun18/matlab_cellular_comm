clc;
clear;

% Define longer chip patterns for detailed simulation
chip_patterns = {
    [1 1 1 -1 -1 1 1 -1],  % Station J
    [-1 1 -1 1 -1 1 1 -1], % Station K
    [-1 -1 1 -1 1 1 1 -1]  % Station L
};

r = round(rand(1, 20)); % Random bits to transmit
cdma_seq = zeros(1, 20 * length(chip_patterns{1})); % Initialize CDMA sequence array

% Fixed colors for each station
colorMap = [1 0 0; 0 1 0; 0 0 1];  % Red for J, Green for K, Blue for L

figure;
hold on;

% Generate the CDMA sequence and plot with fixed colors
for counter = 1:20
    station = randi([1 3]); % Randomly select a station for each bit
    bit_pattern = chip_patterns{station}; % Select the chip pattern for the chosen station
    if r(counter) == 0
        bit_pattern = -bit_pattern; % Flip the pattern for 0
    end
    start_index = (counter - 1) * length(bit_pattern) + 1;
    end_index = start_index + length(bit_pattern) - 1;
    cdma_seq(start_index:end_index) = bit_pattern; % Place the pattern in the sequence
    area(start_index:end_index, cdma_seq(start_index:end_index), 'FaceColor', colorMap(station, :), 'EdgeColor', 'none');
end

title('Interactive CDMA Encoded Signal for Simulation 3');
xlabel('Chip Index');
ylabel('Value');
hold off;

% Decoding the CDMA sequence
decoded_bits = zeros(1, 20);
decoded_info = '';
for idx = 1:20
    segment = cdma_seq((idx-1) * 8 + 1 : idx * 8); % Extract segments of the encoded sequence
    correlation = zeros(1, 3);
    for station = 1:3
        correlation(station) = dot(segment, chip_patterns{station}); % Compute correlation
    end
    [~, max_idx] = max(correlation); % Find the station with the highest correlation
    decoded_bits(idx) = max_idx; % Assign the decoded bit based on the station
    decoded_info = [decoded_info sprintf('\nBit %d comes from Station %c', idx, 'J' + decoded_bits(idx) - 1)];
end

% Display the decoded results
disp('Decoded sequence:');
disp(decoded_info);