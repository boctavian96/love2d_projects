function areTablesEqual(t1, t2)

    if(#t1 ~= #t2) then 
        return false
    end

    for i=1, #t1 do 
        if(t1[i] ~= t2[i]) then 
            return false
        end
    end

    return true
end

function sizeOf(t)
    local size = 0

    for i=0, #t do 
        if(t ~= nil) then 
            size = size + 1
        end
    end

    return size

end