function listJoints = listvariJoints(segmentMatrixJoint)
    % lấy thông tin từng khớp trong cả chuỗi 
    listVari =[];
    for i=1:3:60
        listVari =[listVari ,varianceJoints(segmentMatrixJoint(:,i:i+2))];
    end
    listJoints = listVari;
end