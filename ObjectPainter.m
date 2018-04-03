function [ I ] = ObjectPainter( V,C,F,D)
%Output I= M X N X 3
%        K triangles
%V = Coordinates of each peak of my triangle... x,y (L x 2)
%F = Peaks of the triangles. K X 3 
%C = Colours L X 3
%D = Depth of the peak L X 1
load("cat.mat");
M=1150;
N=1300;

X=ones(M,N,3);
D_mean=zeros(size(D));
%D_sorted=zeros([size(F,1) 1]);
%D_order=zeros([size(F,1) 1]);
%F_matched = zeros (size(F));
%painterType='f';

for i=1:1:size(F,1)
    D_mean(i) = mean (D(F(i,:)));
end
%sort array D_mean
[ ~ , D_order ] = sort (D_mean);
%sort F matching the D_sorted~~~mean
F_matched = F((D_order),:);

 %initialize V_triangle , C_triangle
 V_triangle =zeros([3 2]);
 C_triangle =zeros([3 3]);
 
 for i=size(F_matched,1):-1:1
    for k=1:1:3 %k-peak of the triangle
    
      V_triangle(k,:)=V(F(i,k));
      C_triangle(k,:)=C(F(i,k));
    end
    %paint the triangle
    Y=TriPaintFlat(X,V_triangle,C_triangle);
    X=Y;
 end
 
end
