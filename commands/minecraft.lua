local helper = require 'helper'
local discord, http, json = helper.discord, helper.http, helper.json

return {
    achieve = function(message, args)
        message.channel:send {
            embed = {
                title = '🎉',
                color = discord.Color.fromHex('59508f').value,
                image = {
                    url = 'https://minecraft-api.com/api/achivements/acacia_boat/achievement..got/'..args
                }
            }
        }
    end,

    ms = function(message, args)
        local msg = message.channel:send(('⏰ Getting `%s` info...'):format(args))

        local _, raw_res = http.request('GET', ('https://mcapi.xdefcon.com/server/%s/full/json'):format(args))
        local res = json.parse(raw_res)

        local embed = res.serverStatus and {
            title = ('🟢 %s is online'):format(args),
            description = res.motd.text,
            color = discord.Color.fromHex('59508f').value,
            thumbnail = {
                url = ('https://eu.mc-api.net/v3/server/favicon/%s'):format(args),
            },
            fields = {
                {name = '🎫 Info:', value = ([[-------------------

                **Version**: %s

                **Players**: %d/%d
                        
                **Ping**: %sms
                
                -------------------
                🔸 This is a cached result. Please check again in few minutes!
                ]]):format(res.version, res.players, res.maxplayers, res.ping), inline = false}
            },
            timestamp = discord.Date():toISO('T', 'Z')
        } or {
            title = ('🔴 %s is offline. Try again later!'):format(args),
            description = '❗ Make sure the address is a valid Minecraft server address and the server is online!',
            timestamp = discord.Date():toISO('T', 'Z')
        }

        msg:update { embed = embed }
    end,

    mcskin = function(message, args)
        message.channel:send {
            embed = {
                title = args,
                color = discord.Color.fromHex('59508f').value,
                image = {
                    url = ('https://minotar.net/armor/body/%s/150.png'):format(args)
                },
                timestamp = discord.Date():toISO('T', 'Z')
            }
        }
    end
}