clc;
clear;

% Initialize a sequence of 20 random bits.
r = round(rand(1, 20));

% Define chip patterns for stations A, B, and C
% Each pattern is a sequence that represents bits 1 or 0.
a_one = [1 -1 -1 1 -1 1];
a_zero = -1 * a_one;  % Inverse of a_one pattern for bit 0
b_one = [1 1 -1 -1 1 1];
b_zero = -1 * b_one;  % Inverse of b_one pattern for bit 0
c_one = [1 1 -1 1 1 -1];
c_zero = -1 * c_one;  % Inverse of c_one pattern for bit 0

% Construct the CDMA sequence for all stations
cdma_seq = [];
for counter = 1:20
    % Randomly assign bits from one of three stations to the CDMA sequence
    switch(randi([1 3]))  % Randomly pick station A, B, or C
        case 1  % Station A
            if r(1, counter) == 0
                cdma_seq = [cdma_seq, a_zero];
            else
                cdma_seq = [cdma_seq, a_one];
            end
        case 2  % Station B
            if r(1, counter) == 0
                cdma_seq = [cdma_seq, b_zero];
            else
                cdma_seq = [cdma_seq, b_one];
            end
        case 3  % Station C
            if r(1, counter) == 0
                cdma_seq = [cdma_seq, c_zero];
            else
                cdma_seq = [cdma_seq, c_one];
            end
    end
end

% Visualize the CDMA encoded signal
figure;
subplot(2, 1, 1); % First subplot in a 2x1 grid
stem(cdma_seq, 'Marker', 'o');
title('CDMA Encoded Signal');
xlabel('Chip Index');
ylabel('Value');

% Decode the CDMA signal
cntr = 0;
decoded_bits = zeros(1, 20);
for selector = 1:6:120  % Each bit's chip sequence spans 6 indices
    cntr = cntr + 1;
    % Extract a segment corresponding to a single bit
    temp = cdma_seq(selector:selector + 5);
    
    % Calculate dot products to decode the signal
    result1 = dot(a_one, temp);
    result2 = dot(b_one, temp);
    result3 = dot(c_one, temp);
    
    % Determine which station the bit came from based on the dot product
    if abs(result1) == 6
        fprintf('\nThe bit # %d is from Station A', cntr);
        decoded_bits(cntr) = 1;  % Assign 1 for Station A
    elseif abs(result2) == 6
        fprintf('\nThe bit # %d is from Station B', cntr);
        decoded_bits(cntr) = 2;  % Assign 2 for Station B
    elseif abs(result3) == 6
        fprintf('\nThe bit # %d is from Station C', cntr);
        decoded_bits(cntr) = 3;  % Assign 3 for Station C
    end
end

% Visualize the Decoded Bits
subplot(2, 1, 2); % Second subplot in a 2x1 grid
stem(decoded_bits, 'Marker', 'x', 'LineStyle', 'none');
title('Decoded Bits');
xlabel('Bit Index');
ylabel('Station');
