classdef pointyColorbar < handle
%Make a colorbar with arrow shaped end
%h = pointyColorbar(minw,maxw,...);
%
%MathWorks - SCd 09/24/2012
%
%Inputs:
%   maxw: top base of top arrow
%   minw: bottom base of bottom arrow
%   Other: input options from colorbar
%
%Outputs:
%   h: handle to pointyColorbar object
%
%Methods:
%   set: set(obj,'Property','Value') %P/V pairs or other inputs from
%        colorbar()
%
%See Also: colorbar
%

      %Properties
      properties (SetObservable=true)
          maxw %top edge of arrow
          minw %bottom edge of arrow
      end
      properties (Access=private)
          hCB           %Handle to colorbar
      end

      %Methods
      methods
          function obj = pointyColorbar(minw,maxw,varargin)
              %Very Basic Error Checking
              assert(nargin>=2,'Two or more inputs expected')

              %Build obj and colorbar
              obj.maxw    = maxw;
              obj.minw    = minw;
              obj.hCB     = colorbar(varargin{:});

              %In case the colormap/maxw/minw changes
              addlistener(gcf,'Colormap','PostSet',@(~,~)makePointy(obj));
              addlistener(obj,'dmaxmin',@(~,~)makePointy(obj));            

              %Begin!
              makePointy(obj);
          end
          function set(obj,varargin)
              %Generic Setter
              set(obj.hCB,varargin{:});
              makePointy(obj);            
          end
          function set.maxw(obj,val)
              obj.maxw = val;
              notify(obj,'dmaxmin');
          end
          function set.minw(obj,val)
              obj.minw = val;
              notify(obj,'dmaxmin');
          end
          function delete(obj)
              %Delete
              delete(obj.hCB);
          end        
      end
      methods (Access=protected)
          function makePointy(obj)
              %Some information
              hChild  = get(obj.hCB,'Children'); %get image handle
              CData   = get(hChild,'CData'); %get image data and make it wider so we can pointify the top            

              %Figure out current settings
              if isvector(CData)
                  %Not pointy                 
                  n    = numel(CData);
                  cmap = get(gcf,'Colormap');
                  if iscolumn(CData);
                      %Vertical Colorbar
                      drange  = get(hChild,'YData');
                      lim     = 'XLim';
                      rowflag = false;
                  elseif isrow(CData)
                      %Horizontal
                      drange  = get(hChild,'XData');
                      lim     = 'YLim';
                      rowflag = true;                   
                  end

                  %Build new image matrix
                  CData = repmat(reshape(cmap(CData,:),[n, 1, 3]),[1 25 1]); %[nx25x3] rgb image

              else
                  %Already pointy!
                  axpos = get(obj.hCB,'Position');
                  if axpos(3)<axpos(4)
                      %Taller than wider -> vertical
                      drange  = get(hChild,'YData');                
                      lim     = 'XLim';
                     % CData = CData(:,13,:);
                      rowflag = false;
                  else    
                      %Horizontal
                      drange  = get(hChild,'XData');
                      lim     = 'YLim';
                  %  CData   = CData(13,:,:); %transpose so we can just solve one way
                      rowflag = true;      
                  end                
                  n = numel(CData)./3; %reset to just size of original CData

                  %Build new image matrix
                  CData = repmat(reshape(CData,[n, 1, 3]),[1 25 1]); %[nx25x3] rgb image

              end

              %Figure out where to blot out
              idx    = linspace(drange(1),drange(2),n); %This gives where in CData maxw/minw lie
              [~,tb] = min(abs(idx-obj.maxw)); %top base
              [~,bb] = min(abs(idx-obj.minw)); %bottom base
              x = [13 25 25 13 0.5 0.5]; %x coordinates of polygon
              y = [0.5 bb tb n tb bb]; %y coordinates of polygon
              M = repmat(~poly2mask(x,y,n,25),[1 1 3]); %build mask
              CData(M) = 1; %Apply mask

              %If we transposed, transpose back
              if rowflag
                 CData = permute(CData,[2 1 3]);
              end

              %Reset
              set(hChild,'CData',CData);
              set(hChild,'CDataMapping','Scaled');            
              set(obj.hCB,lim,[0 1])
          end
      end
      events
          dmaxmin; %Changes in max or min
      end
  end