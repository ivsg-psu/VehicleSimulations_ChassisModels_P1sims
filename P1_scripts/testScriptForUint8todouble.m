% Script for testing validity of uint8todouble.m function

% Generate one random number for each data type to be tested
uint16TestNum = uint16(randi(2^16-1));
int16TestNum = int16(randi(2^16-1)-2^15);
uint32TestNum = uint32(randi(2^32-1));
int32TestNum = int32(randi(2^32-1)-2^31);
uint64TestNum = uint64(2^64-randi(2^53-1));
int64TestNum = int64(-randi(2^53-1));
singleTestNum = single(10^(randi(30)-10)*randn(1));
doubleTestNum = 10^(randi(30)-10)*randn(1);

% Use the typecast function to break up each of the data types into arrays
% of uint8 with the same underlying data bits as the original variable
uint16TestArray = typecast(uint16TestNum,'uint8');
int16TestArray = typecast(int16TestNum,'uint8');
uint32TestArray = typecast(uint32TestNum,'uint8');
int32TestArray = typecast(int32TestNum,'uint8');
uint64TestArray = typecast(uint64TestNum,'uint8');
int64TestArray = typecast(int64TestNum,'uint8');
singleTestArray = typecast(singleTestNum,'uint8');
doubleTestArray = typecast(doubleTestNum,'uint8');

% Run the conversion function to rebuild the original data type from the
% array of uint8s
uint16ConvResult = uint8todouble(0,0,uint16TestArray(1),uint16TestArray(2));
int16ConvResult = uint8todouble(1,0,int16TestArray(1),int16TestArray(2));
uint32ConvResult = uint8todouble(0,0,uint32TestArray(1),uint32TestArray(2),...
    uint32TestArray(3),uint32TestArray(4));
int32ConvResult = uint8todouble(1,0,int32TestArray(1),int32TestArray(2),...
    int32TestArray(3),int32TestArray(4));
uint64ConvResult = uint8todouble(0,0,uint64TestArray(1),uint64TestArray(2),...
    uint64TestArray(3),uint64TestArray(4),...
    uint64TestArray(5),uint64TestArray(6),...
    uint64TestArray(7),uint64TestArray(8));
int64ConvResult = uint8todouble(1,0,int64TestArray(1),int64TestArray(2),...
    int64TestArray(3),int64TestArray(4),...
    int64TestArray(5),int64TestArray(6),...
    int64TestArray(7),int64TestArray(8));
singleConvResult = uint8todouble(0,1,singleTestArray(1),singleTestArray(2),...
    singleTestArray(3),singleTestArray(4));
doubleConvResult = uint8todouble(0,1,doubleTestArray(1),doubleTestArray(2),...
    doubleTestArray(3),doubleTestArray(4),...
    doubleTestArray(5),doubleTestArray(6),...
    doubleTestArray(7),doubleTestArray(8));

% Compare the test numbers to the function result and output success or
% failure notifications. A failure will stop the script and throw an error.
if uint16ConvResult ~= uint16TestNum
    error('uint16 conversion failure')
else
    disp('uint16 conversion success')
end
if int16ConvResult ~= int16TestNum
    error('int16 conversion failure')
else
    disp('int16 conversion success')
end
if uint32ConvResult ~= uint32TestNum
    error('uint32 conversion failure')
else
    disp('uint32 conversion success')
end
if int32ConvResult ~= int32TestNum
    error('int32 conversion failure')
else
    disp('int32 conversion success')
end
if uint64ConvResult ~= uint64TestNum
    error('uint64 conversion failure')
else
    disp('uint64 conversion success')
end
if int64ConvResult ~= int64TestNum
    error('int64 conversion failure')
else
    disp('int64 conversion success')
end
if singleConvResult ~= singleTestNum
    error('single conversion failure')
else
    disp('single conversion success')
end
if doubleConvResult ~= doubleTestNum
    error('double conversion failure')
else
    disp('double conversion success')
end
