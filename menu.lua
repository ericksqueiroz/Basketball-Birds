-- Requisita o storyboard e cria uma nova cena
local storyboard = require("storyboard")
local scene = storyboard.newScene()

_W = display.contentWidth 
_H = display.contentHeight

-- Adiciona música em loop
--bgSound = audio.loadStream("sounds/menu.mp3")
--mySong = audio.play( bgSound, { channel = 1, loops = -1 } )

--Adiciona o background
local background = display.newImage("images/menubg.jpg")
	background.x = _W/2
	background.y = _H/2

--Adiciona o logo 
local logo = display.newImage("images/menu1.png")
	logo.x = _W/2
	logo.y = 320
	logo.xScale = 1.5
	logo.yScale = 1.5

--Adiciona o botão de start
local start = display.newImage("images/start.png")
	start.x = _W/2
	start.y = _H/2 + 150
	start.xScale = 0.4
	start.yScale = 0.4	

local function start_game()
	storyboard.gotoScene("game")
	audio.stop()
end	
start:addEventListener("tap", start_game)

--Adiciona o botão de ferramentas
local settings = display.newImage("images/settings.png")
  settings.x = _W-35
  settings.y = _H-35
  settings.xScale = 0.5
  settings.yScale = 0.5

--Adiciona o menu de ferramentas
local settingsbg = display.newImage("images/settingsbg.png")
  settingsbg.x = _W/2
  settingsbg.y = _H/2 + 130
  settingsbg.xScale = 0.9
  settingsbg.yScale = 0.9
  settingsbg.alpha = 0

local soundon = display.newImage("images/soundon.png")
  soundon.x = _W/2
  soundon.y = _H/2+200
  soundon.xScale = 0.8
  soundon.yScale = 0.8
  soundon.alpha = 0  

local soundoff = display.newImage("images/soundoff.png")
  soundoff.x = _W/2
  soundoff.y = _H/2+200
  soundoff.xScale = 0.8
  soundoff.yScale = 0.8
  soundoff.alpha = 0    

--Função para tirar o som no menu de pause
local function muteGame()  
    soundon.alpha = 0
    soundoff.alpha = 1
  end 
soundon:addEventListener("tap", muteGame)

local function unmuteGame()  
    soundon.alpha = 1
    soundoff.alpha = 0
  end 
soundoff:addEventListener("tap", unmuteGame)  

function settingsMenu()
  if settingsbg.alpha == 0 then
  	settingsbg.alpha = 1 
  	soundon.alpha = 1
  	start.alpha = 0
  else	
  	settingsbg.alpha = 0
  	soundon.alpha = 0
  	soundoff.alpha = 0
  	start.alpha = 1
  end	
end
settings:addEventListener("tap", settingsMenu)   

--Adiciona o pássaro cinza
local sheet1 = graphics.newImageSheet( "images/bird0.png", { width=125, height=125, numFrames=4 } )

--Cria o sprite do pássaro cinza
local instance1 = display.newSprite( sheet1, { name="bird", start=1, count=4, time=500 } ) 
  instance1.x = 90
  instance1.y = _H/2 + 240
  instance1.rotation = -20
  instance1:play()  

--Adiciona o pássaro amarelo
local sheet2 = graphics.newImageSheet( "images/bird1.png", { width=125, height=125, numFrames=4 } )

--Cria o sprite do pássaro amarelo
local instance2 = display.newSprite( sheet2, { name="bird", start=1, count=4, time=500 } ) 
  instance2.x = _W - 90
  instance2.y = _H/2 + 240
  instance2.rotation = 20
  instance2:play()    

return scene	