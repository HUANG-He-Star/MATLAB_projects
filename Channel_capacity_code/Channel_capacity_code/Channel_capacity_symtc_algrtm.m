function chcp_result = Channel_capacity_symtc_algrtm(Pij)
% CHANNEL_CAPACITY_SYMTC_ALGRTM  Algorithm of channel capacity for DMC
%                                matrix that satisfy the definition of
%                                symmetric or para-symmetric channel
%                                transition probability matrix, the channel
%                                capacity(C) and optimal source
%                                distribution(Pi) can be calculated by this
%                                function.
%
%
%
% Notation explanation
%
%   Input:
%       Pij: channel transition probability matrix;
%
%   Output:
%       chcp_result
%           structure variable
%           Pi       : optimal source distribution(equal probability
%                      distribution);
%           C        : channel capacity, unit: bit/symbol;
%           k        : default to 1;
%           variation: default to 0.

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
% $ Date : 2021-06-15 20:56:09
% Author : Huang He
% E-mail : huanghe_ptm@protonmail.com
%          Alternate: 2327012749@qq.com
% Ver    : 1.0
% Desc   : Channel capacity for DMC.
% Webpage: https://github.com/HUANG-He-Star/MATLAB_projects.git

%% 1.
[r, ~] = size(Pij);
chcp_result.Pi = 1/r * ones(r, 1);

% rmmissing:  Removes missing entries (e.g. NaN caused by 0*log2(0)) from
%             an array or table.
chcp_result.C = ...
    sum(rmmissing( Pij(1,:) .* log2(Pij(1,:) .* r ./ sum(Pij, 1)) ));

chcp_result.k = 1;
chcp_result.variation = 0;

end
