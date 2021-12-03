function options = Channel_capacity_parameter_settings
% CHANNEL_CAPACITY_PARAMETER_SETTINGS  Get the user's input data.
%
%
%
% Notation explanation
%
%   Input:
%       None.
%
%   Output:
%       options
%           structure variable
%           Pij  : channel transition probability matrix;
%           delta: channel capacity relative error threshold δ;
%           slctn: (char variable)selection of choice 'A' or 'B';
%           cortn
%               structure variable
%               Pij    : check the correctness of channel transition
%                        probability matrix Pij:
%                        ① if it's correct  , options.cortn.Pij = 1;
%                        ② if it's incorrect, options.cortn.Pij = 0;
%               delta  : check the correctness of channel capacity relative
%                        error threshold δ:
%                        ① if δ >  0, options.cortn.delta = 1;
%                        ② if δ <= 0, options.cortn.delta = 0;
%               nonSngr: judge whether the matrix is nonsingular:
%                        ① if it's nonsingular, options.cortn.nonSngr = 1;
%                        ② if it's singular or non-square matrix,
%                           options.cortn.nonSngr = 0.

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
% $ Date : 2021-06-14 14:53:52
% Author : Huang He
% E-mail : huanghe_ptm@protonmail.com
%          Alternate: 2327012749@qq.com
% Ver    : 1.0
% Desc   : Channel capacity for DMC.
% Webpage: https://github.com/HUANG-He-Star/MATLAB_projects.git

%% 1.
% The user chooses to randomly generate a channel transition probability
% matrix with R rows and s columns or input one by himself.

options.slctn = questdlg([
    'Do you want to:                                                   '...
    '         A. Randomly generate a channel transition probability mat'...
    'rix with known rows and columns                                   '...
    '                           B. Manually input your own channel tran'...
    'sition probability matrix'], ...
    'Type selection', 'A', 'B', 'A');

dlg_title = 'Initial setting of CHANNEL CAPACITY';

%% 2.
switch options.slctn
    
    case 'A'
        %% 2.1.
        % Randomly generate a channel transition probability matrix with
        % known rows and columns.
        
        prompt = {[
            'Please input NUMBER OF  ROWS   of transition probability m'...
            'atrix Pij(or the number of inputs):'
            ], ...
            [
            'Please input NUMBER OF COLUMNS of transition probability m'...
            'atrix Pij(or the number of outputs):'
            ], ...
            [
            'Please enter the channel capacity relative error threshold'...
            ' δ(Please make sure that δ > 0, just can be used in ITER'...
            'ATIVE Algorithm for SINGULAR and ASYMMETRIC matrices):'
            ]};
        num_lines = [1 70];
        
        % The entered relative error threshold δ is 1e-12 by default.
        def = {'10', '10', '1e-12'};
        
        answer = inputdlg(prompt, dlg_title, num_lines, def);
        
        r = str2double(answer{1, 1});
        s = str2double(answer{2, 1});
        options.Pij = rand(r, s);
        options.Pij = options.Pij ./ sum(options.Pij, 2);
        options.cortn.Pij = 1;
        
    case 'B'
        %% 2.2.
        % Manually enter your own channel transition probability matrix.
        
        prompt = {[
            'Please input channel transition probability matrix Pij(Ple'...
            'ase make sure that the SUM of elements in each ROW of the '...
            'matrix is 1):'
            ], ...
            [
            'Please enter the channel capacity relative error threshold'...
            ' δ(Please make sure that δ > 0, just can be used in ITER'...
            'ATIVE Algorithm for SINGULAR and ASYMMETRIC matrices):'
            ]};
        num_lines = [5 70];
        
        % The entered relative error threshold δ is 1e-12 by default.
        def = {[
            '0.175 0.225 0.150 0.150 0.100 0.200; '...
            '0.050 0.300 0.055 0.200 0.150 0.245; '...
            '0.105 0.300 0.200 0.150 0.195 0.050; '...
            '0.150 0.225 0.050 0.275 0.050 0.250; '...
            '0.050 0.295 0.105 0.200 0.150 0.200; '...
            '0.225 0.100 0.200 0.150 0.075 0.250'
            ], ...
            '1e-12'};
        
        answer = inputdlg(prompt, dlg_title, num_lines, def);
        
        % Read the input channel transition probability matrix Pij.
        options.Pij   = str2num(answer{1, 1});
        
        % Calculate the number of rows and columns of the channel
        % transition probability matrix Pij.
        [r, s] = size(options.Pij);
        
        %% 2.3.
        % Check the error of the channel transition probability matrix. If
        % there is an error, an error warning box will pop up.
        
        % Due to the accuracy limitation of MATLAB itself, the result of
        % calculating line sum is not necessarily 1, e.g.:
        %             0.1 + 0.1 + 0.1 + 0.7 = 1 - 1.1102e-16 = 1 - eps / 2;
        %             1/3 + 1/3 + 1/6 + 1/6 = 1 - 1.1102e-16 = 1 - eps / 2;
        % Therefore, the correctness of Pij cannot be checked by strictly
        % judging whether the sum of each line is 1, but the error of EPS/2
        % is allowed.
        if (  abs(sum(sum(options.Pij, 2) - ones(r,1))) > r*eps/2  ) || ...
                ( sum(sum(sign(sign(options.Pij)+0.5))) ~= r*s )
            [~] = errordlg([
                'Input data error, please check the channel transition '...
                'probability matrix and rerun the program!'
                ], 'Error');
            options.cortn.Pij = 0;
        else
            options.cortn.Pij = 1;
        end
        
end

options.delta = str2double(answer{end, 1}); % read the value of δ

%% 3.
% If the value δ <= 0, the user will not be reminded of the error, but it
% will be changed to a default value 1e-12.
if options.delta <= 0
    options.delta = 1e-12;
    options.cortn.delta = 0;
else
    options.cortn.delta = 1;
end

%% 4.
% Judge whether the matrix is nonsingular. If it is not a square matrix, it
% is singular by default.
if r ~= s
    options.cortn.nonSngr = 0;
elseif det(options.Pij) ~= 0
    options.cortn.nonSngr = 1;
else
    options.cortn.nonSngr = 0;
end

end
