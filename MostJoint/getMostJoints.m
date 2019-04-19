function listMostJoints = getMostJoints(X,Y,Z,Ns,N)
% chuỗi khớp xương thông tin nhất
    matJoints= matrixJoints(X,Y,Z);
    listMostJoints = segmentJoints(matJoints,Ns,N);
    
end