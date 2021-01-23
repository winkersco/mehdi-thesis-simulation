function createRandomScenario(Model, Area)
    n = Model.n;
    x = Area.x;
    y = Area.y;
    X = zeros(1,n);
    Y = zeros(1,n);
    for iNode = 1:1:n
        X(iNode) = rand() * x;
        Y(iNode) = rand() * y;
    end
    save('Locations', 'X', 'Y');
end