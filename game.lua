--Adiciona física e gravidade
local fisica = require("physics")
fisica.start()
physics.setGravity( 0, 15 )
--fisica.setDrawMode("hybrid")

--Requisita o storyboard e cria uma nova cena
local storyboard = require("storyboard")
local scene = storyboard.newScene()

_W = display.contentWidth 
_H = display.contentHeight

--Adiciona som ao game
bgSound = audio.loadStream("sounds/game.mp3")

function scene:createScene(event)
  local group = self.view

  --Adiciona o background
  local background = display.newImage("images/background.jpg")
    background.x = _W/2
    background.y = _H/2
    group:insert(background)

  --Adiciona o botão de pausa e de som
  local pause = display.newImage("images/pause.png")
    pause.x = _W-30
    pause.y = _H-30
    group:insert(pause)

  local soundon = display.newImage("images/soundon.png")
    soundon.x = _W-90
    soundon.y = _H-30
    soundon.alpha = 1  
    group:insert(soundon)

  local soundoff = display.newImage("images/soundoff.png")
    soundoff.x = _W-90
    soundoff.y = _H-30
    soundoff.alpha = 0  
    group:insert(soundoff)

  --Adiciona física de pontuação das cestas
  local fisicacesta1 = display.newRect (80, _H/5+20, 90, 0)  
    fisica.addBody(fisicacesta1, "kinematic")
    fisicacesta1.isSensor = true
    group:insert(fisicacesta1)    

  local fisicacesta2 = display.newRect (_W-80, _H-550+20 , 90, 0)  
    fisica.addBody(fisicacesta2, "kinematic")
    fisicacesta2.isSensor = true    
    group:insert(fisicacesta2)

  local fisicacesta3 = display.newRect (80, _H-350+20, 90, 0)  
    fisica.addBody(fisicacesta3, "kinematic")
    fisicacesta3.isSensor = true 
    group:insert(fisicacesta3) 

  --Fisica da parte de baixo das cestas
  local fisicabaixo1 = display.newRect (80, _H/5+90, 70, 0)  
    fisica.addBody(fisicabaixo1, "static")
    group:insert(fisicabaixo1)

  local fisicabaixo2 = display.newRect (_W-80, _H/2+20, 70, 0)  
    fisica.addBody(fisicabaixo2, "static")
    group:insert(fisicabaixo2)

  local fisicabaixo3 = display.newRect (80, _H/2+220, 70, 0)  
    fisica.addBody(fisicabaixo3, "static")
    group:insert(fisicabaixo3)  

  local ballfloor = display.newRect (_W/2, _H-100, 90, 0)  
    physics.addBody(ballfloor, "static") 
    ballfloor.isSensor = false  
    group:insert(ballfloor)                          

  --Adiciona o contador de score
  local score = 0
  scoreFinal = 0
  scoreNumber = display.newText(score, 142, _H-23, "Digital-7", 50)
    group:insert(scoreNumber)
  scoreText = display.newText("Score:", 65, _H-21, "Digital-7", 40)
    group:insert(scoreText)

  --Adiciona as paredes, o chão e o teto
  local chao = display.newRect (0, _H, _W*2, 0)
    fisica.addBody(chao, "static")
    group:insert(chao)

  local teto = display.newRect (0, 0, _W*2, 0)
    fisica.addBody(teto, "static")	
    group:insert(teto)

  local esquerda = display.newRect (0, 0, 0, _H*2)
    fisica.addBody(esquerda, "static")
    group:insert(esquerda)

  local direita = display.newRect (_W, 0, 0, _H*2)
    fisica.addBody(direita, "static")
    group:insert(direita)

  --Adiciona a bola de basquete
  local ball = display.newImage("images/ball.png")
    fisica.addBody(ball, "dynamic", {radius = 30, density=0.04, friction=1, bounce=0.5})
    ball.x = _W/2   
    ball.y = _H-130 
    ball.xScale = 0.7
    ball.yScale = 0.7 
    group:insert(ball)

  --Física da cesta
  local physics_body = {}
    physics_body["basket"] = {
      {
        --LeftArm
        density = 10, friction = 10, bounce = 0.15, 
        shape = {-35, 90, -35, 90, -60, -19, -70, -19}
      },
      {
        --RightArm
        density = 10, friction = 10, bounce = 0.15, 
        shape = {35, 90, 35, 90, 60, -19, 70, -19}
      }
    }  

  --Adiciona as cestas de basquete
  local basket = display.newImage("images/basket3.png")
  	fisica.addBody(basket, "static", unpack(physics_body["basket"]))
    basket.x = 80
    basket.y = _H/5
    group:insert(basket)

  local basket2 = display.newImage("images/basket2.png")
    fisica.addBody(basket2, "static", unpack(physics_body["basket"]))
    basket2.x = _W-80
	  basket2.y = _H-550 
    group:insert(basket2) 

  local basket3 = display.newImage("images/basket.png")
  	fisica.addBody(basket3, "static", unpack(physics_body["basket"]))
    basket3.x = 80
  	basket3.y = _H-350
    group:insert(basket3)

  --Função para movimentar as cestas
  local function move_linha1()
    local move_linhaback1 = function()
      transition.to( fisicacesta1, {x=80, time=2000, onComplete=move_linha1} )
    end
      transition.to( fisicacesta1, {x=_W-80, time=2000, onComplete=move_linhaback1} )
  end
  move_linha1( fisicacesta1 )

  local function move_linhabaixo1()
    local move_linhabaixoback1 = function()
      transition.to( fisicabaixo1, {x=80, time=2000, onComplete=move_linhabaixo1} )
    end
      transition.to( fisicabaixo1, {x=_W-80, time=2000, onComplete=move_linhabaixoback1} )
  end
  move_linhabaixo1( fisicabaixo1 )

  local function move_basket1()
    local move_basketback1 = function()
      transition.to( basket, {x=80, time=2000, onComplete=move_basket1} )
    end
      transition.to( basket, {x=_W-80, time=2000, onComplete=move_basketback1} )
  end
  move_basket1( basket1 )  
  -----------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------
  local function move_linha2()
    local move_linhaback2 = function()
      transition.to( fisicacesta2, {x=_W-80, time=3000, onComplete=move_linha2} )
    end
      transition.to( fisicacesta2, {x=80, time=3000, onComplete=move_linhaback2} )
  end
  move_linha2()  

  local function move_linhabaixo2()
    local move_linhabaixoback2 = function()
      transition.to( fisicabaixo2, {x=_W-80, time=3000, onComplete=move_linhabaixo2} )
    end
      transition.to( fisicabaixo2, {x=80, time=3000, onComplete=move_linhabaixoback2} )
  end
  move_linhabaixo2() 

  local function move_basket2()
    local move_basketback2 = function()
      transition.to( basket2, {x=_W-80, time=3000, onComplete=move_basket2} )
    end
      transition.to( basket2, {x=80, time=3000, onComplete=move_basketback2} )
  end
  move_basket2()  
  -----------------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------------- 
  local function move_linha3()
    local move_linhaback3 = function()
      transition.to( fisicacesta3, {x=80, time=3000, onComplete=move_linha3} )
    end
      transition.to( fisicacesta3, {x=_W-80, time=3000, onComplete=move_linhaback3} )
  end
  move_linha3() 

  local function move_linhabaixo3()
    local move_linhabaixoback3 = function()
      transition.to( fisicabaixo3, {x=80, time=3000, onComplete=move_linhabaixo3} )
    end
      transition.to( fisicabaixo3, {x=_W-80, time=3000, onComplete=move_linhabaixoback3} )
  end
  move_linhabaixo3()

  local function move_basket3()
    local move_basketback3 = function()
      transition.to( basket3, {x=80, time=3000, onComplete=move_basket3} )
    end
      transition.to( basket3, {x=_W-80, time=3000, onComplete=move_basketback3} )
  end
  move_basket3() 
  -----------------------------------------------------------------------------------------
  -----------------------------------------------------------------------------------------
  --Adiciona o pássaro vermelho
  local sheet1 = graphics.newImageSheet( "images/bird2.png", { width=125, height=85, numFrames=4 } )

  --Cria o sprite do pássaro vermelho
  local instance1 = display.newSprite( sheet1, { name="bird", start=1, count=4, time=500 } )
    fisica.addBody(instance1, "static", {radius=40, density=0, friction=1, bounce=0.5})
    instance1.y = _H/2+70
    instance1.xScale = 0.9
    instance1.yScale = 0.9
    instance1:play()
    group:insert(instance1)

  local function move_bird( bird )
    if instance1.alpha == 0 then
      instance1.alpha = 1
    end  
    instance1.rotation = -5
    instance1.x = -500
    transition.to( instance1, {x=400+800, time=7000, onComplete=move_bird} )
  end
  move_bird( instance1 )

  --Adiciona o pássaro azul
  local sheet2 = graphics.newImageSheet( "images/bird3.png", { width=125, height=85, numFrames=4 } )

  --Cria o sprite do pássaro azul
  local instance2 = display.newSprite( sheet2, { name="bird2", start=1, count=4, time=500 } )
    fisica.addBody(instance2, "static", {radius=40, density=0, friction=1, bounce=0.5})
    instance2.y = _H/2-150
    instance2.xScale = 0.9
    instance2.yScale = 0.9
    instance2:play()
    group:insert(instance2)

  local function move_bird2( bird )
    if instance2.alpha == 0 then
      instance2.alpha = 1
    end  
    instance2.rotation = 5
    instance2.x = _W+100
    transition.to( instance2, {x=400-800, time=7000, onComplete=move_bird2} )
  end
  move_bird2( instance2 )

  --Função que incrementa a pontuação das cestas e adiciona evento de colisão dos pássaros  
  local function onLocalCollision( self, event )
    if ( event.phase == "began" ) then
      if event.other == fisicacesta1 then
          scoreNumber.text = tostring(tonumber(scoreNumber.text) + 3)
          scoreFinal = tonumber(scoreNumber.text)
          fisicabaixo1.isSensor = true
      end
      if event.other == fisicacesta2 then
          scoreNumber.text = tostring(tonumber(scoreNumber.text) + 2)
          scoreFinal = tonumber(scoreNumber.text)
          fisicabaixo2.isSensor = true
      end
      if event.other == fisicacesta3 then
          scoreNumber.text = tostring(tonumber(scoreNumber.text) + 1 )
          scoreFinal = tonumber(scoreNumber.text)
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
        ball:addEventListener("touch", ball)
      end 
      if event.other == instance2 then
        transition.cancel(instance2)
        local function animate( event )
          transition.to( instance2, { rotation = instance2.rotation +720, time=1000, onComplete=move_bird2 } )
          transition.to( instance2, {alpha = 0, time=700})
          deadbird2 = audio.loadStream("sounds/deadbird2.mp3")
          Song = audio.play(deadbird2)
        end
        animate()
      end 
      if event.other == instance1 then
        transition.cancel(instance1)
        local function animate( event )
          transition.to( instance1, { rotation = instance1.rotation +720, time=1000, onComplete=move_bird } )
          transition.to( instance1, {alpha = 0, time=700})
          deadbird = audio.loadStream("sounds/deadbird.mp3")
          Song = audio.play(deadbird)
        end
        animate()
      end 
    end  
  end
  ball.collision = onLocalCollision
  ball:addEventListener( "collision", ball )  

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
          ball:removeEventListener("touch", ball)
        end
          
      --Golpeia a bola:
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
    group:insert(pausebg)

  local resume = display.newImage("images/resume.png")
    resume.x = _W/2
    resume.y = _H/3-30
    resume.xScale = 0.4
    resume.yScale = 0.4
    resume.alpha = 0
    group:insert(resume)

  local restart = display.newImage("images/restart.png")
    restart.x = _W/2
    restart.y = _H/2-60
    restart.xScale = 0.4
    restart.yScale = 0.4
    restart.alpha = 0
    group:insert(restart)

  local menu = display.newImage("images/menu.png")
    menu.x = _W/2
    menu.y = _H/2+70
    menu.xScale = 0.4
    menu.yScale = 0.4
    menu.alpha = 0
    group:insert(menu)

  --Função para tirar o som no menu de pause
  sound = true
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
  end 
  soundoff:addEventListener("tap", unmuteGame)

  --Funções que leva a tela de jogo de volta para o menu e restart
  function game_menu()
    storyboard.gotoScene("menu")
  end
  menu:addEventListener("tap",game_menu)

  local function game_restart()
    storyboard.gotoScene("score")
  end
  restart:addEventListener("tap", game_restart)

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
      background.alpha = 0.5
      basket.alpha = 0.5
      basket2.alpha = 0.5
      basket3.alpha = 0.5
      instance1.alpha = 0.5
      instance2.alpha = 0.5
      ball.alpha = 0.5
      audio.stop()
      paused = true 
      timer.pause(timerDown)
      ball:removeEventListener("touch", ball)
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
      background.alpha = 1
      basket.alpha = 1
      basket2.alpha = 1
      basket3.alpha = 1
      instance1.alpha = 1
      instance2.alpha = 1
      ball.alpha = 1
      audio.play(bgSound)
      paused = false
      timer.resume(timerDown)
      ball:addEventListener("touch", ball)
    end
    if sound == false then
      audio.pause()
    end
  end
  resume:addEventListener("tap", resumeGame)

  --Adiciona o cronômetro
  local tempo = display.newText( "2:00", 0, 0, "Digital-7", 70 )   
    tempo.x = _W/2
    tempo.y = 30
    group:insert(tempo)
   
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
    group:insert(tempo)

    function countdown_red()
      if number == 10 then
        tempo:setTextColor( 1, 0, 0 )  
          if sound == true then
            countdown = audio.loadStream("sounds/contagem.mp3")
            Song = audio.play(countdown)
          end
      end 
    end
    countdown_red()

  if(number == 0)then
	  local timeout = display.newText("TIME OUT", _W/2, _H/2, "Digital-7", 150)
    group:insert(timeout)
    local continue = display.newText("Touch to continue", _W/2, _H/2+100, "Digital-7", 50)
    group:insert(continue)
    display.remove(instance1)
    display.remove(instance2)
    display.remove(ball)
    display.remove(basket)
    display.remove(basket2)
    display.remove(basket3) 
    display.remove(um)
    display.remove(dois)
    display.remove(tres)
    display.remove(fisicacesta1)
    display.remove(fisicabaixo1)
    display.remove(fisicacesta2)
    display.remove(fisicabaixo2)
    display.remove(fisicacesta3)
    display.remove(fisicabaixo3)
    display.remove(fisicacesta1)
    display.remove(ballfloor)
    display.remove(myLine)
    pause:removeEventListener("tap", pauseGame)
    soundon:removeEventListener("tap", muteGame)
    soundoff:removeEventListener("tap", muteGame)
    audio.stop()
    function goto_score()
      storyboard.gotoScene("score", transicaoCena)
    end
    Runtime:addEventListener("tap", goto_score)
    end
  end
  timerDown = timer.performWithDelay(1000, timerDown, number)  
end

function scene:enterScene(event)
  local group = self.view;
    audio.stop()
    storyboard.removeScene("menu")
    storyboard.removeScene("score") 
    BgSoundChannelGame = audio.play(bgSound, {channel = 4, loops = -1}); 
end

function scene:exitScene(event)
  local group = self.view
    display.remove(instance1)
    display.remove(instance2)
    display.remove(ball)
    display.remove(basket)
    display.remove(basket2)
    display.remove(basket3)
    display.remove(um)
    display.remove(dois)
    display.remove(tres)
    display.remove(fisicacesta1)
    display.remove(fisicabaixo1)
    display.remove(fisicacesta2)
    display.remove(fisicabaixo2)
    display.remove(fisicacesta3)
    display.remove(fisicabaixo3)
    display.remove(fisicacesta1)
    display.remove(ballfloor)
    display.remove(myLine)
    Runtime:removeEventListener("tap", goto_score)
    audio.stop();
end

--Recebe os metodos criados
scene:addEventListener("createScene", scene)

scene:addEventListener("enterScene", scene)

scene:addEventListener("exitScene", scene)

return scene











