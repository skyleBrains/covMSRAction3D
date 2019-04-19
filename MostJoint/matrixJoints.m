function matJoint = matrixJoints(X,Y,Z)
% matrixJoint trả về khớp i ,khớp  i+1 ... 
    nJoints = size(X, 2);
    assert(size(Y, 2) == nJoints);
    assert(size(Z, 2) == nJoints);
    P = zeros(size(X,1),3*nJoints);
    for k=1:size(X,1)
        coordinatorJoint = [];
        for i=1:nJoints
            coordinatorJoint = [coordinatorJoint ,X(k,i),Y(k,i),Z(k,i)];                
        end
        P(k,:) = coordinatorJoint;
    end
    matJoint = P;
end