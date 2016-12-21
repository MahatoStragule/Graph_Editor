function recBMCallback(fig,~,number,vec)
%move node and node name
handles = getappdata(fig,'handles');
rec = handles.RecMat(number);
name = handles.NodeNumberText(number);
r_size = handles.NodeSize(number);
cp = handles.axes.CurrentPoint;
set(rec,'Position',[cp(1,1)-r_size/20  cp(1,2)-r_size/20 r_size/10 r_size/10]);
set(name,'Position',[cp(1,1)+vec(1) cp(1,2)+vec(2) 0]);
setappdata(fig,'handles',handles);
drawnow;