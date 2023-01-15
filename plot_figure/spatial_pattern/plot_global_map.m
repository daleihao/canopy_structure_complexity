function plot_global_map(lats, lons, sw_total, min_clr, max_clr,isxticklabel,isyticklabel)
colors_single = flipud(brewermap(10, 'Spectral'));
colormap(colors_single)


m_proj('robinson','lat',[min(lats(:)) max(lats(:))],'lon',[min(lons(:)) max(lons(:))]); % robinson Mollweide
%m_coast('color','k');
hold on
% m_grid('tickdir','in','linestyle','none','backcolor',[.9 .99 1], ...%'xticklabels',[], ...
%     'fontsize',8);

if isyticklabel && isxticklabel
    m_grid('tickdir','in','linestyle','none','backcolor',[.9 .99 1], ...
        'fontsize',7);
elseif isyticklabel && ~isxticklabel
    m_grid('tickdir','in','linestyle','none','backcolor',[.9 .99 1], 'xticklabels',[], ...
        'fontsize',7);
elseif ~isyticklabel && isxticklabel
    m_grid('tickdir','in','linestyle','none','backcolor',[.9 .99 1], 'yticklabels',[], ...
        'fontsize',7);
else
    m_grid('tickdir','in','linestyle','none','backcolor',[.9 .99 1], 'xticklabels',[], 'yticklabels',[], ...
        'fontsize',7);
end

m_pcolor(lons,lats,sw_total);
M=m_shaperead('landareas'); 
for k=1:length(M.ncst)    
     m_line(M.ncst{k}(:,1),M.ncst{k}(:,2),'color','k','linewidth',1); 
end; 

M=m_shaperead('AmazonShp/AmazonShp/amazonia_line'); 
for k=1:length(M.ncst)    
     m_line(M.ncst{k}(:,1),M.ncst{k}(:,2),'color','k','linewidth',1); 
end;

M=m_shaperead('Cornbelt_shp/shp/cornbelt'); 
for k=1:length(M.ncst)    
     m_line(M.ncst{k}(:,1),M.ncst{k}(:,2),'color','k','linewidth',1); 
end;
shading flat;
caxis([min_clr,max_clr])


%view(0,90);
hold off

