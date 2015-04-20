--Adiciona física e gravidade
local fisica = require("physics")
fisica.start()
--fisica.setDrawMode("hybrid")

--Requisita o storyboard e cria uma nova cena
local storyboard = require("storyboard")
local scene = storyboard.newScene()

_W = display.contentWidth 
_H = display.contentHeight

system.activate("multitouch")

--Adiciona som ao game
bgSound = audio.loadStream("sounds/game.mp3")
mySong = audio.play(bgSound)

--Adiciona o background
local background = display.newImage("images/background.jpg")
	background.x = _W/2
	background.y = _H/2

--Adiciona imagens de valores às cestas
local um = display.newImage("images/1.png")
  um.x = _W-405
  um.y = _H-450
  um.alpha = 0.3   

local dois = display.newImage("images/2.png")
  dois.x = _W-150
  dois.y = _H/2-160
  dois.alpha = 0.3  

local tres = display.newImage("images/3.png")
  tres.x = _W-399
  tres.y = 100
  tres.alpha = 0.3  

--Adiciona o botão de pausa
local pause = display.newImage("images/pause.png")
  pause.x = _W-30
  pause.y = _H-30
  pause.xScale = 0.7
  pause.yScale = 0.7

--Adiciona física de pontuação das cestas
local fisicacesta1 = display.newRect (_W-399, _H/5-30, 90, 0)  
  fisica.addBody(fisicacesta1, "kinematic")
  fisicacesta1.isSensor = true    

local fisicacesta2 = display.newRect (_W-150, _H-550-30 , 90, 0)  
  fisica.addBody(fisicacesta2, "kinematic")
  fisicacesta2.isSensor = true    

local fisicacesta3 = display.newRect (_W-399, _H-350-30, 90, 0)  
  fisica.addBody(fisicacesta3, "kinematic")
  fisicacesta3.isSensor = true  

--Fisica da parte de baixo das cestas
local fisicabaixo1 = display.newRect (_W-399, _H/5+50, 90, 0)  
  fisica.addBody(fisicabaixo1, "static")

local fisicabaixo2 = display.newRect (_W-150, _H/2-20, 90, 0)  
  fisica.addBody(fisicabaixo2, "static")

local fisicabaixo3 = display.newRect (_W-399, _H-300, 90, 0)  
  fisica.addBody(fisicabaixo3, "static")  

local ballfloor = display.newRect (_W/2, _H-100, 90, 0)  
  physics.addBody(ballfloor, "static") 
  ballfloor.isSensor = false                            

--Adiciona o contador de score
local score = 0
local scoreNumber = display.newText(score, 145, _H-23, sansSerif, 40)
local scoreText = display.newText("Score:", 65, _H-25, sansSerif, 40)

--Adiciona as paredes, o chão e o teto
local chao = display.newRect (0, _H, _W*2, 0)
	fisica.addBody(chao, "static")

local teto = display.newRect (0, 0, _W*2, 0)
	fisica.addBody(teto, "static")	

local esquerda = display.newRect (0, 0, 0, _H*2)
	fisica.addBody(esquerda, "static")

local direita = display.newRect (_W, 0, 0, _H*2)
	fisica.addBody(direita, "static")

--Adiciona a bola de basquete
local ball = display.newImage("images/ball.png")
  fisica.addBody(ball, "dynamic", {radius = 30, density=0.05, friction=1, bounce=0.5})
  ball.x = _W/2   
  ball.y = _H-130 
  ball.xScale = 0.7
  ball.yScale = 0.7 

