%%
% Description:
% Generates properties of circular ring codes
%
% Author:
% Michael Loesler
%
% Original:
% Matthew Petroff (2018) Photogrammetry Targets. 
% https://mpetroff.net/2018/05/photogrammetry-targets/
%
% Generate codes for circular coded photogrammetry targets.
% Implementation of coding scheme of (expired) patent DE19733466A1.
% https://patents.google.com/patent/DE19733466A1/
% https://register.dpma.de/DPMAregister/pat/register?AKZ=197334660
% 
% This script is released into the public domain using the CC0 1.0 Public
% Domain Dedication: https://creativecommons.org/publicdomain/zero/1.0/
% 
% Generate codes for a given number of bits and, optionally, a given number
% of transitions. Number of bits should be even.
%
function [codes] = getRingCodes(bits, transitions)
    if nargin < 1
        bits = 8;
    end
    if nargin < 2
        transitions = -1;
    end
    
    if bits < 0
        error('Number of bits must be positive!');
    end
    
    if mod(bits,2) ~= 0
        error('Number of bits must be even!');
    end
    
    if transitions < 0 && transitions ~= -1
        error('Number of transitions must be positive!');
    end
    
    
    bits  = int32(bits);
    codes = int32([]);
    half_bits = bitsrl(bits, 1);
    
    for i=0:2^(bits-2)-1
        code = bitsll(i, 1) + 1;
        code = findSmallestRotation(code, bits);

        diff = bitand(bitand(code, 2^half_bits-1), bitsrl(bitand(code, bitsll(2^half_bits-1, half_bits)), half_bits));
        parity = calcParity(code);

        num_transitions = -1;
        if transitions ~= -1
            num_transitions = countBitTransitions(code);
        end

        if parity && diff > 0 && transitions == num_transitions && ~any(ismember(codes, code))
            codes = [codes; code];
        end
    end
end
   
%%
% Check all bitwise rotations to find smallest representation.
function [smallest] = findSmallestRotation(val, total_bits)
    smallest = val;
    for i=1:total_bits-1
        smallest = min(bitwiseRotateLeft(val, i, total_bits), smallest);
    end
end

%%
% Perform a bitwise rotation to the left.
function [rot_val] = bitwiseRotateLeft(val, bits, total_bits)
    rot_val = bitor(bitand(bitsll(val, bits), 2^total_bits-1), bitsrl(bitand(val, 2^total_bits-1), total_bits-bits));
end

%%
% Returns True if even parity, else False.
function [parity] = calcParity(val)
    parity = true;
    while val
        parity = ~parity;
        val = bitand(val, val - 1);
    end
end

%%
% Count number of bit transitions.
function [transitions] = countBitTransitions(val)
    transitions = 0;
    prev_bit    = 0;
    while val
        new_bit = bitand(val, 1);
        if new_bit > prev_bit
            transitions = transitions + 1;
        end
        prev_bit = new_bit;
        val = bitsrl(val, 1);
    end
end
