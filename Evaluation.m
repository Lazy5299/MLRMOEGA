%% ���ۺ��� �ڲ�����������ù켣
% ������� ����ǰ״̬������������Χ�����ڣ���Ŀ��㡢�ϰ���λ�á��ϰ���뾶�����ۺ����Ĳ���
% ���ز�����
%           evalDB N*5  ÿ��һ����ò��� �ֱ�Ϊ �ٶȡ����ٶȡ�����÷֡�����÷֡��ٶȵ÷�
%           trajDB      ÿ5��һ���켣 ÿ���켣���� ǰ��Ԥ��ʱ��/dt + 1 = 31 ���켣�㣨�����ɹ켣������
function [evalDB,trajDB] = Evaluation(x,Vr,goal,ob,R,model,evalParam,goal_num,in_point_num)
evalDB = [];
trajDB = [];
for vt = Vr(1):model(5):Vr(2)       %�����ٶȷֱ��ʱ������п����ٶȣ� ��С�ٶȺ�����ٶ� ֮�� �ٶȷֱ��� ���� 
    for ot=Vr(3):model(6):Vr(4)     %���ݽǶȷֱ��ʱ������п��ý��ٶȣ� ��С���ٶȺ������ٶ� ֮�� �Ƕȷֱ��� ����  
        % �켣�Ʋ�; �õ� xt: ��������ǰ�˶����Ԥ��λ��; traj: ��ǰʱ�� �� Ԥ��ʱ��֮��Ĺ켣���ɹ켣����ɣ�
        [xt,traj] = GenerateTrajectory(x,vt,ot,evalParam(4));  %evalParam(4),ǰ��ģ��ʱ��;
        % �����ۺ����ļ���
        heading = CalcHeadingEval(xt,goal); % ǰ��Ԥ���յ�ĺ���÷�  ƫ��ԽС����Խ��
        [dist,Flag] = CalcDistEval(xt,ob,R);    % ǰ��Ԥ���յ� ��������ϰ���ļ�϶�÷� ����ԽԶ����Խ��
        vel     = abs(vt);                  % �ٶȵ÷� �ٶ�Խ���Խ��
        stopDist = CalcBreakingDist(vel,model,goal_num,in_point_num); % �ƶ�����ļ���
        if dist > stopDist && Flag == 0 % �������ײ��������ϰ��� ��������·�� ��������ϰ���ľ��� ���� ɲ������ ��ȡ�ã�
            evalDB = [evalDB;[vt ot heading dist vel]];
            trajDB = [trajDB;traj];   % ÿ5�� һ���켣  
        end
    end
end