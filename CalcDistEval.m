%% 障碍物距离评价函数  （机器人在当前轨迹上与最近的障碍物之间的距离，如果没有障碍物则设定一个常数）
% 输入参数：位姿、所有障碍物位置、障碍物半径
% 输出参数：当前预测的轨迹终点的位姿距离所有障碍物中最近的障碍物的距离 如果大于设定的最大值则等于最大值
% 距离障碍物距离越近分数越低
function [dist,Flag] = CalcDistEval(x,ob,R)
dist=100;
for io = 1:length(ob(:,1))  
    disttmp = norm(ob(io,:)-x(1:2)')-R; %到第io个障碍物的距离 - 障碍物半径  ！！！有可能出现负值吗
    if disttmp <0
        Flag = 1;
        break;
    else
        Flag = 0;
    end
    
    if dist > disttmp   % 大于最小值 则选择最小值
        dist = disttmp;
    end
end
 
% 障碍物距离评价限定一个最大值，如果不设定，一旦一条轨迹没有障碍物，将太占比重
if dist >= 3*R %最大分数限制
    dist = 3*R;
end

