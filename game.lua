--Adiciona física e gravidade
local fisica = require("physics")
fisica.start()
fisica.setDrawMode("hybrid")

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

--Adiciona o botão de pausa
local pause = display.newImage("images/pause.png")
  pause.x = _W-30
  pause.y = _H-30
  pause.xScale = 0.7
  pause.yScale = 0.7

--Adiciona o contador de score
display.newText("Score: 0", 80, _H-25, sansSerif, 40)

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
  fisica.addBody(ball, "dynamic", {radius = 45, density=0, friction=1, bounce=0.5})
  ball.x = _W/2   
  ball.y = _H-50  

--Adiciona física ajustada ao personagem via physics editor
local physicsData = (require "basket_physics").physicsData(1.0)

--Adiciona as cestas de basquete
local basket = display.newImage("images/basket.png")
	fisica.addBody(basket, "static", {radius=0, density=0, friction=1, bounce=0.5}, physicsData:get("basket"))
	basket.y = _H/5

--Adiciona física ajustada ao personagem via physics editor
local physicsData = (require "basket2_physics").physicsData(1.0)  

local basket2 = display.newImage("images/basket.png")
	fisica.addBody(basket2, "static", {radius=0, density=0, friction=1, bounce=0.5}, physicsData:get("basket2"))
	basket2.y = _H-550

--Adiciona física ajustada ao personagem via physics editor
local physicsData = (require "basket3_physics").physicsData(1.0)    

local basket3 = display.newImage("images/basket.png")
	fisica.addBody(basket3, "static", {radius=0, density=0, friction=1, bounce=0.5}, physicsData:get("basket3"))
	basket3.y = _H-350

--Função para mover as cestas de basquete
local function move_basket( basket )
	basket.x = -100
	transition.to( basket, {x=0+_W+100, time=3000, onComplete=move_basket} )
end
move_basket( basket )

local function move_basket2( basket2 )
	basket2.x = _W+100
	transition.to( basket2, {x=400-800, time=6000, onComplete=move_basket2} )
end
move_basket2( basket2 )

local function move_basket3( basket3 )
	basket3.x = -100
	transition.to( basket3, {x=0+800, time=10000, onComplete=move_basket3} )
end
move_basket3( basket3 )

--Adiciona o pássaro vermelho
local sheet1 = graphics.newImageSheet( "images/bird2.png", { width=125, height=125, numFrames=4 } )

--Cria o sprite do pássaro vermelho
local instance1 = display.newSprite( sheet1, { name="bird", start=1, count=4, time=500 } )
  fisica.addBody(instance1, "static", {radius=50, density=0, friction=1, bounce=0.5})
  instance1.y = _H/2+50
  instance1:play()

local function move_bird( bird )
  instance1.x = -100
  transition.to( instance1, {x=400+800, time=7000, onComplete=move_bird} )
end
move_bird( instance1 )

--Adiciona o pássaro azul
local sheet2 = graphics.newImageSheet( "images/bird3.png", { width=125, height=125, numFrames=4 } )

--Cria o sprite do pássaro azul
local instance2 = display.newSprite( sheet2, { name="bird2", start=1, count=4, time=500 } )
  fisica.addBody(instance2, "static", {radius=50, density=0, friction=1, bounce=0.5})
  instance2.y = _H/2-150
  instance2:play()

local function move_bird2( bird )
  instance2.x = _W+100
  transition.to( instance2, {x=400-800, time=7000, onComplete=move_bird2} )
end
move_bird2( instance2 )

--Função para arrastar a bola (função temporária)
local function drag( event )
    local ball = event.target
     
    local phase = event.phase
    if "began" == phase then
      display.getCurrentStage():setFocus( ball )
 
      -- Store initial position
      ball.x0 = event.x - ball.x
      ball.y0 = event.y - ball.y
         
      -- Avoid gravitational forces
      event.target.bodyType = "kinematic"
         
      -- Stop current motion, if any
      event.target:setLinearVelocity( 0, 0 )
      event.target.angularVelocity = 0
 
    else
        if "moved" == phase then
          ball.x = event.x - ball.x0
          ball.y = event.y - ball.y0
        elseif "ended" == phase or "cancelled" == phase then
          display.getCurrentStage():setFocus( nil )
          event.target.bodyType = "dynamic"
        end
    end
 
    return true
end
ball:addEventListener("touch", drag)

--Função para aplicar um impulso linear na bola de basquete
local onTouch = function (event)
	if event.phase == "began" then		
		ball:applyLinearImpulse (0, -3, event.x, event.y)
		return true
	end	
end	
Runtime:addEventListener("touch", onTouch)

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
    Runtime:addEventListener("touch", onTouch) 
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
   tempo:setTextColor( 255, 255, 255 )

local number = 120
local modf = math.modf

function timerDown()
  number = number - 1
  local start_seconds = number

  local start_minutes = modf(start_seconds/60)
  local seconds       = start_seconds - start_minutes*60

  local start_hours = modf(start_minutes/60)
  local minutes     = start_minutes - start_hours*60

  local start_days  = modf(start_hours/24)
  local hours       = start_hours - start_days*24

  local min = minutes < 10 and (minutes) or minutes
  local sec = seconds < 10 and ("0".. seconds) or seconds

  tempo.text = min .. ":" .. sec

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
    audio.stop(1)
   end
end
timer.performWithDelay(1000, timerDown, number)

return scene











