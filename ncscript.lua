hexchat.register('NCScript', '1', 'Newbie Contest Script')

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
ALZ_QUOTE =
{
	luchini="Fabrice Luchini",
	kaamelott="Kaamelott",
	nc="Membres de Newbie Contest",
	classe_americaine="La Classe Américaine",
	coluche="Coluche",
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
for i,v in pairs(ALZ_QUOTE) do
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
for i,v in pairs(ncUserButtons) do
	hexchat.command('DELBUTTON '..v)
	hexchat.command('ADDBUTTON '..v)
end

-- Autocomplete
hexchat.hook_print('Key Press', function (args)
	if (args[1] == '65289') then
		local input = hexchat.get_info('inputbox')
		-- TODO : find a way to edit the inputbox text
	end
end)