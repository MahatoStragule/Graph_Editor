function replaceArrow(handles,number,tmpvalue,value)
changeSize = tmpvalue-value;
EdgeMat = handles.EdgeMat(:,number);
ind = find(EdgeMat~=0);
for i = ind'
    line = EdgeMat(i);
    xdata = get(line,'XData');
    ydata = get(line,'YData');
    s_rec_pos = get(handles.RecMat(number),'Position');
    s_rec_center = [s_rec_pos(1) + s_rec_pos(3)/2; s_rec_pos(2) + s_rec_pos(4)/2];
    s_delta = [xdata(1); ydata(1)] -s_rec_center;
    s_delta = s_delta*changeSize/tmpvalue;
    xdata(1) = xdata(1)-s_delta(1);
    ydata(1) = ydata(1)-s_delta(2);
    set(line,'XData',xdata,'YData',ydata);
end
clear EdgeMat ind i;
EdgeMat = handles.EdgeMat(number,:);
Arrow1Mat = handles.Arrow1Mat(number,:);
Arrow2Mat = handles.Arrow2Mat(number,:);
ind = find(EdgeMat~=0);
for i = ind
    line = EdgeMat(i);
    arrow1 = Arrow1Mat(i);
    arrow2 = Arrow2Mat(i);
    xdata = get(line,'XData');
    ydata = get(line,'YData');
    distance_x = xdata(2)-xdata(1);
    distance_y = ydata(2)-ydata(1);
    change_x = distance_x*changeSize/sqrt(distance_x^2+distance_y^2);
    change_y = distance_y*changeSize/sqrt(distance_x^2+distance_y^2);
    xdata(2) = xdata(2)+change_x;
    ydata(2) = ydata(2)+change_y;
    set(line,'XData',xdata,'YData',ydata);
    xdata = get(arrow1,'XData');
    ydata = get(arrow1,'YData');
    set(arrow1,'XData',xdata+change_x,'YData',ydata+change_y);
    xdata = get(arrow2,'XData');
    ydata = get(arrow2,'YData');
    set(arrow2,'XData',xdata+change_x,'YData',ydata+change_y);
end
setappdata(handles.fig,'handles',handles);