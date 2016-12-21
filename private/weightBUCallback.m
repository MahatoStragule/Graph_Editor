function weightBUCallback(fig,~,textobj)
handles = getappdata(fig,'handles');
fig.WindowButtonMotionFcn = '';
fig.WindowButtonUpFcn = '';
setappdata(fig,'handles',handles);
drawnow;