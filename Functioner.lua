loadstring(game:HttpGet("https://raw.githubusercontent.com/Tropxzz/Xpertise/main/Ching.lua",true))()

function runwhenwhitelist()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Tropxzz/Xpertise/main/Games/"..game.PlaceId..".lua",true))()
end

if game.PlaceId == 155615604 then
 shared.PL = true
runwhenwhitelist()
end


if game.PlaceId == 6872274481 then
shared.L == true
 runwhenwhitelist()
end

if shared.PL == false and shared.L == false then -- and other stuff
 game.Players.LocalPlayer:Kick()
end
