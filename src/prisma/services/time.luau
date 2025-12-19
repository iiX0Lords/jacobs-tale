local timeManager = {
    Timers = {}
}

function timeManager:Timer(length : number, callback : () -> ())
    table.insert(timeManager.Timers, {
        TimeLeft = length,
        Callback = callback
    })
end

function timeManager:tick(dt)
    for i = #timeManager.Timers, 1, -1 do
        local timer = timeManager.Timers[i]

        timer.TimeLeft = timer.TimeLeft - dt

        if timer.TimeLeft <= 0 then
            pcall(timer.Callback)

            table.remove(timeManager.Timers, i)
        end
    end
end

return timeManager