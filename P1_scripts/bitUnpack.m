function newDouble = bitUnpack(storedVariable,bytePos,bitPos)
%bitUnpack, Script for unpacking specific individual bits from uint8 data for use in
% plotting and other uses for data in double form
% Ex: plotting Control Panel data as doubles

% Only works for variables setup for use with P1 variables as of Summer
% 2022 where variables are given with columns being the different bytes of
% data taken and the rows being the bytes of data taken over time

% Establish new double variable which is ouptput of function
% Calling it double is redundant as zeros() only creates a double ever,
% just doing for sake of certainty since working with multiple different
% int types
newDouble = double(zeros(length(storedVariable(:,1)),1));

for k = 1:length(storedVariable(:,1))
    newDouble(k) = double(bitget(storedVariable(k,bytePos),bitPos));
end

end

