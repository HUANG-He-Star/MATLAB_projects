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
% $ Date : 2021-06-15 23:19:44
% Author : Huang He
% E-mail : huanghe_ptm@protonmail.com
%          Alternate: 2327012749@qq.com
% Ver    : 1.0
% Desc   : Channel capacity for DMC.
% Webpage: https://github.com/HUANG-He-Star/MATLAB_projects.git

%% 0.3. Script file interpretation.
% Input interpretation:
%       First interface:
%               A. Second interface:
%                       Select random generation to meet the specified
%                       number of rows and columns of DMC and iteration
%                       accuracy (δ) Channel transition probability matrix
%                       Pij;
%               B. Second interface:
%                       Custom input a channel transfer probability matrix
%                       Pij satisfying DMC and iteration accuracy(δ).
%
% The following provides examples of Pij in various cases for the second
% interface input of item b:
%       symmetric:
%                 [1/3 1/3 1/6 1/6; 1/6 1/6 1/3 1/3]
%                                                    (result: C = 0.081704)
%               or
%                 [1/2 1/3 1/6; 1/6 1/2 1/3; 1/3 1/6 1/2]
%                                                    (result: C = 0.125815)
%               or
%                 [0.7 0.1 0.1 0.1; 0.1 0.7 0.1 0.1;
%                  0.1 0.1 0.7 0.1; 0.1 0.1 0.1 0.7]
%                                                    (result: C = 0.643220)
%       para-symmetric:
%                 [0.8 0.1 0.1; 0.1 0.1 0.8]         (result: C = 0.447067)
%               or
%                 [1/2 1/4 1/8 1/8; 1/4 1/2 1/8 1/8]
%                                                    (result: C = 0.061278)
%               or
%                 [1/3 1/3 0 1/3; 0 1/3 1/3 1/3; 1/3 0 1/3 1/3]
%                                                    (result: C = 0.389975)
%               or
%                 [0.1 0.1 0.2 0.2 0.4; 0.1 0.2 0.4 0.1 0.2;
%                  0.1 0.1 0.4 0.2 0.2; 0.1 0.2 0.2 0.1 0.4]
%                                                    (result: C = 0.073534)
%       asymmetric nonsingular:
%                 default matrix in choice 'B'
%               or
%                 [3/4 1/4 0; 1/3 1/3 1/3; 0 1/4 3/4]
%                                                (result: C  = 0.75
%                                                         Pi = [1/2 0 1/2])
%               or
%                 [0.5 0.25 0 0.25; 0 1 0 0; 0 0 1 0; 0.25 0 0.25 0.5]
%                                    (result: C  = 1.321928
%                                             Pi = [4/30 11/30 11/30 4/30])
%       asymmetric singular:
%                 [1 0; 1 0; 0.5 0.5; 0 1; 0 1]
%                                        (result: C  = 1
%                                                 Pi = [1/4 1/4 0 1/4 1/4])
%                 [0.35 0.45 0.20; 0.30 0.50 0.20;
%                  0.10 0.55 0.35; 0.35 0.45 0.20]
%                             (result: C  = 0.071891
%                                      Pi = [0.234114 0 0.531772 0.234114])

%% 1.   Clean up memory and cache.
clear; close all; clc

%% 2.   Gets the user's input data.
options = Channel_capacity_parameter_settings;

%% 3.
% If the channel transfer probability matrix is correct, the symmetry is
% discussed by classification, and the optimal source distribution Pi and
% channel capacity C are calculated.

if options.cortn.Pij == 1
    %% 3.1.
    % Determine whether it is a channel transition probability matrix of
    % symmetric channel or para-symmetric channel.
    
    symtc = Symtc_Chanl_mtx(options.Pij);
    
    %% 3.2.
    % Classify and calculate the optimal source distribution Pi and channel
    % capacity C.
    
    if symtc ~= 0
        %% 3.2.1.
        % Pij is a symmetric channel or a para-symmetric channel.
        
        chcp_result = Channel_capacity_symtc_algrtm(options.Pij);
        
    elseif (symtc == 0) && (options.cortn.nonSngr == 1)
        %% 3.2.2.
        % Pij is a nonsingular asymmetric matrix. In the algorithm, the
        % general algorithm is preferred to see whether the value is within
        % the boundary.
        
        chcp_result = ...
            Channel_capacity_nonSngr_algrtm(options.Pij, options.delta);
        
    else
        %% 3.2.3.
        % Pij is a singular and asymmetric matrix, which is solved by
        % iterative algorithm.
        
        chcp_result = ...
            Channel_capacity_itrtn_algrtm(options.Pij, options.delta);
        
    end
    
    %% 3.3. Visualize the output in the COMMAND WINDOW or FIGURE.
    Channel_capacity_output(chcp_result, symtc);
    
end