--Função que incrementa a pontuação das cestas  
local function onLocalCollision( self, event )
  if ( event.phase == "began" ) then
    if event.other == fisicacesta1 then
        scoreNumber.text = tostring(tonumber(scoreNumber.text) + 3)
        fisicabaixo1.isSensor = true
    end
    if event.other == fisicacesta2 then
        scoreNumber.text = tostring(tonumber(scoreNumber.text) + 2)
        fisicabaixo2.isSensor = true
    end
    if event.other == fisicacesta3 then
        scoreNumber.text = tostring(tonumber(scoreNumber.text) + 1 )
        fisicabaixo3.isSensor = true
    end
    if event.other == chao then
      fisicabaixo1.isSensor = false
      fisicabaixo2.isSensor = false
      fisicabaixo3.isSensor = false
      ballfloor.isSensor = false
      timer.performWithDelay( 300, resetaBola)
      ball:setLinearVelocity( 0, 0 )
      ball.angularVelocity = 0
    end 
  end  
end
ball.collision = onLocalCollision
ball:addEventListener( "collision", ball )  

--Física da cesta
local physics_body = {}
physics_body["basket"] = {
    {
        --LeftArm
        density = 10, friction = 10, bounce = 0.15, 
        shape = {-40, 50, -55, 50, -60, -55, -80, -55}
    },
    {
        --RightArm
        density = 10, friction = 10, bounce = 0.15, 
        shape = {40, 50, 55, 50, 60, -55, 80, -55}
    }
}  

--Adiciona as cestas de basquete
local basket = display.newImage("images/basket.png")
	fisica.addBody(basket, "static", unpack(physics_body["basket"]))
  basket.x = _W-399
	basket.y = _H/5

local basket2 = display.newImage("images/basket.png")
	fisica.addBody(basket2, "static", unpack(physics_body["basket"]))
  basket2.x = _W-150
	basket2.y = _H-550  

local basket3 = display.newImage("images/basket.png")
	fisica.addBody(basket3, "static", unpack(physics_body["basket"]))
  basket3.x = _W-399
	basket3.y = _H-350

--Adiciona o pássaro vermelho
local sheet1 = graphics.newImageSheet( "images/bird2.png", { width=125, height=85, numFrames=4 } )

--Cria o sprite do pássaro vermelho
local instance1 = display.newSprite( sheet1, { name="bird", start=1, count=4, time=500 } )
  fisica.addBody(instance1, "static", {radius=40, density=0, friction=1, bounce=0.5})
  instance1.y = _H/2+30
  instance1.xScale = 0.9
  instance1.yScale = 0.9
  instance1:play()

local function move_bird( bird )
  instance1.x = -500
  transition.to( instance1, {x=400+800, time=7000, onComplete=move_bird} )
end
move_bird( instance1 )

--Adiciona o pássaro azul
local sheet2 = graphics.newImageSheet( "images/bird3.png", { width=125, height=85, numFrames=4 } )

--Cria o sprite do pássaro azul
local instance2 = display.newSprite( sheet2, { name="bird2", start=1, count=4, time=500 } )
  fisica.addBody(instance2, "static", {radius=40, density=0, friction=1, bounce=0.5})
  instance2.y = _H/2-180
  instance2.xScale = 0.9
  instance2.yScale = 0.9
  instance2:play()

local function move_bird2( bird )
  instance2.x = _W+100
  transition.to( instance2, {x=400-800, time=7000, onComplete=move_bird2} )
end
move_bird2( instance2 )

--Funcao para resetar a bola:
  function resetaBola()
    ball.x = _W/2 
    ball.y = _H - 130
  end

--Função para atirar a bola
  function ball:touch(event)

    local t = event.target
    local phase = event.phase

    if event.phase == "began" then

      display.getCurrentStage():setFocus( t )
      t.isFocus = true
    
      local showTarget = transition.to( target, { alpha=0.4, xScale=0.4, yScale=0.4, time=200 } )
      myLine = nil

    elseif t.isFocus then
    
      if event.phase == "moved" then
  
        if ( myLine ) then
          myLine.parent:remove( myLine )
        end
      myLine = display.newLine( t.x,t.y, event.x,event.y )
      myLine:setStrokeColor( 1, 1, 1, 50/255 )
      myLine.strokeWidth = 10

    elseif event.phase == "ended" or event.phase == "cancelled" then
      
      display.getCurrentStage():setFocus( nil )
      t.isFocus = false
            
        if ( myLine ) then
          myLine.parent:remove( myLine )
          ballfloor.isSensor = true 
        end
          
      --Golpei a bola:
      local ballforce
        t:applyForce( (t.x - event.x), (t.y - event.y), t.x, t.y )
      end
    end
    return true
  end
  ball:addEventListener("touch", ball)

