function renewObject(fig)
%when opening a graph file, find all objects' handle.
handles = getappdata(fig,'handles');
for i = 1:handles.NodeNumber
    rec_tag = ['Rec' num2str(i)];
    name_tag = ['Name' num2str(i)];
    handles.RecMat(i) = double(findobj(fig,'Tag',rec_tag));
    handles.NodeNumberText(i) = double(findobj(fig,'Tag',name_tag));
end
[row,col] = find(handles.EdgeMat~=0);
for i = 1:length(row)
    edge_tag = ['Edge' num2str(row(i)) ',' num2str(col(i))];
    arrow1_tag = ['Arrow1' num2str(row(i)) ',' num2str(col(i))];
    arrow2_tag = ['Arrow2' num2str(row(i)) ',' num2str(col(i))];
    weight_tag = ['Weight' num2str(row(i)) ',' num2str(col(i))];
    handles.EdgeMat(row(i),col(i)) = double(findobj(fig,'Tag',edge_tag));
    handles.Arrow1Mat(row(i),col(i)) = double(findobj(fig,'Tag',arrow1_tag));
    handles.Arrow2Mat(row(i),col(i)) = double(findobj(fig,'Tag',arrow2_tag));
    handles.WeightMat(row(i),col(i)) = double(findobj(fig,'Tag',weight_tag));
end
setappdata(fig,'handles',handles);