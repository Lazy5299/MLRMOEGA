function [finaldata]=MLRMOEGApathfinding(maprisk,mapdata,mapspeed,mapmatrix,mapG,start,goal,n,gatime,gasmooth,gacost,garisk,runtimes,initial_population_size,itertaion_limit)
% �����Ŵ��㷨��դ�񷨻�����·���滮
% ��������,��դ���ͼ
G=mapG;
M=mapmatrix;
MAPrisk=maprisk';
MAPdata=mapdata';
MAPspeed=mapspeed';


p_start = start; % ��ʼ���
p_end = goal;   % ��ֹ���
NP = initial_population_size;     % ��Ⱥ����
max_gen =itertaion_limit;  % ����������
pc = 0.95;      % �������
pm = 0.2;      % �������
%init_path = [];
z = 1;  
new_pop1 = {}; % Ԫ������·��
[y, x] = size(G);  % x��դ���ͼ�߳�
% ��������У������ұ��1.2.3...��
xs = mod(p_start, x) + 1; 
% ��������У����ϵ��±����1.2.3...��
ys = fix(p_start / x) + 1;
% �յ������С���
xe = mod(p_end, x) + 1;
ye = fix(p_end / x) + 1;





for runtime=1:runtimes   %GA���̶�ε��� 
timesfinalpath={};
timesfinaldata=[];
timesfinalvalue=[];
timesfinaldatabase=[];

% ��Ⱥ��ʼ��step1���ؾ��ڵ�,����ʼ�������п�ʼ���ϣ���ÿ������ѡһ������դ�񣬹��ɱؾ��ڵ�
if ye > ys %�ж�һ������յ�˭����˭���£�end����
    pass_num = ye - ys + 1;
    pop = zeros(NP, pass_num);
    for i = 1 : NP
     pop(i, 1) = p_start;
        j = 1;
        % ��ȥ�����յ�
        for yk = ys+1 : ye-1
            j = j + 1;
            % ÿһ�еĿ��е�
            can = []; 
            for xk = 1 : x
                % դ�����
                no = (xk - 1) + (yk - 1) * x;
                if G(yk, xk) == 0
                    % �ѵ����can������
                    can = [can no];
                end
            end
            can_num = length(can);
            % �����������
            index = randi(can_num);
            % Ϊÿһ�м�һ�����е�
            pop(i, j) = can(index);
        end
        pop(i, end) = p_end;
        %pop
        % ��Ⱥ��ʼ��step2�������ؾ��ڵ�������޼��·��
        single_new_pop = generate_continuous_path(pop(i, :), G, x);
        %init_path = [init_path, single_new_pop];
        if ~isempty(single_new_pop)
            new_pop1(z, 1) = {single_new_pop};
            z = z + 1;
        end
    end
else %end����
    pass_num = ys - ye + 1;
    pop = zeros(NP, pass_num);
    for i = 1 : NP
     pop(i, 1) = p_start;
        j = 1;
        % ��ȥ�����յ�
        for yk = ye+1 : ys-1
            j = j + 1;
            % ÿһ�еĿ��е�
            can = []; 
            for xk = 1 : x
                % դ�����
                no = (xk - 1) + (yk - 1) * x;
                if G(yk, xk) == 0
                    % �ѵ����can������
                    can = [can no];
                end
            end
            can_num = length(can);
            % �����������
            index = randi(can_num);
            % Ϊÿһ�м�һ�����е�
            pop(i, j) = can(index);
        end
        pop(i, end) = p_end;
        %pop
        % ��Ⱥ��ʼ��step2�������ؾ��ڵ�������޼��·��
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
 
              

