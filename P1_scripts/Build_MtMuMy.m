%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MT
%%% Construct Transform Matrix MT for dU=MT*Z
[temp, colNum]=size(MTinfo);
num=1;
for m=1:colNum
    for n=1:MTinfo(2,m)
        MTnum(num)=MTinfo(1,m);
        num=num+1;
    end
end
for m=1:P
    if sum(MTnum)>=P, break;end
    MTnum(num)=MTnum(num-1);
    num=num+1;
end
num=0;
for m=1:length(MTnum)
      num=num+MTnum(m);
      if num>=P, break; end
end
colNumOfMT=m; 
num=0;
for m=1:length(MTnum)    
for n=1:MTnum(m) 
    rowPos=(num+n-1)*uNum+1:(num+n)*uNum;
    colPos=(m-1)*uNum+1:m*uNum;
    MT(rowPos,colPos)=eye(uNum,uNum);
end
    num=num+MTnum(m);
end
MT=MT([1:P*uNum],[1:colNumOfMT*uNum]); % MT

%%%%%%%%%%%%%%%%%%%%%%%%%%%
MTnum=[ ];
[temp, colNum]=size(CSTRinfo);
num=1;
for m=1:colNum
    for n=1:CSTRinfo(2,m)
        MTnum(num)=CSTRinfo(1,m);
        num=num+1;
    end
end
for m=1:P
    if sum(MTnum)>=P, break;end
    MTnum(num)=MTnum(num-1);
    num=num+1;
end
num=0;
for m=1:length(MTnum)
      num=num+MTnum(m);
      if num>=P, break; end
end
rowNumOfMT=m;
%%% MdU
num=0;
% Construct Mdu
for m=1:length(MTnum)
    rowPos=((m-1)*uNum+1):(m*uNum);
    colPos=num*uNum+(1:uNum);
    MdU(rowPos,colPos)=eye(uNum,uNum);
    num=num+MTnum(m);
end
MdU=MdU([1:rowNumOfMT*uNum],[1:P*uNum]); % MdU
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MdU
MUi=MdU;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MY
num=0;
% Construct Mdu
for m=1:length(MTnum)
    rowPos=((m-1)*xNum+1):(m*xNum);
    colPos=num*xNum+(1:xNum);
    MY(rowPos,colPos)=eye(xNum,xNum);
    num=num+MTnum(m);
end
MY=MY([1:rowNumOfMT*xNum],[1:P*xNum]); % MdU
%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compute safety point number in predictive horizon
[temp, colNum]=size(CSTRinfo);
num=1;
for m=1:colNum
    for n=1:CSTRinfo(2,m)
        MTnum(num)=CSTRinfo(1,m);
        num=num+1;
    end
end
for m=1:SAFEinfo
    if sum(MTnum)>=SAFEinfo, break;end
    MTnum(num)=MTnum(num-1);
    num=num+1;
end
num=0;
for m=1:length(MTnum)
      num=num+MTnum(m);
      if num>=SAFEinfo, break; end
end
SAFEpoint=m;
