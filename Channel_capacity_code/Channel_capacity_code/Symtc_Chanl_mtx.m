function symtc = Symtc_Chanl_mtx(Pij)
% SYMTC_CHANL_MTX  judge whether the channel transition probability matrix
%                  Pij is symmetric or para-symmetric.
%
%
%
% Notation explanation
%
%   Input:
%       Pij: channel transition probability matrix;
%
%   Output:
%       symtc: judge whether the matrix Pij is symmetric or para-symmetric:
%              ① if Pij is asymmetric    , symtc = 0;
%              ② if Pij is symmetric     , symtc = 1;
%              ③ if Pij is para-symmetric, symtc = 2.

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
% $ Date : 2021-06-15 01:08:04
% Author : Huang He
% E-mail : huanghe_ptm@protonmail.com
%          Alternate: 2327012749@qq.com
% Ver    : 1.0
% Desc   : Channel capacity for DMC.
% Webpage: https://github.com/HUANG-He-Star/MATLAB_projects.git

%% 1.
[r, s] = size(Pij);
symtc = -1;                                % symtc is initialized to -1

if (r == 1) && (s == 1)
    %% 1.1.
    % Pij = 1, single-input single-output (SISO) determined channel.
    
    symtc = 1;
    
elseif r == 1
    %% 1.2.
    % single-input multiple-output (SIMO) channel.
    
    if isequal( Pij, 1/s * ones(r, s) )
        symtc = 1;
    else
        symtc = 2;
    end
    
elseif s == 1
    %% 1.3.
    % Pij = [1; ...; 1], multiple-input single-output (MISO) determined
    % channel.
    
    symtc = 1;
    
elseif symtc_Row(Pij) ~= 1
    %% 1.4.
    % multiple-input multiple-output (MIMO) asymmetric channel.
    
    symtc = 0;
    
elseif (symtc_Row(Pij) == 1) && (symtc_Row(Pij') == 1)
    %% 1.5.
    % multiple-input multiple-output (MIMO) symmetric channel.
    
    symtc = 1;
    
else
    %% 1.6.
    % multiple-input multiple-output (MIMO) row symmetric channel; it is
    % necessary to judge whether it is a para-symmetric channel. If not,it
    % is an asymmetric channel.
    
    
    
    % Find the columns that contain the same elements and transpose them
    % together.
    tag = 1:s;
    Pij_col = sort(Pij, 1);
    
    for i = 1:s
        for j = i:s
            if isequal( Pij_col(:,i), Pij_col(:,j) )
                tag(j) = tag(i);
            end
        end
    end
    Pij_sort = sortrows([tag; Pij]');
    
    
    
    % Judge whether the submatrix composed of several columns with the same
    % elements divided by columns is a symmetric matrix.
    for i = 1:s
        Pij_check = Pij_sort(  Pij_sort(:,1) == i, 2:end  );
        [nonzero,~]=size(Pij_check);
        if nonzero ~= 0
            if Symtc_Chanl_mtx(Pij_check') ~= 1 % recursive call itself
                symtc = 0;
                break
            end
        end
    end
    
    if symtc == -1
        symtc = 2;
    end
    
end

end



%% 2.   Sub-function: symtc_Row.
function symtc_row = symtc_Row(mtx)
% SYMTC_ROW judge whether the matrix is row-symmetric.
%
%
%
% Notation explanation
%   Input:
%       mtx: r×s matrix;
%            NOTICE: r & s must be positive integers greater than 1 !
%
%   Outputs:
%       symtc_row: judge whether the matrix mtx is row-symmetric;
%                  ① if mtx is    row-symmetric, symtc_row = 1;
%                  ② if mtx isn't row-symmetric, symtc_row = 0;

%% 2.1.
[r, ~] = size(mtx);
symtc_row = -1;                            % symtc_row is initialized to -1
mtx_row = sort(mtx, 2);

%% 2.2.
% Determine whether it is symmetrical about the input or the row of input.
for i = 1 : floor(log2(r))
    if ~isequal(  mtx_row( 1:2^(i-1), : ), ...
            mtx_row( (2^(i-1)+1):2^i, : )  )
        symtc_row = 0;                     % Not symmetrical for input
        break
    end
end

if (symtc_row == -1) && isequal(mtx_row, flipud(mtx_row))
    symtc_row = 1;                         % Symmetrical for input
elseif symtc_row == -1
    symtc_row = 0;                         % Not symmetrical for input
end

end
