function [new_pop1] = Population_diversity(all_area,G,x,start,goal,new_pop1,initial_population_size,elite_number)
p_start = start; % 起始序号
p_end = goal;   % 终止序号
% 起点所在列（从左到右编号1.2.3...）
xs = mod(p_start, x) + 1; 
% 起点所在行（从上到下编号行1.2.3...）
ys = fix(p_start / x) + 1;
% 终点所在列、行
xe = mod(p_end, x) + 1;
ye = fix(p_end / x) + 1;

[px, ~] = size(new_pop1);%传入的种群数量
[all_area_number,~]=size(all_area);%不同障碍物区域数量


%检查种群多样性
[number_of_path,~]=size(new_pop1);
check_all_area=all_area;
for path_index=1:number_of_path   %取出每个路径个体
    sample_path=new_pop1{path_index};
    for area_index=1:all_area_number  %取出每个区域
        sample_area=check_all_area{area_index};
        sample_area=sample_area-1;%对齐索引
        R = intersect(sample_path,sample_area); %求交集，看路径是否经过这片区域
        if isempty(R)~=1    %如果有交集，说明经过了，删掉这片区域
            check_all_area{area_index}=[];
        end
    end
end
check_all_area(cellfun('isempty',check_all_area))=[];
% check_all_area



%生成个体
while isempty(check_all_area)~=1  %如果剩余区域不是空的，说明种群在地图中有区域没有经过
    [not_pass_area_number,~]=size(check_all_area);
%     pass_area_number=all_area_number-not_pass_area_number;
%     lack_number_of_individual=elite_number;
%     pass_area_number=all_area_number-not_pass_area_number;
%     each_area_generate_number=px/pass_area_number;
% (initial_population_size-px)/not_pass_area_number
    each_area_generate_number=floor((initial_population_size-px)/not_pass_area_number);
    single_new_individual=[];
    for area_cycle=1:not_pass_area_number
        this_area=check_all_area{area_cycle};
        this_area=this_area-1; %对齐索引
        for new_path_individual_number=1:each_area_generate_number
        [grids_number_of_this_area,~]=size(this_area);
        random_index_list=randperm(grids_number_of_this_area);
        random_index=random_index_list(1);
        random_position=this_area(random_index);%随机取出未经过区域中的一个坐标

        
        %生成新个体
        number_of_insert_individual=1;
        yinsert=fix(random_position / x) + 1;
        pass_num = ye - ys + 1;
        pop = zeros(number_of_insert_individual, pass_num);
        for i = 1 : number_of_insert_individual
            pop(i, 1) = p_start;
            pop(i, yinsert) = random_position;
            j = 1;
            % 除去起点和终点
            for yk = ys+1 : ye-1
                if yk~=yinsert
                    j = j + 1;
                    % 每一行的可行点
                    can = []; 
                    for xk = 1 : x
                        % 栅格序号
                        no = (xk - 1) + (yk - 1) * x;
                        if G(yk, xk) == 0
                            % 把点加入can矩阵中
                            can = [can no];
                        end
                    end
                    can_num = length(can);
                    % 产生随机整数
                    index = randi(can_num);
                    % 为每一行加一个可行点
                    pop(i, j) = can(index);
                else
                    continue
                end
            end
            pop(i, end) = p_end;
            %pop
            % 种群初始化step2将上述必经节点联结成无间断路径
            single_new_individual = generate_continuous_path(pop(i, :), G, x);
            %init_path = [init_path, single_new_pop];
            if ~isempty(single_new_individual)
                new_pop1{px+1} = {single_new_individual};
                px=px+1;
            end
        end
        end
        
        
%         single_new_individual=[start random_position goal];
%         single_new_individual = generate_continuous_path(single_new_individual, G, x);%生成连续路径
%         new_pop1{px+1}=single_new_individual;
%         px=px+1;
       check_all_area{area_cycle}=[];
    end
    check_all_area(cellfun('isempty',check_all_area))=[];
end
