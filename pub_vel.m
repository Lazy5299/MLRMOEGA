function pub_vel(vel_x,vel_z)
%Setting ROS_MASTER_URI
setenv('ROS_MASTER_URI','http://172.26.153.12:11311')
%Creating ROS publisher handle
cmdpub=rospublisher('/turtle1/cmd_vel', 'geometry_msgs/Twist');
%This is to create the message definition
cmdmsg=rosmessage(cmdpub);
%Inserting data to message
cmdmsg.Angular.Z=vel_z;
cmdmsg.Linear.X=vel_x;
%Sending message to topic
send(cmdpub,cmdmsg);
%Latching the message on topic
latchcmdpub = rospublisher('/turtle1/cmd_vel', 'IsLatching', true);
end

