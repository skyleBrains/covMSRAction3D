function listIdx = getIdxMostJoints(matrixJoints,onf)
    matrixJoints
    listAngle = unique(matrixJoints);
    listValueAngle = zeros(1,size(listAngle,1));
    for a=1:size(listAngle,1)
        listValueAngle(a) = sum(sum(matrixJoints ==listAngle(a)));
    end
    [val ind] = sort(listValueAngle,'descend');
    listIndex = ind(1:onf);
    % listAngle
    % listValueAngle
    listIdx = listAngle(listIndex);
    %  pause
    % listIdx
end
