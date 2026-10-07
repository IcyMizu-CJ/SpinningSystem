local DeepCopyTable = {}

function DeepCopyTable:Copy(Table: {any})
    local NewTable = {}
    for i , v in Table do
        if type(v) == 'table' then
            NewTable[i] = DeepCopyTable:Copy(v)
        else
            NewTable[i] = v
        end
    end
    return NewTable
end

return DeepCopyTable