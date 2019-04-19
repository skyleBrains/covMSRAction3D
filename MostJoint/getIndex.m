function listIndex = getIndex(Fk,N)
[val ind] = sort(Fk,'descend');
listIndex = ind(1:N);
end