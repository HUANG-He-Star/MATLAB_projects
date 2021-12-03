function chcp_result = Channel_capacity_itrtn_algrtm(Pij, delta)
% CHANNEL_CAPACITY_ITRTN_ALGRTM  Iterative algorithm of channel capacity;
%                                ACTUALLY, for ALL DMC matrix that
%                                satisfy the definition of channel
%                                transition probability matrix, the channel
%                                capacity(C) and optimal source
%                                distribution(Pi) can be calculated by this
%                                function.
%
%
%
% Notation explanation
%
%   Inputs:
%       Pij  : channel transition probability matrix;
%       delta: channel capacity relative error threshold δ.
%
%   Output:
%       chcp_result
%           structure variable
%           Pi       : optimal source distribution;
%           C        : channel capacity sequence generated in iteration
%                      process, unit: bit/symbol;
%           k        : iterations;
%           variation: relative error sequence generated in iteration
%                      process.

%% 0.1. License.
% Copyright © 2021 HUANG-He-Star.
% Channel_capacity_code file/folder is licensed under the MIT license.
% You can use this software according to the terms and conditions of the
% MIT license.
% You may obtain a copy of the MIT license at:
%                                       https://opensource.org/licenses/MIT
% All Rights Reserved.
% Distributed under MIT license.
% See file LICENSE for detail or copy at:
%                                       https://opensource.org/licenses/MIT

%% 0.2. Information.
% $ Date : 2021-06-14 16:21:50
% Author : Huang He
% E-mail : huanghe_ptm@protonmail.com
%          Alternate: 2327012749@qq.com
% Ver    : 1.0
% Desc   : Channel capacity for DMC.
% Webpage: https://github.com/HUANG-He-Star/MATLAB_projects.git

%% 1.   Initialization.
[r, ~] = size(Pij);
k = 0;                     % Set iteration counter k = 0
chcp_result.C = -inf;      % Set the initial value of iteration C = - ∞

% The source distribution Pi is initialized to uniform distribution.
chcp_result.Pi(1:r) = 1/r;

num = zeros(1,r);

%% 2.   Iteration settings.
error(1) = delta+1;

% If the relative error is greater than the threshold, iteration is
% performed.
while error(k+1) > delta
    k = k+1;               % The iteration counter is incremented by one
    
    %% 2.1. calculate the iteration value of φ.
    fai = Pij' .* chcp_result.Pi ./ (sum( Pij .* chcp_result.Pi', 1 ))';
    
    %% 2.2.
    % Calculate the iterative value of the source distribution Pi.
    
    for i = 1:r
        % rmmissing:  Removes missing entries(e.g. NaN caused by 0*log2(0))
        %             from an array or table.
        num(i) = 2^(sum(  rmmissing(Pij(i,:)' .* log2(fai(:,i)))  ));
    end
    chcp_result.Pi = num / sum(num);
    
    %% 2.3. Calculate the iterative value of channel capacity C.
    % Directly use the summation value calculated in the previous code
    % block.
    chcp_result.C(1,k+1) = log2(sum(num));
    
    %% 2.4. Calculate the relative error.
    % Denominator protection, add a positive infinitesimal to the
    % denominator ε(in MATLAB, realmin is used to generate the minimum
    % positive number, and the value is 2.2251e-308).
    error(k+1) = abs(chcp_result.C(1,k+1)-chcp_result.C(1,k)) / ...
        (chcp_result.C(1,k+1)+realmin);
    
end

chcp_result.k = k;
chcp_result.variation = error(2 : end);
chcp_result.C = chcp_result.C(2 : end);

end
