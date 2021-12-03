function chcp_result = Channel_capacity_nonSngr_algrtm(Pij, delta)
% CHANNEL_CAPACITY_NONSNGR_ALGRTM  Algorithm of channel capacity for DMC
%                                  matrix that satisfy the definition of
%                                  nonsingular asymmetric channel
%                                  transition probability matrix, the
%                                  channel capacity(C) and optimal source
%                                  distribution(Pi) can be calculated by
%                                  this function.
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
%           C        : channel capacity scalar or array, unit: bit/symbol;
%           k        : temporarily default to 1, if the optimal source
%                      distribution(Pi) takes values on the boundary, set
%                      to -1;
%           variation: default to 0, if the optimal source distribution(Pi)
%                      takes values on the boundary, it's a array.

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
% $ Date : 2021-06-15 21:55:52
% Author : Huang He
% E-mail : huanghe_ptm@protonmail.com
%          Alternate: 2327012749@qq.com
% Ver    : 1.0
% Desc   : Channel capacity for DMC.
% Webpage: https://github.com/HUANG-He-Star/MATLAB_projects.git

%% 1.
chcp_result.k = 1;
[r, ~] = size(Pij);
h_Yx = zeros(r, 1);
for i = 1:r
    h_Yx(i) = sum(rmmissing(Pij(i, :) .* log2(Pij(i, :))));
end

beta = Pij \ h_Yx;
chcp_result.C = log2(sum(2 .^ beta));
Pj = 2 .^ (beta - chcp_result.C);
chcp_result.Pi = Pij' \ Pj;
chcp_result.variation = 0;

if sum(chcp_result.Pi<0) > 0
    %% 1.1.
    % When the input is distributed on the boundary, the solution is very
    % troublesome, and the iterative algorithm function 
    % Channel_capacity_itrtn_algrtm.m is called to solve it.
    
    chcp_result = Channel_capacity_itrtn_algrtm(Pij, delta);
    chcp_result.k = -1;
    
end

end
