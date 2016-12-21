function weightBMCallback(fig,~,textobj)
handles = getappdata(fig,'handles');
cp = handles.axes.CurrentPoint;
set(textobj,'Position',[cp(1,1) cp(1,2) 0]);
setappdata(fig,'handles',handles);
drawnow;