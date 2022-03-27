local function New(PartType: any, Parent: Instance, Name: string?)
    local _Instance
    if typeof(PartType) == "string" then
        _Instance = Instance.new(PartType,Parent)
        _Instance.Name = Name
    elseif typeof(PartType) == "table" then
        _Instance = {}
        for _,instance in pairs(PartType) do
            local _Instance = Instance.new(instance,Parent)
            _Instance.Name = Name
            table.insert(_Instance,_Instance)
        end
    end

    return _Instance
end


return New
