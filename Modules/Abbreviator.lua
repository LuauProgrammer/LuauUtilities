--!strict

type array = {
    [any]: any
}

return function(String: string,Pattern: string)
    local Split: array = String:split(Pattern)
    local Abbreviation: string = Split[1]:sub(1,1)
    
    for Index: number, Word: string in ipairs(Split) do
        if Index > 1 then
            Abbreviation = Abbreviation..Word:sub(1,1)
        end
    end
    return Abbreviation
end
