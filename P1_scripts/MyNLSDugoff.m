% JH 8/18/05
% My NLS code to fit force-slip data to the Dugoff Model
% Function takes in:
%   front force data Fyf (N):           Nx1 
%   front slip angle alpha (rad):       Nx1
%   front load Fnf (N):                 1x1
%   initial Caf guess Cafinit (N/rad):  1x1
%   initial mu guess muinit:            1x1
%   residual threshold rthres (N^2):    1x1
%   lower bound LB:                     2x1 [LB on Caf, LB on mu]
%   upper bound UB:                     2x1 [UB on Caf, UB on mu]
% and returns: Caf, mu, iteration

function xNLS = myNLS(Fyf, alpha, Fnf, Cafinit, muinit, rthres, LB, UB)

% initialize guess
Cafk = Cafinit; 
muk = muinit;
N = length(Fyf);
Ak = zeros(N,2);
bk = zeros(N,1);
diffr = rthres + 1;         % start residual difference at a value > rthres
iteration = 1;              % keep track of # of iterations it takes to converge
outofbounds = 0;
singular = 0;

while diffr > rthres
    for i = 1:N
        % calculate lambda (L or NL region?) to determine Ak and bk
        lambda = muk*Fnf/(2*Cafk*abs(tan(alpha(i))));
        if lambda >= 1 % linear
            Ak(i,:) = [tan(alpha(i)), 0];
            bk(i) = -Fyf(i);
        else  % nonlinear
            Ak(i,:) = [muk^2*Fnf^2/(4*tan(alpha(i))*Cafk^2), Fnf*sign(alpha(i))-muk*Fnf^2/(2*Cafk*tan(alpha(i)))];
            bk(i,:) = Ak(i,:)*[Cafk; muk] - Fyf(i) - muk*Fnf*sign(alpha(i)) + muk^2*Fnf^2/(4*Cafk*tan(alpha(i)));
        end
    end
    % approximate as LS problem
    svdvalue = max(svd(Ak'*Ak));
    if svdvalue < 5
        singular = 1
        xNLS = [Cafinit muinit iteration svdvalue outofbounds singular]';
        return
    else
        xnext = inv(Ak'*Ak)*Ak'*bk;
        % set LS solution as next guess
        Cafk = xnext(1);
        muk = xnext(2);
        
        % check if LS solution exceeds bounds
        if Cafk < LB(1) | Cafk > UB(1) | muk < LB(2) | muk > UB(2)
            outofbounds = 1
            xNLS = [Cafinit muinit iteration svdvalue outofbounds singular]';
            return
        end
        % check residual value
        % first, calculate Fyfdugoff
        Fyfdugoff = zeros(N,1);
        for j = 1:N
            if alpha(j) == 0
                Fyfdugoff(j) = 0;
            else
                lambdad = muk*Fnf/(2*Cafk*abs(tan(alpha(j))));
                if lambdad < 1
                    f = (2-lambdad)*lambdad;
                else
                    f = 1;
                end
                Fyfdugoff(j) = -Cafk*tan(alpha(j))*f;
            end
        end
        r = (norm(Fyf - Fyfdugoff))^2;
        % look at difference in residuals
        if iteration > 1
            diffr = r - rlast;
        end
        rlast = r;
        % keep track of # of iterations
        iteration = iteration + 1;
        xNLS = [Cafk muk iteration svdvalue outofbounds singular]';
    end
end




