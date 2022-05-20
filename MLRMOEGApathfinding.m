function [finaldata]=MLRMOEGApathfinding(maprisk,mapdata,mapspeed,mapmatrix,mapG,start,goal,n,gatime,gasmooth,gacost,garisk,runtimes,initial_population_size,itertaion_limit)
% 基于遗传算法的栅格法机器人路径规划
% 输入数据,即栅格地图
G=mapG;
M=mapmatrix;
MAPrisk=maprisk';
MAPdata=mapdata';
MAPspeed=mapspeed';


p_start = start; % 起始序号
p_end = goal;   % 终止序号
NP = initial_population_size;     % 种群数量
max_gen =itertaion_limit;  % 最大进化代数
pc = 0.95;      % 交叉概率
pm = 0.2;      % 变异概率
%init_path = [];
z = 1;  
new_pop1 = {}; % 元包类型路径
[y, x] = size(G);  % x是栅格地图边长
% 起点所在列（从左到右编号1.2.3...）
xs = mod(p_start, x) + 1; 
% 起点所在行（从上到下编号行1.2.3...）
ys = fix(p_start / x) + 1;
% 终点所在列、行
xe = mod(p_end, x) + 1;
ye = fix(p_end / x) + 1;





for runtime=1:runtimes   %GA过程多次迭代 
timesfinalpath={};
timesfinaldata=[];
timesfinalvalue=[];
timesfinaldatabase=[];

% 种群初始化step1，必经节点,从起始点所在行开始往上，在每行中挑选一个自由栅格，构成必经节点
if ye > ys %判断一下起点终点谁在上谁在下，end在上
    pass_num = ye - ys + 1;
    pop = zeros(NP, pass_num);
    for i = 1 : NP
     pop(i, 1) = p_start;
        j = 1;
        % 除去起点和终点
        for yk = ys+1 : ye-1
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
        end
        pop(i, end) = p_end;
        %pop
        % 种群初始化step2将上述必经节点联结成无间断路径
        single_new_pop = generate_continuous_path(pop(i, :), G, x);
        %init_path = [init_path, single_new_pop];
        if ~isempty(single_new_pop)
            new_pop1(z, 1) = {single_new_pop};
            z = z + 1;
        end
    end
else %end在下
    pass_num = ys - ye + 1;
    pop = zeros(NP, pass_num);
    for i = 1 : NP
     pop(i, 1) = p_start;
        j = 1;
        % 除去起点和终点
        for yk = ye+1 : ys-1
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
        end
        pop(i, end) = p_end;
        %pop
        % 种群初始化step2将上述必经节点联结成无间断路径
        single_new_pop = generate_continuous_path(pop(i, :), G, x);
        %init_path = [init_path, single_new_pop];
        if ~isempty(single_new_pop)
            new_pop1(z, 1) = {single_new_pop};
            z = z + 1;
        end
    end
end


size(new_pop1)

 [all_area] = Map_analysis(M,x);
 
              

% 循环迭代操作
for i = 1 : max_gen
    
    size(new_pop1)
    % 计算适应度值
    % 计算路径消耗时间
    [path_time,time] = cal_path_time(new_pop1, x, MAPspeed);
    % 计算路径平滑度
    [path_smooth,totalangle] = cal_path_smooth(new_pop1, x);
    %计算路径功耗
    [path_cost,cost] = cal_path_cost(new_pop1, x, MAPdata);
    %计算路径摔倒率
    [path_risk,risk] = cal_path_risk(new_pop1, x, MAPrisk);
    %四个优化目标组成矩阵
    database=[path_time;
              path_smooth;
              path_cost;
              path_risk]  %计算过程数据，可能经过归一化等处理
    
    realdatabase=[time;
                  totalangle;
                  cost;
                  risk]     %真实数据

    i
    
    
    if gatime==1 
        fit_value =time .^ -1 ;
    elseif gasmooth==1 
        fit_value =totalangle .^ -1 ;
    elseif gacost==1 
        fit_value =cost .^ -1 ;
    elseif garisk==1
        fit_value = risk .^ -1 ;
    else
        fit_value = gatime * path_time .^ -1  + gasmooth * path_smooth .^ -1  + gacost * path_cost .^ -1  + garisk * path_risk .^ -1 ;
    end
     
    
    fit_value
    
    if gatime==1
        real_fit_value =time ;
    elseif gasmooth==1
        real_fit_value =totalangle  ;
    elseif gacost==1
        real_fit_value =cost  ;
    elseif garisk==1
        real_fit_value = risk  ;
    else
        real_fit_value = gatime * time   + gasmooth * totalangle    + gacost * cost   + garisk * risk  ;
    end

    real_fit_value
    
