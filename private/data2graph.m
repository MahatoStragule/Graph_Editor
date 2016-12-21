function data2graph(datamatrix,fig)
mode = 0;
if (diag(datamatrix) >= 0) + (sum(datamatrix,2) == 0) > 1
    tmp_datamatrix = datamatrix - diag(diag(datamatrix));
    if (tmp_datamatrix == 0) + (tmp_datamatrix < 0) > 0
        mode = 1;
    end
elseif diag(datamatrix) == 0
    if datamatrix >= 0
        mode = 2;
    end
end
handles = getappdata(fig,'handles');
switch mode
    case 1
        gl2graph;
    case 2
        ad2graph;
    otherwise
        return
end
    function gl2graph
        datamatrix = -(datamatrix - diag(diag(datamatrix)));
        [row,col] = find(datamatrix ~= 0);
        weight_text = cell(length(row),1);
        weight_flag = 0;
        for i = 1:length(row)
            handles.ArrowStart = col(i);
            setappdata(fig,'handles',handles);
            recBDCallback(handles.RecMat(row(i)),0,fig,row(i));
            if datamatrix(row(i),col(i)) ~= 1
                weight_text{i} = num2str(datamatrix(row(i),col(i)));
                weight_flag = 1;
            else
                weight_text{i} = '1';
            end
            handles = getappdata(fig,'handles');
        end
        if weight_flag
            handles.WeightVisible = 'on';
            set(handles.WeightMat(handles.EdgeMat~=0),{'String'},weight_text);
            set(handles.WeightMat(handles.EdgeMat~=0),'Visible','on');
            hObject1 = findobj('Label','Weight setting');
            set(hObject1,'Checked','on');
            hObject2 = findobj('Label','WeightEdit');
            set(hObject2,'Enable','on');
        end
        setappdata(fig,'handles',handles);
    end

    function ad2graph
        [row,col] = find(datamatrix ~= 0);
        weight_text = cell(length(row),1);
        weight_flag = 0;
        for i = 1:length(row)
            handles.ArrowStart = col(i);
            setappdata(fig,'handles',handles);
            recBDCallback(handles.RecMat(row(i)),0,fig,row(i));
            if datamatrix(row(i),col(i)) ~= 1
                weight_text{i} = num2str(datamatrix(row(i),col(i)));
                weight_flag = 1;
            else
                weight_text{i} = '1';
            end
            handles = getappdata(fig,'handles');
        end
        if weight_flag
            handles.WeightVisible = 'on';
            set(handles.WeightMat(handles.EdgeMat~=0),{'String'},weight_text);
            set(handles.WeightMat(handles.EdgeMat~=0),'Visible','on');
            hObject1 = findobj('Label','Weight setting');
            set(hObject1,'Checked','on');
            hObject2 = findobj('Label','WeightEdit');
            set(hObject2,'Enable','on');
        end
        setappdata(fig,'handles',handles);
    end
end