--Adiciona o menu de pause
local pausebg = display.newImage("images/pausebg.png")
  pausebg.x = _W/2
  pausebg.y = _H/2
  pausebg.xScale = 0.8
  pausebg.yScale = 0.8
  pausebg.alpha = 0

local resume = display.newImage("images/resume.png")
  resume.x = _W/2
  resume.y = _H/3
  resume.xScale = 0.4
  resume.yScale = 0.4
  resume.alpha = 0

local restart = display.newImage("images/restart.png")
  restart.x = _W/2
  restart.y = _H/2-30
  restart.xScale = 0.4
  restart.yScale = 0.4
  restart.alpha = 0

local menu = display.newImage("images/menu.png")
  menu.x = _W/2
  menu.y = _H/2+100
  menu.xScale = 0.4
  menu.yScale = 0.4
  menu.alpha = 0

local soundon = display.newImage("images/soundon.png")
  soundon.x = _W/2
  soundon.y = _H/2+250
  soundon.xScale = 0.9
  soundon.yScale = 0.9
  soundon.alpha = 0  

local soundoff = display.newImage("images/soundoff.png")
  soundoff.x = _W/2
  soundoff.y = _H/2+250
  soundoff.xScale = 0.9
  soundoff.yScale = 0.9
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

--Variável de pausa
local paused = false

--Função para pausar o jogo
local function pauseGame()
  if paused == false then   
    physics.pause()
    transition.pause()
    instance1:pause()
    instance2:pause()    
    pausebg.alpha = 1
    resume.alpha = 1
    restart.alpha = 1
    menu.alpha = 1
    soundon.alpha = 1
    audio.stop()
    paused = true 
  end 
end 
pause:addEventListener("tap", pauseGame)

--Função para despausar o jogo
local function resumeGame()
  if paused == true then  
    physics.start()
    transition.resume() 
    instance1:play()  
    instance2:play()
    pausebg.alpha = 0
    resume.alpha = 0
    restart.alpha = 0 
    menu.alpha = 0
    soundon.alpha = 0
    soundoff.alpha = 0
    audio.play(bgSound)
    paused = false
  end
end
resume:addEventListener("tap", resumeGame)

--Adiciona o cronômetro
local tempo = display.newText( "2:00", 0, 0, sansSerif, 50 )   
   tempo.x = _W/2
   tempo.y = _H/35
   
local number = 120
local modf = math.modf

function timerDown()
  number = number - 1
  local start_seconds = number

  local start_minutes = modf(start_seconds/60)
  local seconds       = start_seconds - start_minutes*60

  local start_hours = modf(start_minutes/60)
  local minutes     = start_minutes - start_hours*60

  local min = minutes < 10 and (minutes) or minutes
  local sec = seconds < 10 and ("0".. seconds) or seconds

  tempo.text = min .. ":" .. sec

  if number < 11 then
    tempo:setTextColor( 1, 0, 0 )
  end  

  if(number == 0)then
	  display.newText("TIME OUT", _W/2, _H/2, sansSerif, 100)
    display.newText("touch to continue", _W/2, _H/2+60, sansSerif, 40)
    display.remove(instance1)
    display.remove(instance2)
    display.remove(ball)
    display.remove(basket)
    display.remove(basket2)
    display.remove(basket3)
    Runtime:removeEventListener("touch", onTouch)
    pause:removeEventListener("tap", pauseGame)
    pausebg.alpha = 0
    resume.alpha = 0
    restart.alpha = 0
    menu.alpha = 0
    soundon.alpha = 0
    soundoff.alpha = 0
    um.alpha = 0
    dois.alpha = 0
    tres.alpha = 0
    audio.stop()
   end
end
timer.performWithDelay(1000, timerDown, number)

return scene











