local discord = require 'discordia'
local client = discord.Client()

local helper = require 'helper'
local stuff = require 'stuff'  -- all secret variables

local command_groups = {'minecraft', 'utilities'}
local prefix = 'mf'

client:on('messageCreate', function(message)
    if message.author.bot then return end
    local content = message.content

    local prefixed = content:sub(1, 2)

    if prefixed == prefix or prefixed == 'bb' or prefixed == 'oi' then
        local strict_prefix = false
        local threads = helper.split(content, ' && ')

        for index, thread in pairs(threads) do
            if prefixed ~= prefix and index == 1 then strict_prefix = true goto continue end
            if strict_prefix and index > 1 and thread:sub(1, 2) ~= prefix then goto continue end
            
            local main = thread:gsub(prefix..'%s?', '')
            local components = helper.split(main, ' ')
            local cmd = components[1]
            local args = components[2]

            for _, cmd_group in ipairs(command_groups) do
                local exec = require('commands.'..cmd_group)
                if exec[cmd] then
                    return exec[cmd](message, args, main)
                end
            end
            ::continue::
        end
    end
end)


client:on('ready', function()
    client:setGame('shogu')
    client:setStatus('idle')

    helper.discord = discord
    helper.http = require 'coro-http'
    helper.json = require 'json'
    helper.bash = require 'coro-spawn'
end)

client:run('Bot '..stuff.token)