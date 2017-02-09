hexchat.register('NCScript', '1.0', 'Newbie Contest Script')

-- == Functions ==
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function getCommonStart(Table)
	local res = Table[1]
	for i,v in pairs(Table) do
		local nres = ""
		local index = 1
		while (index < string.len(res) + 1 and index < string.len(v) + 1) do
			if (string.sub(res,1,index) == string.sub(v,1,index)) then
				nres = string.sub(res,1,index)
			end
			index = index + 1
		end
		res = nres
	end
	return res
end

function hasAlzValue(tab, val)
    for index, value in ipairs (tab) do
        if value[1] == val then
            return true
        end
    end
    return false
end

function getAlzCmdParams(tab, val)
    for index, value in ipairs (tab) do
        if value[1] == val then
            return value[2]
        end
    end
    return nil
end

NC_URL = 'https://www.newbiecontest.org/'
NC_CHALL_CATEGORIES =
{
	js="ClientSide",
	cm="Crackme",
	cr="Cryptographie",
	fo="Forensics",
	hk="Hacking",
	lo="Logique",
	pr="Programmation",
	st="Stéganographie",
	wa="Wargame",
}

Alz_Commands =
{
	{ "challinfos", {} },
	{ "choose", {} },
	{ "choosechall", {} },
	{ "help", {} },
	{ "kamulox", {} },
	{ "lastflag", {} },
	{ "liste_challs", {} },
	{ "nc", {} },
	{ "quote",
		{
			luchini="Fabrice Luchini",
			kaamelott="Kaamelott",
			nc="Membres de Newbie Contest",
			classe_americaine="La classe américaine",
			coluche="Coluche",
			citedelapeur="La cité de la peur"
		}
	},
	{ "roulette", {} },
	{ "say", {} },
	{ "wtf", {} },
}

ncMenu =
{
	'"$NICK/Newbie Contest"',
	'"$NICK/Newbie Contest/Profil" "URL '..NC_URL..'index.php?page=info_membre&nick=%s"',
	'"$NICK/Newbie Contest/Comparer les validations" "URL '..NC_URL..'index.php?page=info_membre&nick=%s&compare"',
	'"$NICK/Newbie Contest/Localiser dans le classement" "URL '..NC_URL..'index.php?page=classementdynamique&member=%s"',
	'"$NICK/Newbie Contest/Envoyer un message" "URL '..NC_URL..'forums/index.php?action=pm;sa=send;to=%s"',
	'"$NICK/Newbie Contest/-"',
	'"$NICK/Newbie Contest/Classement et validations" "SAY !nc %s"',
	'"$NICK/Newbie Contest/Dernière validation" "SAY !lastflag %s"',
	'"$NICK/Newbie Contest/Kamouloxer" "SAY !kamulox %s"',
	'"$NICK/Newbie Contest/Suggérer un challenge aléatoire" "SAY !choosechall %s"',
	'"$NICK/Newbie Contest/Suggérer un challenge aléatoire de..."',
	'"_Newbie Contest/Commandes IRC"',
	'"_Newbie Contest/Commandes IRC/Classement et validations" "SAY !nc"',
	'"_Newbie Contest/Commandes IRC/Dernière validation" "SAY !lastflag"',
	'"_Newbie Contest/Commandes IRC/Obtenir un challenge aléatoire" "SAY !choosechall"',
	'"_Newbie Contest/Commandes IRC/Obtenir un challenge aléatoire de..."',
	'"_Newbie Contest/Commandes IRC/Citations..."',
	'"_Newbie Contest/Commandes IRC/Kamoulox" "SAY !kamulox"',
	'"_Newbie Contest/Commandes IRC/Roulette russe" "SAY !roulette"',
	'"_Newbie Contest/Commandes IRC/-"',
	'"_Newbie Contest/Commandes IRC/Aide" "SAY !help"',
}
for i,v in pairs(NC_CHALL_CATEGORIES) do
	table.insert(ncMenu, '"$NICK/Newbie Contest/Suggérer un challenge aléatoire de.../'..v..'" "SAY !choosechall '..i..' %s"')
	table.insert(ncMenu, '"_Newbie Contest/Commandes IRC/Obtenir un challenge aléatoire de.../'..v..'" "SAY !choosechall '..i..'"')
end
for i,v in pairs(getAlzCmdParams(Alz_Commands,"quote")) do
	table.insert(ncMenu, '"_Newbie Contest/Commandes IRC/Citations.../'..v..'" "SAY !quote '..i..'"')
end

ncUserButtons =
{
	'"Profil NC" URL '..NC_URL..'index.php?page=info_membre&nick=%s',
	'"Classement NC" URL '..NC_URL..'index.php?page=classementdynamique&member=%s',
}

-- Initialisation
hexchat.command('MENU -p-1 DEL "_Newbie Contest"')
hexchat.command('MENU -p-1 ADD "_Newbie Contest"')
for i,v in pairs(ncMenu) do
	hexchat.command('MENU DEL '..v)
	hexchat.command('MENU ADD '..v)
end

-- User buttons
hexchat.hook_print('Open Context', function (args)
	for i,v in pairs(ncUserButtons) do
		hexchat.command('DELBUTTON '..v)
		hexchat.command('ADDBUTTON '..v)
	end
end)

-- Autocomplete
hexchat.hook_print('Key Press', function (args)
	if (args[1] == '65289') then
		local input = hexchat.get_info('inputbox')
		if (input.starts(input, '!')) then
			local matchs = {}
			local cmd, param = input:match("^!(%a+)%s*(%a*)%s*$")
			if (hasAlzValue(Alz_Commands, cmd)) then
				if (param == "") then
					hexchat.command('SETTEXT !'..cmd..' ')
					hexchat.command('SETCURSOR '..(string.len(cmd) + 2))
				else
					local params = getAlzCmdParams(Alz_Commands, cmd);
					for i,v in pairs(params) do
						if (string.starts(i, param)) then
							table.insert(matchs, i)
						end
					end
					if (#matchs > 1) then
						hexchat.print(table.concat(matchs, ", "))
						local mtchstart = getCommonStart(matchs);
						hexchat.command('SETTEXT !'..cmd..' '..mtchstart)
						hexchat.command('SETCURSOR '..(string.len(cmd..' '..mtchstart) + 1))
					elseif (#matchs == 1) then
						hexchat.command('SETTEXT !'..cmd..' '..matchs[1]..' ')
						hexchat.command('SETCURSOR '..(string.len(cmd..' '..matchs[1]) + 2))
					end
				end
			else
				for i,v in pairs(Alz_Commands) do
					if (string.starts(v[1], string.sub(input,2))) then
						table.insert(matchs, v[1])
					end
				end
				if (#matchs > 1) then
					hexchat.print(table.concat(matchs, ", "))
					local mtchstart = getCommonStart(matchs);
					hexchat.command('SETTEXT !'..mtchstart)
					hexchat.command('SETCURSOR '..(string.len(mtchstart) + 1))
				elseif (#matchs == 1) then
					hexchat.command('SETTEXT !'..matchs[1]..' ')
					hexchat.command('SETCURSOR '..(string.len(matchs[1]) + 2))
				end
			end
		end
	end
end)

-- Commands
hexchat.hook_command('DOOR', function (args)
	hexchat.command('MSG '..hexchat.get_info('channel')..' -->[]')
	return hexchat.EAT_ALL
end)
