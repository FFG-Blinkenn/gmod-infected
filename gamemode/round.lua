Round = {}
Round.State = nil -- use tables to store variables, less memory

CreateConVar( "infected_preround_time", "60", 0, "Set the length of a pre-round in Infected." ) -- Creates a in-game command so that users can change the time, default 1 minute.
CreateConVar( "infected_round_time", "720", 0, "Set the length of a round in Infected." ) -- Creates a in-game command so that users can change the time, default 12 minutes.
CreateConVar( "infected_postround_time", "20", 0, "Set the legnth of the post-round in Infected." )-- Creates a in-game command so that users can change the time, default 1 minute.

function RoundStart()
	timer.Create( "RoundLength", GetConVarNumber("infected_round_time"), 1, RoundEnd() ) -- Need to change GetConvarNumber too GetConvsr and ConVar:GetInt due to GetConVarNumber being deprecated
    local totalply = #player.GetAll()
	for k, v in pairs(totalply) do -- Put all players in a loop.
    	local randnumber = math.random(0, totalply) -- Get a random player from everybody that is online.
    	v[randnumber]:SetTeam(TEAM_INIT_INFECTED) -- Set that random player to the initial infected.
    end
end

function RoundSetup( ply )
	game.CleanUpMap() 
	timer.Create("PreRound", GetConVarNumber("infected_preround_time"), 1, RoundStart()) -- Need to change GetConvarNumber too GetConvsr and ConVar:GetInt due to GetConVarNumber being deprecated
	SpawnPlayers()
  	for k, v in pairs(player.GetAll())
  		ply:SetTeam( TEAM_SURVIVOR )
  	end
end

function RoundActive()
    local infected = {}
    local survivors = {}
    
    for k,v ipairs( players ) do
        if v:Alive() then
            if v:Team() == TEAM_SURVIVOR then
                table.insert(survivors, v )
            elseif v:Team() == TEAM_INFECTED then
                table.insert(infected, v )
            end
        end
    end

    if timer.Exists("RoundLength") -- This returns a boolean, it wont work unless you add "== true" ~ Prior
        if(#survivors == (0) then
            RoundEnd(WIN_INFECTED)
        	InfectedWin() -- Call a function so we can create pretty text and stuff, maybe effects/sounds showing that the infected won. E.g when Deaths win in deathrun.
        elseif(#survivors => 1 and timer.TimerLeft("RoundLength") == 0) then -- It shouldn't be less than one, it should be more then one?
            RoundEnd(WIN_SURVIVOR)
        	SurvivorsWin() -- Call a function so we can create pretty text and stuff, maybe effects/sounds showing that the survivors won. E.g when Deaths win in deathrun.
        end
end
      
function RoundEnd(winningteam)
    if table.sort( team.GetPlayers(TEAM_SURVIVOR) ) == 0 then
        timer.Create( "PostRound", GetConVarNumber("infected_postround_time"), 1, RoundStart() ) -- Need to change GetConvarNumber too GetConvsr and ConVar:GetInt due to GetConVarNumber being deprecated
    end  
end
