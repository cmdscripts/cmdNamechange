Config = {}

Config.UseTarget = false
Config.Key = 38

Config.Locale = {
  help = '[E] Namensänderung',
  targetLabel = 'Namensänderung',
  title = 'San Andreas City Hall',
  rule = 'Namen dürfen nur Buchstaben enthalten (2-20 Zeichen)',
  fnameErr = 'Vorname muss 2-20 Buchstaben enthalten (nur Buchstaben)',
  lnameErr = 'Nachname muss 2-20 Buchstaben enthalten (nur Buchstaben)',
  dbErr = 'Datenbankfehler',
  ok = 'Name geändert zu: %s %s'
}

Config.Points = {
  {
    coords = vec3(-1285.2150, -566.8258, 31.7124),
    heading = 0.0,
    zoneSize = vec3(2.2, 2.2, 2.2)
  }
}

Config.Marker = {
  enabled = true,
  type = 25,
  scale = vec3(1.1, 1.1, 1.1),
  rgba = { 100, 100, 100, 255 },
  drawDist = 15.0,
  interactDist = 1.5,
  zOffset = -1.0
}

Config.NameRules = {
  min = 2,
  max = 20,
  allow = "^[%a]+$"
}

Config.ESX = {
  usersTable = 'users',
  identifierColumn = 'identifier',
  firstnameColumn = 'firstname',
  lastnameColumn = 'lastname'
}