function vari = varianceJoints(matrixSegment)
    meanP =mean(matrixSegment);
    vari =0;
    for i =1:size(matrixSegment,1)
        vari = vari + sqrt(sum((matrixSegment(i,:)-meanP).^2));
    end
     vari =vari/(size(matrixSegment,1)-1);
end
