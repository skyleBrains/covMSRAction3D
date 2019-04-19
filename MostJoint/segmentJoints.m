function listSegment = segmentJoints(matrixJoints,Ns,N)
    [m,n] = size(matrixJoints);
    listSegment=[];
    widthNs = round(m/Ns);
    if(widthNs == m)
        % fprintf('vao day');
        listSegment = [listSegment ; getIndex(listvariJoints(matrixJoints),N)];
    else
        for i=1:Ns
            if( i== Ns)
                % fprintf('co vao day')
                listSegment = [listSegment ; getIndex(listvariJoints(matrixJoints(widthNs*(i-1)+1:end,:)),N)];
            else
                % fprintf(' cung co vao day')
                listSegment = [listSegment ; getIndex(listvariJoints(matrixJoints((widthNs*(i-1)+1):widthNs*i,:)),N)];
            end
        end
    end
    
end
