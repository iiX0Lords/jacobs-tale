local systemHandler = {}

function systemHandler:AddSystems(workspace)
    local systems = {}

    for name, value in pairs(prisma.Systems) do
        table.insert(systems, {
            Name = name,
            Data = value
        })
    end
    table.sort(systems, function(a, b)
        return (a.Data.Priority or 99) < (b.Data.Priority or 99)
    end)
    for i, systemEntry in ipairs(systems) do
        local system = prisma.Systems[systemEntry.Name]
        print(systemEntry.Name, i)
        if type(system) == "table" and system.__isSystemClass then
            if system.Default == false then continue end
            workspace:addSystem(system)
        end
    end
end

return systemHandler