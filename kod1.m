clc
clear

% Generation of Random Bits
r = round(rand(1, 20));

% Chip Pattern for station A, B and C
a_one = [1 -1 -1 1 -1 1];
a_zero = -1 * a_one;
b_one = [1 1 -1 -1 1 1];
b_zero = -1 * b_one;
c_one = [1 1 -1 1 1 -1];
c_zero = -1 * c_one;

% Random Allotment of bits to stations A, B, and C
cdma_seq = [];
for counter = 1:20
    switch(randi([1 3]))
        case(1)
            if r(1, counter) == 0
                cdma_seq = [cdma_seq a_zero];
            else
                cdma_seq = [cdma_seq a_one];
            end
        case(2)
            if r(1, counter) == 0
                cdma_seq = [cdma_seq b_zero];
            else
                cdma_seq = [cdma_seq b_one];
            end
        case(3)
            if r(1, counter) == 0
                cdma_seq = [cdma_seq c_zero];
            else
                cdma_seq = [cdma_seq c_one];
            end
    end
end

% Plot the CDMA encoded signal
figure;
subplot(2, 1, 1);
stem(cdma_seq, 'Marker', 'o');
title('CDMA Encoded Signal');
xlabel('Chip Index');
ylabel('Value');

% Decoding the Signal
cntr = 0;
decoded_bits = zeros(1, 20);
for selector = 1:6:120
    cntr = cntr + 1;
    temp = [cdma_seq(1, selector) cdma_seq(1, selector + 1) cdma_seq(1, selector + 2) ...
        cdma_seq(1, selector + 3) cdma_seq(1, selector + 4) cdma_seq(1, selector + 5)];
    result1 = dot(a_one, temp);
    result2 = dot(b_one, temp);
    result3 = dot(c_one, temp);
    
    if (result1 == 6) || (result1 == -6)
        fprintf('\nThe bit # %d is from Station A', cntr);
        decoded_bits(cntr) = 1;
    else
        if (result2 == 6) || (result2 == -6)
            fprintf('\nThe bit # %d is from Station B', cntr);
            decoded_bits(cntr) = 2;
        else
            if (result3 == 6) || (result3 == -6)
                fprintf('\nThe bit # %d is from Station C', cntr);
                decoded_bits(cntr) = 3;
            end
        end
    end
end

% Plot the Decoded Bits
subplot(2, 1, 2);
stem(decoded_bits, 'Marker', 'x', 'LineStyle', 'none');
title('Decoded Bits');
xlabel('Bit Index');
ylabel('Station');
