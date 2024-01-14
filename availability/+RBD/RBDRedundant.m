function result = RBDRedundant(avail, n)
    arguments
        avail
        n
    end
    avail_matrix = repelem(avail,n,1);
    result = 1-prod(1.-avail_matrix);
end

