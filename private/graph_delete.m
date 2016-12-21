function graph_delete(src,callbackdata,handles)
% Close request function 
% to display a question dialog box 
   selection = questdlg('Close  MATLAB Graph Editor?',...
      'Close Request Function',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         %delete([handles.fig handles.output]);
         delete(handles.fig);
      case 'No'
      return 
   end
end