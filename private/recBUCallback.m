function recBUCallback(fig,~,number)
%finish moving node and move edge position 
handles = getappdata(fig,'handles');

EdgeMat = handles.EdgeMat(:,number);
ind = find(EdgeMat~=0); %find edge which start moved node
for i = ind'
    [line_data, arrow1_data, arrow2_data, weight_data] = arrow_position(handles,number,i,'Normal');
    line = handles.EdgeMat(i,number);
    arrow1 = handles.Arrow1Mat(i,number);
    arrow2 = handles.Arrow2Mat(i,number);
    weight = handles.WeightMat(i,number);
    set(line,'XData',line_data(1,:),'YData',line_data(2,:));
    set(arrow1,'XData',arrow1_data(1,:),'YData',arrow1_data(2,:));
    set(arrow2,'XData',arrow2_data(1,:),'YData',arrow2_data(2,:));
    set(weight,'Position',weight_data);
    if handles.EdgeMat(number,i) ~= 0
        [line_data, arrow1_data, arrow2_data, weight_data] = arrow_position(handles,number,i,'Displace');
        set(line,'XData',line_data(1,:),'YData',line_data(2,:));
        set(arrow1,'XData',arrow1_data(1,:),'YData',arrow1_data(2,:));
        set(arrow2,'XData',arrow2_data(1,:),'YData',arrow2_data(2,:));
        set(weight,'Position',weight_data);
    end
end
clear EdgeMat ind i;
EdgeMat = handles.EdgeMat(number,:);
ind = find(EdgeMat~=0); %find edge which end moved node
for i = ind
    [line_data, arrow1_data, arrow2_data, weight_data] = arrow_position(handles,i,number,'Normal');
    line = handles.EdgeMat(number,i);
    arrow1 = handles.Arrow1Mat(number,i);
    arrow2 = handles.Arrow2Mat(number,i);
    weight = handles.WeightMat(number,i);
    set(line,'XData',line_data(1,:),'YData',line_data(2,:));
    set(arrow1,'XData',arrow1_data(1,:),'YData',arrow1_data(2,:));
    set(arrow2,'XData',arrow2_data(1,:),'YData',arrow2_data(2,:));
    set(weight,'Position',weight_data);
    if handles.EdgeMat(i,number) ~= 0
        [line_data, arrow1_data, arrow2_data, weight_data] = arrow_position(handles,i,number,'Displace');
        set(line,'XData',line_data(1,:),'YData',line_data(2,:));
        set(arrow1,'XData',arrow1_data(1,:),'YData',arrow1_data(2,:));
        set(arrow2,'XData',arrow2_data(1,:),'YData',arrow2_data(2,:));
        set(weight,'Position',weight_data);
    end
end
setappdata(handles.fig,'handles',handles);

fig.WindowButtonMotionFcn = '';
fig.WindowButtonUpFcn = '';
setappdata(fig,'handles',handles);
drawnow;