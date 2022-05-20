function [all_area] = Map_analysis(M,x)

M=M';

slop_index=find(M==3);
swing_index=find(M==5);
ladder_index=find(M==6);
smallwall_index=find(M==7);
middlewall_index=find(M==8);
stream_index=find(M==9);

%准备区域检查地图
slopmap=M;
swingmap=M;
laddermap=M;
middlewallmap=M;
smallwallmap=M;
streammap=M;


%地图全部索引
indexlimit=x*x-1;
indexlist=[];
indexlistno=1;
for indexlistindex=1:x*x
    indexlist(indexlistindex)=indexlistno;
    indexlistno=indexlistno+1;
end
indexlist=indexlist';

%将斜坡分区
no_slop_girds_index=setdiff(indexlist,slop_index);
slopmap(no_slop_girds_index)=0;
slopmap(slop_index)=1;
slop_area_map=bwlabel(slopmap,8);%二维二值图像8联通分量标注
[number_of_slop_area,~]=size(unique(slop_area_map)); 
number_of_slop_area=number_of_slop_area-1;
slop_area={};
for area_no=1:number_of_slop_area
    slop_area_index=find(slop_area_map==area_no);
    slop_area{area_no}=slop_area_index;
end                                         %将斜坡分块信息放入元胞数组
slop_area(cellfun('isempty',slop_area)) = []; %去除空项
slop_area


%将云梯分区
no_swing_girds_index=setdiff(indexlist,swing_index);
swingmap(no_swing_girds_index)=0;
swingmap(swing_index)=1;
swing_area_map=bwlabel(swingmap,8);%二维二值图像8联通分量标注
[number_of_swing_area,~]=size(unique(swing_area_map));
number_of_swing_area=number_of_swing_area-1;
swing_area={};
for area_no=1:number_of_swing_area
    swing_area_index=find(swing_area_map==area_no);
    swing_area{area_no}=swing_area_index;
end                                         %将云梯分块信息放入元胞数组
swing_area(cellfun('isempty',swing_area)) = [];
swing_area


%将竖梯分区
no_ladder_girds_index=setdiff(indexlist,ladder_index);
laddermap(no_ladder_girds_index)=0;
laddermap(ladder_index)=1;
ladder_area_map=bwlabel(laddermap,8);%二维二值图像8联通分量标注
[number_of_ladder_area,~]=size(unique(ladder_area_map)); %区域总数量
number_of_ladder_area=number_of_ladder_area-1;
ladder_area={};
for area_no=1:number_of_ladder_area
    ladder_area_index=find(ladder_area_map==area_no);
    ladder_area{area_no}=ladder_area_index;
end                                         %将竖梯分块信息放入元胞数组
ladder_area(cellfun('isempty',ladder_area)) = [];
ladder_area

%将矮墙分区
no_smallwall_girds_index=setdiff(indexlist,smallwall_index);
smallwallmap(no_smallwall_girds_index)=0;
smallwallmap(smallwall_index)=1;
smallwall_area_map=bwlabel(smallwallmap,8);%二维二值图像8联通分量标注
[number_of_smallwall_area,~]=size(unique(smallwall_area_map)); 
number_of_smallwall_area=number_of_smallwall_area-1;
smallwall_area={};
for area_no=1:number_of_smallwall_area
    smallwall_area_index=find(smallwall_area_map==area_no);
    smallwall_area{area_no}=smallwall_area_index;
end                                         %将矮墙分块信息放入元胞数组
smallwall_area(cellfun('isempty',smallwall_area)) = [];
smallwall_area

%将中墙分区
no_middlewall_girds_index=setdiff(indexlist,middlewall_index);
middlewallmap(no_middlewall_girds_index)=0;
middlewallmap(middlewall_index)=1;
middlewall_area_map=bwlabel(middlewallmap,8);%二维二值图像8联通分量标注
[number_of_middlewall_area,~]=size(unique(middlewall_area_map)); 
number_of_middlewall_area=number_of_middlewall_area-1;
middlewall_area={};
for area_no=1:number_of_middlewall_area
    middlewall_area_index=find(middlewall_area_map==area_no);
    middlewall_area{area_no}=middlewall_area_index;
end                                         %将中墙分块信息放入元胞数组
middlewall_area(cellfun('isempty',middlewall_area)) = [];
middlewall_area

%将小溪分区
no_stream_girds_index=setdiff(indexlist,stream_index);
streammap(no_stream_girds_index)=0;
streammap(stream_index)=1;
stream_area_map=bwlabel(streammap,8);%二维二值图像8联通分量标注
[number_of_stream_area,~]=size(unique(stream_area_map)); 
number_of_stream_area=number_of_stream_area-1;
stream_area={};
for area_no=1:number_of_stream_area
    stream_area_index=find(stream_area_map==area_no);
    stream_area{area_no}=stream_area_index;
end                                         %将小溪分块信息放入元胞数组
stream_area(cellfun('isempty',stream_area)) = [];
stream_area


%全部障碍物分区合并成一个元胞数组
all_area_number=number_of_slop_area+number_of_swing_area+number_of_ladder_area+number_of_smallwall_area+number_of_middlewall_area+number_of_stream_area;
all_area=cell(all_area_number,1);
NO_all_area=1;
for NO_slop=1:number_of_slop_area
    all_area{NO_all_area}=slop_area{NO_slop};
    NO_all_area=NO_all_area+1;
end
for NO_swing=1:number_of_swing_area
    all_area{NO_all_area}=swing_area{NO_swing};
    NO_all_area=NO_all_area+1;
end
for NO_ladder=1:number_of_ladder_area
    all_area{NO_all_area}=ladder_area{NO_ladder};
    NO_all_area=NO_all_area+1;
end
for NO_smallwall=1:number_of_smallwall_area
    all_area{NO_all_area}=smallwall_area{NO_smallwall};
    NO_all_area=NO_all_area+1;
end
for NO_middlewall=1:number_of_middlewall_area
    all_area{NO_all_area}=middlewall_area{NO_middlewall};
    NO_all_area=NO_all_area+1;
end
for NO_stream=1:number_of_stream_area
    all_area{NO_all_area}=stream_area{NO_stream};
    NO_all_area=NO_all_area+1;
end

