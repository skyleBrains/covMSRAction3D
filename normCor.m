function normx = normCor(cord)
    minX = min(cord(:));
    maxX = max(cord(:));
    normx = (cord - minX) / (maxX - minX);
    end