% ѭ����������
for i = 1 : max_gen
    
    size(new_pop1)
    % ������Ӧ��ֵ
    % ����·������ʱ��
    [path_time,time] = cal_path_time(new_pop1, x, MAPspeed);
    % ����·��ƽ����
    [path_smooth,totalangle] = cal_path_smooth(new_pop1, x);
    %����·������
    [path_cost,cost] = cal_path_cost(new_pop1, x, MAPdata);
    %����·��ˤ����
    [path_risk,risk] = cal_path_risk(new_pop1, x, MAPrisk);
    %�ĸ��Ż�Ŀ����ɾ���
    database=[path_time;
              path_smooth;
              path_cost;
              path_risk]  %����������ݣ����ܾ�����һ���ȴ���
    
    realdatabase=[time;
                  totalangle;
                  cost;
                  risk]     %��ʵ����

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
    

    
    %��Ӣ���ԣ�1������Ŀǰ�����Ž� 
    [elite_pop,new_pop1,elite_fit_value,maxquantity] = elitist_strategy(new_pop1,fit_value);
    [elite_number,~]=size(elite_pop);
    
    

    %�����Ⱥ������,����չ�������
    [new_pop1] = Population_diversity(all_area,G,x,start,goal,new_pop1,initial_population_size,elite_number);
    % ·��ѡ�����
    [new_pop2] = selection(new_pop1, fit_value);
    % ·���������
    [new_pop2] = crossover(new_pop2, pc);
    % ·���������
    [new_pop2] = mutation(new_pop2, pm, G, x);


    

    % ��Ӣ���ԣ�2��������Ӧ��ֵ,������Ⱥ�е��������þ�Ӣ�����滻
    % ����·������ʱ��
    [path_time,time] = cal_path_time(new_pop2, x, MAPspeed);
    % ����·��ƽ����
    [path_smooth,totalangle] = cal_path_smooth(new_pop2, x);
    %����·������
    [path_cost,cost] = cal_path_cost(new_pop2, x, MAPdata);
    %����·��ˤ����
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
        %�ҵ���Ⱥ����Ӧ������,�����Ӧ��С�ھ�Ӣ������Ӧ�ȣ����滻��
        min_fit_value=min(fit_value);
        if min_fit_value <= elite_fit_value 
            min_index_list = find(fit_value==min_fit_value);
            minquantity=size(min_index_list);%���Ӹ������� 
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
%           minquantity=size(min_index_list);%���Ӹ�������          
%           if minquantity > maxquantity %������Ӹ�����ྫӢ����
%               for min_index=1:maxquantity%��ȫ����Ӣ��������
%                   new_pop2(min_index)=elite_pop(min_index);
%               end
%           elseif minquantity <= maxquantity%������Ӹ������ھ�Ӣ����
%               for min_index=1:minquantity%��ȫ�����Ӹ��嶼�滻Ϊ��Ӣ����
%                   new_pop2(min_index)=elite_pop(min_index);
%               end
%           end

    

    % ����·����Ⱥ
    new_pop1 = new_pop2;
    
    
    %�������һ��ʱ����������
    if i==max_gen
    % ����·������ʱ��
    [path_time,time] = cal_path_time(new_pop2, x, MAPspeed);
    % ����·��ƽ����
    [path_smooth,totalangle] = cal_path_smooth(new_pop2, x);
    %����·������
    [path_cost,cost] = cal_path_cost(new_pop2, x, MAPdata);
    %����·��ˤ����
    [path_risk,risk] = cal_path_risk(new_pop2, x, MAPrisk);
    %�ĸ��Ż�Ŀ����ɾ���
    database=[path_time;
              path_smooth;
              path_cost;
              path_risk]  %����������ݣ����ܾ�����һ���ȴ���
    
    realdatabase=[time;
                  totalangle;
                  cost;
                  risk]     %��ʵ����
    
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
% �ڵ�ͼ�ϻ�·��
figure(2)
hold on;
title('MLRMOEGA path'); 
xlabel('x-axis'); 
ylabel('y-axis');
DrawMap(M);
[~, min_path_num] = size(min_path);
min_path
for i = 1:min_path_num
    % ·���������У������ұ��1.2.3...��
    x_min_path(1, i) = mod(min_path(1, i), x) + 1; 
    % ·���������У����ϵ��±����1.2.3...��
    y_min_path(1, i) = fix(min_path(1, i) / x) + 1;
end
hold on;
plot(x_min_path,y_min_path,'linewidth',4,'Color','r')

end


