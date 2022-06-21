%% 绘制所有障碍物位置
% 输入参数：obstacle 所有障碍物的坐标   obstacleR 障碍物的半径
function [] = DrawObstacle_plot(obstacle,obstacleR)
r = obstacleR; 
theta = 0:pi/20:2*pi;
for id=1:length(obstacle(:,1))
%     x1=obstacle(id,1)-0.5;
%     x2=obstacle(id,1)+0.5;
%     x3=obstacle(id,1)+0.5;
%     x4=obstacle(id,1)-0.5;
%     y1=obstacle(id,2)+0.5;
%     y2=obstacle(id,2)+0.5;
%     y3=obstacle(id,2)-0.5;
%     y4=obstacle(id,2)-0.5;
%     plot([x1,y1],[x2,y2],'Color','k');
%     hold on;
%     plot([x2,y2],[x3,y3],'Color','k');
%     hold on;
%     plot([x3,y3],[x4,y4],'Color','k');
%     hold on;
%     plot([x1,y1],[x4,y4],'Color','k');
%     hold on;
     x = r * cos(theta) + obstacle(id,1);
     y = r  *sin(theta) + obstacle(id,2);
     plot(x,y,'-k');
end
 %plot(obstacle(:,1),obstacle(:,2),'*m');hold on;              % 绘制所有障碍物位置