local helper = require 'helper'
local stuff = require 'stuff'
local discord, http, json = helper.discord, helper.http, helper.json

return {
    help = function(message)
        message.channel:send {
            embed = {
                title = '☪ Kasho',
                description = 'Lua powered mf, created by shotgun#4239',
                color = discord.Color.fromHex('59508f').value,
                thumbnail = {
                    url = 'https://i.imgur.com/ub0IzgQ.png'
                },
                fields = {
                    {name = 'Prefix: `mf`', value = [[-----------------
                    `help` - Show this page
                    `` - todo
                    ]], inline = false}
                },
                timestamp = discord.Date():toISO('T', 'Z')
            }
        }
    end,

    bond = function(message, args)
        local voice_channel = message.member.voiceChannel
        if not voice_channel then return message.channel:send('💞 Join a voice channel to start bonding!') end
        
        local activity = helper.bondapp[args]
        if not activity then return message.channel:send('💕Some bonding activities I found: `youtube | poker | betrayal | fishing | chess | lettertile | wordsnack | doodlecrew | awkword | spellcast | checkers | puttparty | sketchyartist`') end

        local invite = voice_channel:createInvite {
            unique = true,
            targetApplication = activity,
            targetType = 2
        }

        message.channel:send {
            embed = {
                title = ("💞 %s's bonding time!"):format(message.guild.name),
                description = 'Selected Activity: '..args,
                color = discord.Color.fromHex('59508f').value,
                thumbnail = {
                    url = invite.guildIconURL
                },
                fields = {
                    {name = '💫 Join '..invite.channelName, value = ('https://discord.gg/%s'):format(invite.code), inline = false}
                },
                timestamp = discord.Date():toISO('T', 'Z')
            }
        }
    end,

    compile = function(message, args, main)
        local code_filter = main:gsub('%w+ %w+ ```%w+%c', '')
        local code = code_filter:sub(1, #code_filter - 4)
        local lang = helper.langmap[args]

        if not args or not lang then
            return message.channel:send([[📜 Ight use valid syntax: `c | cpp | csharp | objc | java | nodejs | lua | rust | python3 | ruby | brainfuck | go | swift | perl | php | sql | clojure | coffeescript | elixir | lolcode | kotlin | groovy | octave`
            __**Example:**__ mfcompile lua \\`\\`\\`lua
            print('dedicated')
            \\`\\`\\`]])
        end

        local program = json.encode({
            script = code,
            language = args,
            versionIndex = lang,
            clientId = '4cd9c17710ee5f4a2f87689e2860f82d',
            clientSecret = 'd0b7c4f7575e47e696b217a16e657ff4e1148b95328e5fd02cc9166a3440753e',
        })

        local header = {
            {'Content-Type', 'application/json'}
        }

        local _, raw_res = http.request('POST', 'https://api.jdoodle.com/v1/execute', header, program)
        local output = json.parse(raw_res)

        message.channel:send {
            embed = {
                title = '📜 Output:',
                description = '```'..output.output..'```',
                color = discord.Color.fromHex('59508f').value,
                footer = {
                    text = ('CPU Time: %sms | Memory: %skb'):format(output.cpuTime, output.memory)
                },
                timestamp = discord.Date():toISO('T', 'Z')
            }
        }
    end,

    gato = function(message)
        local _, raw_res = http.request('GET', 'https://apilist.fun/out/randomcat')

        message.channel:send {
            embed = {
                title = 'gato',
                color = discord.Color.fromHex('59508f').value,
                image = {
                    url = json.parse(raw_res).file
                },
                timestamp = discord.Date():toISO('T', 'Z')
            }
        }
    end,

    wa = function(message, args)
        if not message.channel.nsfw then return message.channel:send('☪ `nsfw channel only uwu`') end

        local _, raw_res = http.request('GET', args and stuff.sw..args or 'https://api.waifu.pics/sfw/waifu')
        local res = json.parse(raw_res)

        message.channel:send {
            embed = {
                title = '☪ wa',
                color = discord.Color.fromHex('59508f').value,
                image = {
                    url = res.url
                },
                timestamp = discord.Date():toISO('T', 'Z')
            }
        }
    end
}