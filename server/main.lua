-- Optional Server-side logic (e.g., Syncing player counts or broadcasting announcements)
RegisterCommand("announce", function(source, args, rawCommand)
    local msg = table.concat(args, " ")
    TriggerClientEvent('chat:addMessage', -1, {
        color = { 192, 38, 211},
        multiline = true,
        args = {"SERVER ANNOUNCE", msg}
    })
end, true)