%     mean_path_time(1, i) = mean(path_time);
%     [~, m] = max(fit_value);
%     min_path_time(1, i) = path_time(1, m);
    

    
    %精英策略（1）挑出目前的最优解 
    [elite_pop,new_pop1,elite_fit_value,maxquantity] = elitist_strategy(new_pop1,fit_value);
    [elite_number,~]=size(elite_pop);
    
    

    %检查种群多样性,并扩展其多样性
    [new_pop1] = Population_diversity(all_area,G,x,start,goal,new_pop1,initial_population_size,elite_number);
    % 路径选择操作
    [new_pop2] = selection(new_pop1, fit_value);
    % 路径交叉操作
    [new_pop2] = crossover(new_pop2, pc);
    % 路径变异操作
    [new_pop2] = mutation(new_pop2, pm, G, x);


    

    % 精英策略（2）计算适应度值,将新种群中的最差个体用精英个体替换
    % 计算路径消耗时间
    [path_time,time] = cal_path_time(new_pop2, x, MAPspeed);
    % 计算路径平滑度
    [path_smooth,totalangle] = cal_path_smooth(new_pop2, x);
    %计算路径功耗
    [path_cost,cost] = cal_path_cost(new_pop2, x, MAPdata);
    %计算路径摔倒率
    [path_risk,risk] = cal_path_risk(new_pop2, x, MAPrisk);
    
    if gatime==1 
        fit_value =time .^ -1 ;
    elseif gasmooth==1 
        fit_value =totalangle .^ -1 ;
    elseif gacost==1 
        fit_value =cost .^ -1 ;
    elseif garisk==1
        fit_value = risk .^ -1 ;
    else
        fit_value = gatime * path_time.^ -1   + gasmooth * path_smooth .^ -1   + gacost * path_cost.^ -1   + garisk * path_risk .^ -1 ;
    end
    
    if maxquantity>0
        %找到种群中适应度最差的,如果适应度小于精英个体适应度，就替换掉
        min_fit_value=min(fit_value);
        if min_fit_value <= elite_fit_value 
            min_index_list = find(fit_value==min_fit_value);
            minquantity=size(min_index_list);%最劣个体数量 
            if minquantity>1
                rand_min_index=randperm(minquantity,1);
            else
                rand_min_index=1;
            end
            del_min_index=min_index_list(rand_min_index);
            if maxquantity>1
                rand_max_index=randperm(maxquantity,1);
            else
                rand_max_index=1;
            end
            new_pop2(del_min_index)=elite_pop(rand_max_index);
        end
    end
%           minquantity=size(min_index_list);%最劣个体数量          
%           if minquantity > maxquantity %如果最劣个体多余精英个体
%               for min_index=1:maxquantity%把全部精英个体引入
%                   new_pop2(min_index)=elite_pop(min_index);
%               end
%           elseif minquantity <= maxquantity%如果最劣个体少于精英个体
%               for min_index=1:minquantity%把全部最劣个体都替换为精英个体
%                   new_pop2(min_index)=elite_pop(min_index);
%               end
%           end

    

    % 更新路径种群
    new_pop1 = new_pop2;
    
    
    %到达最后一代时，计算数据
    if i==max_gen
    % 计算路径消耗时间
    [path_time,time] = cal_path_time(new_pop2, x, MAPspeed);
    % 计算路径平滑度
    [path_smooth,totalangle] = cal_path_smooth(new_pop2, x);
    %计算路径功耗
    [path_cost,cost] = cal_path_cost(new_pop2, x, MAPdata);
    %计算路径摔倒率
    [path_risk,risk] = cal_path_risk(new_pop2, x, MAPrisk);
    %四个优化目标组成矩阵
    database=[path_time;
              path_smooth;
              path_cost;
              path_risk]  %计算过程数据，可能经过归一化等处理
    
    realdatabase=[time;
                  totalangle;
                  cost;
                  risk]     %真实数据
    
    if gatime==1
        fit_value =time .^ -1 ;
    elseif gasmooth==1
        fit_value =totalangle .^ -1 ;
    elseif gacost==1
        fit_value =cost .^ -1 ;
    elseif garisk==1
        fit_value = risk .^ -1 ;
    else
        fit_value = gatime * path_time.^ -1   + gasmooth * path_smooth .^ -1   + gacost * path_cost.^ -1   + garisk * path_risk .^ -1 ;
    end
    end

    if gatime==1
        real_fit_value =time  ;
    elseif gasmooth==1
        real_fit_value =totalangle  ;
    elseif gacost==1
        real_fit_value =cost ;
    elseif garisk==1
        real_fit_value = risk  ;
    else
        real_fit_value = gatime * time  + gasmooth * totalangle   + gacost * cost  + garisk * risk ;
    end
end
[~, min_index] = max(fit_value);
min_path = new_pop1{min_index, 1};
database(:,min_index)
realdatabase(:,min_index)
finaldata=realdatabase(:,min_index);

timesfinaldatabase(:,runtime)=database(:,min_index);
timesfianlrealdatabase(:,runtime)=realdatabase(:,min_index);
timesfinalpath{runtime,1}=min_path;
timesfinaldata(:,runtime)=finaldata;
timesfinalvalue(:,runtime)=max(fit_value);
timesfinalrealvalue(:,runtime)=min(real_fit_value);
execution_time(runtime,:)=toc;
end


[~, min_index] = max(timesfinalvalue);
min_path = timesfinalpath{min_index, 1};
realfinaldata=timesfinaldata(:,min_index);
    if gatime==1
        real_final_fit_value =realfinaldata(1)  ;
    elseif gasmooth==1
        real_final_fit_value =realfinaldata(2) ;
    elseif gacost==1
        real_final_fit_value =realfinaldata(3)  ;
    elseif garisk==1
        real_final_fit_value = realfinaldata(4) ;
    else
        real_final_fit_value = gatime * realfinaldata(1)  + gasmooth * realfinaldata(2)   + gacost * realfinaldata(3)  + garisk * realfinaldata(4)  ;
    end
real_final_fit_value
timesfinaldatabase(:,min_index)
timesfianlrealdatabase(:,min_index)
% 在地图上画路径
figure(2)
hold on;
title('MLRMOEGA path'); 
xlabel('x-axis'); 
ylabel('y-axis');
DrawMap(M);
[~, min_path_num] = size(min_path);
min_path
for i = 1:min_path_num
    % 路径点所在列（从左到右编号1.2.3...）
    x_min_path(1, i) = mod(min_path(1, i), x) + 1; 
    % 路径点所在行（从上到下编号行1.2.3...）
    y_min_path(1, i) = fix(min_path(1, i) / x) + 1;
end
hold on;
plot(x_min_path,y_min_path,'linewidth',4,'Color','r')

end


