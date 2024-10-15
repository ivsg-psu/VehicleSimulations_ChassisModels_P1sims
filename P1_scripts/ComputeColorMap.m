function InputColors = ComputeColorMap(Input, LowerLimitValue, UpperLimitValue, dim1, dim2)

% if strcmp(LowerLimitValue, 'Positive Only')
%     InputVec = reshape(Input, dim1*dim2,1);
%     InputColors = [1-(1/UpperLimitValue)*abs(InputVec) ones(dim1*dim2,1) 1-(1/UpperLimitValue)*abs(InputVec)];
% elseif strcmp(UpperLimitValue, 'Negative Only')
%     InputVec = reshape(Input, dim1*dim2,1);
%     InputColors = [ones(dim1*dim2,1) 1-(1/LowerLimitValue)*abs(InputVec) 1-(1/LowerLimitValue)*abs(InputVec)];    
% else
%     InputVec = reshape(Input, dim1*dim2,1);
%     InputVecPos = reshape(Input.*(Input >= 0), dim1*dim2, 1);
%     InputVecNeg = reshape(Input.*(Input < 0), dim1*dim2, 1);
%     
%     InputColorsNeg = [ones(dim1*dim2,1) 1-(1/LowerLimitValue)*abs(InputVecNeg) 1-(1/LowerLimitValue)*abs(InputVecNeg)];
%     sumVec = sum(InputColorsNeg')';
%     filterVec = (sumVec < 3);
%     InputColorsNeg = [InputColorsNeg(:,1).*filterVec InputColorsNeg(:,2).*filterVec InputColorsNeg(:,3).*filterVec];
%     InputColorsPos = [1-(1/UpperLimitValue)*abs(InputVecPos) ones(dim1*dim2,1) 1-(1/UpperLimitValue)*abs(InputVecPos)];
%     sumVec = sum(InputColorsPos')';
%     filterVec = (sumVec < 3);
%     InputColorsPos = [InputColorsPos(:,1).*filterVec InputColorsPos(:,2).*filterVec InputColorsPos(:,3).*filterVec];
%     InputColors = InputColorsNeg + InputColorsPos;
% end

if strcmp(LowerLimitValue, 'Positive Only')
    InputColors(:, :, 1) = 1-(1/UpperLimitValue)*abs(Input);
    InputColors(:, :, 2) = ones(dim1,dim2);
    InputColors(:, :, 3)  =1-(1/UpperLimitValue)*abs(Input);
    
elseif strcmp(UpperLimitValue, 'Negative Only')
    InputColors(:, :, 1) = ones(dim1,dim2);
    InputColors(:, :, 2) = 1-(1/LowerLimitValue)*abs(Input);
    InputColors(:, :, 3) = 1-(1/LowerLimitValue)*abs(Input);
else    
    InputColors(:, :, 1) = ones(dim1,dim2).*(Input < 0) + (1-(1/UpperLimitValue)*abs(Input)).*(Input >= 0);
    InputColors(:, :, 2) = (1-(1/LowerLimitValue)*abs(Input)).*(Input < 0) + ones(dim1,dim2).*(Input >= 0);
    InputColors(:, :, 3) = (1-(1/LowerLimitValue)*abs(Input)).*(Input < 0) + (1-(1/UpperLimitValue)*abs(Input)).*(Input >= 0);    
end