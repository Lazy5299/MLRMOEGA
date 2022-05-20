% 将必经节点联结成无间断路径
function [single_new_pop] = generate_continuous_path(single_pop, G, x)
i = 1;
single_new_pop = single_pop;  %pop中栅格信息是索引值
[~, single_path_num] = size(single_new_pop); %当前路线走过的格数
while i ~= single_path_num
    % 点i所在列（从左到右编号1.2.3...）
    x_now = mod(single_new_pop(1, i), x) + 1; 
    % 点i所在行（从上到下编号行1.2.3...）
    y_now = fix(single_new_pop(1, i) / x) + 1;
    % 点i+1所在列、行
    x_next = mod(single_new_pop(1, i + 1), x) + 1;
    y_next = fix(single_new_pop(1, i + 1) / x) + 1;
    
    % 初始化最大迭代次数
    max_iteration = 0;
    
    % 判断点i和i+1是否连续,若不连续插入值
    while max(abs(x_next - x_now), abs(y_next - y_now)) > 1    
        x_insert = floor((x_next + x_now) / 2);     %两个不连续点中间的点x坐标
        y_insert = floor((y_next + y_now) / 2);     %两个不连续点中间的点y坐标
        
        % 插入栅格为自由栅格
        if G(y_insert, x_insert) == 0  
            % 栅格序号
            num_insert = (x_insert - 1) + (y_insert - 1) * x;
            % 插入新序号
            single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
            
        % 插入栅格为障碍物栅格
        else
            % 往右走    
            if   x_insert + 1<x  &&  G(y_insert, x_insert + 1) == 0 && (x_insert + (y_insert - 1) * x ~= single_new_pop(1, i)) && (x_insert + (y_insert - 1) * x ~= single_new_pop(1, i+1)) 
                x_insert = x_insert + 1;
                % 栅格序号
                num_insert = (x_insert - 1) + (y_insert - 1) * x;
                % 插入新序号
                single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
            % 向上走
            elseif   y_insert + 1 <x   &&  G(y_insert + 1, x_insert) == 0 && ((x_insert - 1) + y_insert * x ~= single_new_pop(1, i)) && ((x_insert - 1) + y_insert * x ~= single_new_pop(1, i+1)) 
                y_insert = y_insert + 1;
                % 栅格序号
                num_insert = (x_insert - 1) + (y_insert - 1) * x;
                % 插入新序号
                single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
         
            % 向下走
            elseif  y_insert - 1 >0  &&  G(y_insert - 1, x_insert) == 0 && ((x_insert - 1) + (y_insert - 2) * x ~= single_new_pop(1, i)) && ((x_insert - 1) + (y_insert-2) * x ~= single_new_pop(1, i+1))  
                y_insert = y_insert - 1;
                % 栅格序号
                num_insert = (x_insert - 1) + (y_insert - 1) * x;
                % 插入新序号
                single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
            % 往左走
            elseif  x_insert - 1 >0  &&  G(y_insert, x_insert - 1) == 0 && ((x_insert - 2) + (y_insert - 1) * x ~= single_new_pop(1, i)) && ((x_insert - 2) + (y_insert - 1) * x ~= single_new_pop(1, i+1)) 
                x_insert = x_insert - 1 ;
                % 栅格序号
                num_insert = (x_insert - 1) + (y_insert - 1) * x;
                % 插入新序号
                single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];

            


%             % 往左走
%             if  x_insert - 1 >0  &&  G(y_insert, x_insert - 1) == 0 && ((x_insert - 2) + (y_insert - 1) * x ~= single_new_pop(1, i)) && ((x_insert - 2) + (y_insert - 1) * x ~= single_new_pop(1, i+1)) && ((x_insert - 2) + (y_insert-1) * x > 0)&& ((x_insert - 2) + (y_insert-1)* x < x*x-1)
%                 x_insert = x_insert - 1 ;
%                 % 栅格序号
%                 num_insert = (x_insert - 1) + (y_insert - 1) * x;
%                 % 插入新序号
%                 single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
%                                
%             % 往右走    
%             elseif   x_insert + 1<x  &&  G(y_insert, x_insert + 1) == 0 && (x_insert + (y_insert - 1) * x ~= single_new_pop(1, i)) && (x_insert + (y_insert - 1) * x ~= single_new_pop(1, i+1)) && ( x_insert + (y_insert-1) * x > 0)&& ( x_insert + (y_insert-1) * x < x*x-1)
%                 x_insert = x_insert + 1;
%                 % 栅格序号
%                 num_insert = (x_insert - 1) + (y_insert - 1) * x;
%                 % 插入新序号
%                 single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
%                 
%             % 向上走
%             elseif   y_insert + 1 <x   &&  G(y_insert + 1, x_insert) == 0 && ((x_insert - 1) + y_insert * x ~= single_new_pop(1, i)) && ((x_insert - 1) + y_insert * x ~= single_new_pop(1, i+1)) && (x_insert +( y_insert + 1) * x > 0)&& ( (x_insert-1) + y_insert * x < x*x-1)
%                 y_insert = y_insert + 1;
%                 % 栅格序号
%                 num_insert = (x_insert - 1) + (y_insert - 1) * x;
%                 % 插入新序号
%                 single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
% 
%             % 向下走
%             elseif  y_insert - 1 >0  &&  G(y_insert - 1, x_insert) == 0 && ((x_insert - 1) + (y_insert - 2) * x ~= single_new_pop(1, i)) && ((x_insert - 1) + (y_insert-2) * x ~= single_new_pop(1, i+1))  && ( (x_insert-1) +( y_insert - 2) * x > 0)&& ( (x_insert-1) +( y_insert - 2) * x < x*x-1)
%                 y_insert = y_insert - 1;
%                 % 栅格序号
%                 num_insert = (x_insert - 1) + (y_insert - 1) * x;
%                 % 插入新序号
%                 single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];

                
            % 其他情况舍去此路径
            else
                %break_pop = single_new_pop
                single_new_pop = [];
                break
            end    
        end
        
        x_next = x_insert;
        y_next = y_insert;
        max_iteration = max_iteration + 1;
        if max_iteration > x*2            %插入空格太多，说明前面两个格取得太远，舍弃这条路
            single_new_pop = [];
            break
        end
        
    end
    
    if isempty(single_new_pop)
        break
    end
    
    [~, single_path_num] = size(single_new_pop);
    i = i + 1;
end