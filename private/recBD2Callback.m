function recBD2Callback(fig,~,number)
handles = getappdata(fig,'handles');
rec = handles.RecMat(number);
r_size = handles.NodeSize(number);
cp = handles.axes.CurrentPoint;
set(rec,'Position',[cp(1,1)-r_size/20  cp(1,2)-r_size/20 r_size/10 r_size/10]);
drawnow;
fig.WindowButtonMotionFcn = {@recBMCallback,number};
fig.WindowButtonUpFcn = {@recBUCallback,number};
setappdata(fig,'handles',handles);
