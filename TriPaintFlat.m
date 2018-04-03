function [Y] = TriPaintFlat(X,V,C)
 % for now on X,V,C are unused
 %X = is my previous matrix(M X N X 3)
 %V = Coordinates of each peak of my triangle... x,y (3 x 2)
 %C = Colour in RGB ( 3 X 3 ) in [0 , 1 ]
 % -------compute the colour of my triangle------
 % it's the mean of the colours of the three peaks
 
 R_triangle = mean (C(:,1));
 G_triangle = mean (C(:,2));
 B_triangle = mean (C(:,3));

 % make a matrix with the pairs  of the edges
 edges=[V(1,:) V(2,:) ; V(2,:) V(3,:) ; V(1,:) V(3,:) ]; 
 
 y_higher_edges=zeros([1 3]);
 y_lower_edges = zeros([1 3]);
 x_lower_edges=zeros([1 3]);
 x_higher_edges=zeros([1 3]);
 
 
  for k=1:1:3
     y_higher_edges(k)=max(edges(k,[2 4]));
     y_lower_edges(k)=max(edges(k,[2 4]));
  end
 %find ymin , ymax
 ymin = min(y_lower_edges);
 ymax = max(y_higher_edges); 
 for k=1:1:3
     if (edges(k,2)==y_lower_edges(k))
        x_lower_edges(k)=edges(k,1); % is the x for the lowerest edgepoint
     else 
        x_lower_edges(k)=edges(k,3);
     end
     if ( edges(k,2)==y_higher_edges(k)) %xman is the x for the highest edgepoint
        x_higher_edges(k)=edges(k,1);
     else
        x_higher_edges(k)=edges(k,3);
     end
 end  
 
 %make edge nodes = [y_higher y_lower x_lower x_higher slope]
 edges_nodes=zeros([3 5]);
 for k=1:1:3
     dy=edges(k,4)-edges(k,2);
     dx=edges(k,3)-edges(k,1);
     ym=dy/dx; 
     slope=1/ym;
     edges_nodes(k,:)=[y_higher_edges(k) y_lower_edges(k) x_lower_edges(k)  x_higher_edges(k) slope];
  end
% 
  Active_Edge_List=zeros([1 3]); 
  Active_Points =zeros([2 2]);% x y
%  %out=nnz(~A)
%  %show how many zero-elements exist in matrix A
%  
  count=1;
  for k=1:1:3
     if (ymin ==edges_nodes(k,2))
       Active_Edge_List(k)=1;  %k-th active edges ON
       Active_Points(count,:)=[edges_nodes(k,3) edges_nodes(k,2)]; % aka x_lower_edges y_lower_edges
       count=count+1;
     end
  end
 
  %scanning......
 
  for scan_y=ymin:1:ymax
       cross_count=0;
       %sort Active_Points according the x-coordinate
       Active_Points=sortrows(Active_Points,1);
       
       for x=1:1:1300
           if x == floor(Active_Points(1,1) || x == floor(Active_Points(2,1)))
               cross_count=cross_count+1;
               %X(),scan_y,:)=[R_triangle G_triangle B_triangle];
           end
           if(mod(cross_count,2)==1)
               X(x,scan_y,:)=[R_triangle G_triangle B_triangle];
               
           end    
       end
       %update Active_Points
       count=1;
       for k=1:1:3
          if Active_Edge_List(k)==1
             %update x of the Active_Points according to the edge-slope
             if (edges_nodes(k,5)==0)
                 %do not change the Active_Points--continue
                 %this is for horizontal lines
                 
             elseif (edges_nodes(k,5)==~Inf) %aka slope of the edge
               Active_Points(count,1)=Active_Points(count,1)+edges_nodes(k,5);
               count=count+1;
             else %this is for vertical lines  
      
             end
          end   
       end
       %---update active_points just the y-coordinate
       Active_Points(1,2)=scan_y+1;
       Active_Points(2,2)=scan_y+1;

       % update Active_Edge_List
       for k=1:1:3
             if (edges_nodes(k,1) == scan_y ) %aka y_higher = scan_y

                Active_Edge_List(k)=0;        %remove this edge from the list
             end
             if (edges_nodes(k,2)== scan_y+1) %aka y_lower=scan_y+1

                 Active_Edge_List(k)=1;
             end    
       end
     
 end   
  
end
 
 
 
 
 
 
 
 
 