%% heading�����ۺ�������
% �����������ǰλ�á�Ŀ��λ��
% �����������������÷�  ��ǰ���ĺ���������Ŀ���ĺ��� ƫ��̶�ԽС ����Խ�� ���180��
function heading = CalcHeadingEval(x,goal)
theta = toDegree(x(3));% �����˳���
goalTheta = toDegree(atan2(goal(2)-x(2),goal(1)-x(1)));% Ŀ�������ڻ����˱���ķ�λ 
if goalTheta > theta
    targetTheta = goalTheta-theta;% [deg]
else
    targetTheta = theta-goalTheta;% [deg]
end
 
heading = 180 - targetTheta;  
