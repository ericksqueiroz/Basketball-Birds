-- Requisita o storyboard e cria uma nova cena
local storyboard = require("storyboard")
local scene = storyboard.newScene()
local start

_W = display.contentWidth 
_H = display.contentHeight

-- Adiciona música em loop
bgSound1 = audio.loadStream("sounds/menu.mp3")

function scene:createScene( event )
  local group = self.view

  --Adiciona o background
  local background = display.newImage("images/menubg.jpg")
    background.x = _W/2
    background.y = _H/2
    group:insert(background)  

  --Adiciona o logo 
  local logo = display.newImage("images/menu1.png")
    logo.x = _W/2
	  logo.y = 320
	  logo.xScale = 1.5
	  logo.yScale = 1.5
    group:insert(logo)

  --Adiciona o botão de start
  start = display.newImage("images/start.png")
	  start.x = _W/2 
	  start.y = _H/2 + 100
	  start.xScale = 0.4
	  start.yScale = 0.4	
    group:insert(start)

  --Adiciona o botão de como jogar
  htoplay = display.newImage("images/howtoplay.png")
    htoplay.x = _W/2 
    htoplay.y = _H/2 + 230
    htoplay.xScale = 0.4
    htoplay.yScale = 0.4  
    group:insert(htoplay)  

  --Adiciona o botão de creditos
  credits = display.newImage("images/credits.png")
    credits.x = _W/2 
    credits.y = _H/2 + 360
    credits.xScale = 0.4
    credits.yScale = 0.4  
    group:insert(credits)      

  --Adiciona o botão de ferramentas
  local settings = display.newImage("images/settings.png")
    settings.x = _W-35
    settings.y = _H-35
    settings.xScale = 0.5
    settings.yScale = 0.5
    group:insert(settings)

  --Adiciona o menu de ferramentas
  local settingsbg = display.newImage("images/settingsbg.png")
    settingsbg.x = _W/2
    settingsbg.y = _H/2 + 130 
    settingsbg.xScale = 0.9
    settingsbg.yScale = 0.9
    settingsbg.alpha = 0
    group:insert(settingsbg)

  local soundon = display.newImage("images/soundon.png")  
    soundon.x = _W/2
    soundon.y = _H/2 + 150
    soundon.xScale = 2
    soundon.yScale = 2
    soundon.alpha = 0
    group:insert(soundon)

  local soundoff = display.newImage("images/soundoff.png")  
    soundoff.x = _W/2
    soundoff.y = _H/2 + 150
    soundoff.xScale = 2
    soundoff.yScale = 2
    soundoff.alpha = 0 
    group:insert(soundoff)

  local function muteGame()  
    sound = false
    soundon.alpha = 0
    soundoff.alpha = 1
    audio.pause()
  end 
  soundon:addEventListener("tap", muteGame)

  local function unmuteGame()
    sound = true  
    soundon.alpha = 1
    soundoff.alpha = 0
    audio.resume()
    mySong1 = audio.play( bgSound1, { channel = 1, loops = -1 } )
  end 
  soundoff:addEventListener("tap", unmuteGame)

  function settingsMenu()
    if sound == true then
      soundon.alpha = 1
      soundoff.alpha = 0
    end
    if sound == false then
      soundon.alpha = 0
      soundoff.alpha = 1
    end  
    if settingsbg.alpha == 0 then
      settingsbg.alpha = 1 
      start.alpha = 0
      htoplay.alpha = 0
      credits.alpha = 0
    else  
      settingsbg.alpha = 0
      start.alpha = 1
      htoplay.alpha = 1
      credits.alpha = 1
      soundon.alpha = 0
      soundoff.alpha = 0
    end 
  end
  settings:addEventListener("tap", settingsMenu)   

  --Adiciona o pássaro cinza
  local sheet1 = graphics.newImageSheet( "images/bird0.png", { width=125, height=125, numFrames=4 } )

  --Cria o sprite do pássaro cinza
  local instance1 = display.newSprite( sheet1, { name="bird", start=1, count=4, time=500 } ) 
    instance1.x = 90
    instance1.y = _H/2 + 200
    instance1.rotation = -20
    instance1:play() 
    group:insert(instance1) 

  --Adiciona o pássaro amarelo
  local sheet2 = graphics.newImageSheet( "images/bird1.png", { width=125, height=125, numFrames=4 } )

  --Cria o sprite do pássaro amarelo 
  local instance2 = display.newSprite( sheet2, { name="bird", start=1, count=4, time=500 } ) 
    instance2.x = _W - 90
    instance2.y = _H/2 + 200
    instance2.rotation = 20
    instance2:play() 
    group:insert(instance2)   
  end   

  local function start_game()
    storyboard.gotoScene("game", transicaoCena)
  end	 

  local function goto_htoplay()
    storyboard.gotoScene("howtoplay", transicaoCena)
  end  

  local function goto_credits()
    storyboard.gotoScene("credit", transicaoCena)
end  

function scene:enterScene( event )
  start:addEventListener("tap", start_game)
  htoplay:addEventListener("tap", goto_htoplay)
  credits:addEventListener("tap", goto_credits)
  storyboard.removeScene("game")
  storyboard.removeScene("score")
  storyboard.removeScene("howtoplay")
  storyboard.removeScene("credit")
  if sound == true then 
    mySong1 = audio.play( bgSound1, { channel = 1, loops = -1 } )
  end  
end

function scene:exitScene( event )
  start:removeEventListener("tap", start_game)
  htoplay:removeEventListener("tap", goto_htoplay)
  credits:removeEventListener("tap", goto_credits) 
end

-- Recebe os metodos criados
scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )

return scene	