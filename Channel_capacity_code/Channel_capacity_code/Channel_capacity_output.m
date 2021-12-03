function Channel_capacity_output(parameters, symtc)
% CHANNEL_CAPACITY_OUTPUT  In Command Window or Figure, the optimal source
%                          distribution 'Pi', channel capacity 'C', number
%                          of iterations 'k' and the relative change of
%                          channel capacity 'variation' in the process of
%                          iteration are visualized.
%
%
%
% Notation explanation
%
% Inputs:
%       chcp_result
%           structure variable
%           Pi       : optimal source distribution;
%           C        : channel capacity sequence generated in iteration
%                      process, unit: bit/symbol;
%           k        : ① iterations in channel capacity iterative
%                         algorithm 'Channel_capacity_itrtn_algrtm.m';
%                      ② if Pij is a nonsingular asymmetric matrix and the
%                         optimal source distribution(Pi) takes values on
%                         the boundary,   'k' is -1;
%                      ③ in other cases, 'k' is  1;
%           variation: relative error sequence generated in iteration
%                      process.
%       symtc: whether the matrix Pij is symmetric or para-symmetric:
%              ① if Pij is asymmetric    , symtc = 0;
%              ② if Pij is symmetric     , symtc = 1;
%              ③ if Pij is para-symmetric, symtc = 2.
%
% Output:
%   None.

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
% $ Date : 2021-06-15 11:30:15
% Author : Huang He
% E-mail : huanghe_ptm@protonmail.com
%          Alternate: 2327012749@qq.com
% Ver    : 1.0
% Desc   : Channel capacity for DMC.
% Webpage: https://github.com/HUANG-He-Star/MATLAB_projects.git

%% 1.   Visual output.

if (parameters.k ~=1) && (parameters.k~= -1)
    %% 1.1.
    % If the iterative algorithm is used to solve, the variation curve of
    % channel capacity with the number of iterations and the variation
    % curve of relative variation of channel capacity with the number of
    % iterations in the iterative process are drawn to verify the
    % convergence of channel capacity.
    
    fig = figure;
    set(fig, 'units', 'normalized', 'position', [1/2 0.02 1/3 0.85])
    
    subplot(211)
    plot(1 : parameters.k, parameters.C, 'r-*')
    xlabel('Interations k'); ylabel('Channel capacity  /  (bit/symbol)')
    grid minor
    title(['The tendency of Value C(Channel capacity) with the ', ...
        'Interations k'])
    
    subplot(212)
    semilogy(  1 : parameters.k, parameters.variation, 'k-o'  )
    xlabel('Interations k'); ylabel('Relative variation'); grid minor
    title('The tendency of Relative variation with the Interations k')
    
    fprintf('This is a singular and asymmetric matrix,\n')
    fprintf('which is solved by iterative algorithm.\n\n')
    fprintf('Number of iterations:\t\t\tk  = ')
    fprintf('%d\r\n', parameters.k)              % Output iteration times k
    
elseif parameters.k == -1
    %% 1.2.
    parameters.k = length(parameters.C);
    
    fig = figure;
    set(fig, 'units', 'normalized', 'position', [1/2 0.02 1/3 0.85])
    
    subplot(211)
    plot(1 : parameters.k, parameters.C, 'r-*')
    xlabel('Interations k'); ylabel('Channel capacity  /  (bit/symbol)')
    grid minor
    title(['The tendency of Value C(Channel capacity) with the ', ...
        'Interations k'])
    
    subplot(212)
    semilogy(  1 : parameters.k, parameters.variation, 'k-o'  )
    xlabel('Interations k'); ylabel('Relative variation'); grid minor
    title('The tendency of Relative variation with the Interations k')
    
    fprintf('This is a nonsingular asymmetric matrix, but\n')
    fprintf('it should be solved by iterative algorithm,\n')
    fprintf('because the best source is distributed on the\n')
    fprintf('boundary.\n\n')
    fprintf('Number of iterations:\t\t\tk  = ')
    fprintf('%d\r\n', parameters.k)              % Output iteration times k
    
elseif symtc == 0
    fprintf('This is a nonsingular asymmetric matrix,\n')
    fprintf('which is solved by a general algorithm, and\n')
    fprintf('the optimal source distribution is not on the\n')
    fprintf('boundary.\n\n')
    
elseif symtc == 1
    fprintf('This is a symmetric DMC matrix, and the best\n')
    fprintf('source distribution is equal probability\n')
    fprintf('distribution.\n\n')
    
elseif symtc == 2
    fprintf('This is a para-symmetric DMC matrix, and the\n')
    fprintf('best source distribution is equal probability\n')
    fprintf('distribution.\n\n')
    
end

fprintf('The best source distribution is:Pi =\r\n\t\t\t\t\t\t\t\t\t')

% Output optimal source distribution Pi.
fprintf(' %f\r\n\t\t\t\t\t\t\t\t\t', parameters.Pi)

fprintf('\nChannel capacity:\t\t\t\tC  = ')
fprintf('%f\r\n', parameters.C(parameters.k))    % Output C value

end
