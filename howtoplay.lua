--Requisita o storyboard e cria uma nova cena
local storyboard = require("storyboard")
local scene = storyboard.newScene()

--Adiciona física e gravidade
local fisica = require("physics")
fisica.start()
physics.setGravity( 0, 15 )
--fisica.setDrawMode("hybrid")

_W = display.contentWidth
_H = display.contentHeight

function scene:createScene( event )
  local group = self.view

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
 
  background = display.newImage("images/htoplaybg.jpg")
    background.x = _W/2
    background.y = _H/2 
    group:insert(background) 

  --Adiciona a bola e física de apoio
  ball = display.newImage("images/ball.png")
  	fisica.addBody(ball, "dynamic", {radius = 30, density=0.04, friction=1, bounce=0.5})
  	ball.x = _W/2   
  	ball.y = _H-130 
  	ball.xScale = 0.7
  	ball.yScale = 0.7
  	group:insert(ball)  

  local ballfloor = display.newRect (_W/2, _H-100, 90, 0)  
    physics.addBody(ballfloor, "static") 
    ballfloor.isSensor = false   
    group:insert(ballfloor) 

  finger = display.newImage("images/pointerfinger.png")
  	finger.x = _W/2 + 40
  	finger.y = _H - 100
  	finger.xScale = 1.5
  	finger.yScale = 1.5
  	finger.rotation = -40
  	group:insert(finger) 

  --Física da cesta
  local physics_body = {}
    physics_body["basket"] = {
      {
        --LeftArm
        density = 10, friction = 10, bounce = 0.15, 
        shape = {-35, 55, -35, 55, -60, -55, -70, -55}
      },
      {
        --RightArm
        density = 10, friction = 10, bounce = 0.15, 
        shape = {35, 55, 35, 55, 60, -55, 70, -55}
      }
    }  

  --Adiciona as cestas de basquete
  basket = display.newImage("images/htpbasket.png")
    fisica.addBody(basket, "static", unpack(physics_body["basket"]))
    basket.x = 80
    basket.y = _H/4 + 15
    group:insert(basket)

  --Adiciona física de pontuação da cesta
  local fisicacesta1 = display.newRect (80, _H/5+20, 90, 0)  
    fisica.addBody(fisicacesta1, "kinematic")
    fisicacesta1.isSensor = true
    group:insert(fisicacesta1)

  --Fisica da parte de baixo da cesta
  local fisicabaixo1 = display.newRect (80, _H/4+70, 70, 0)  
    fisica.addBody(fisicabaixo1, "static")
    fisicabaixo1.isSensor = false
    group:insert(fisicabaixo1)

  --Função de animação do tutorial
  function set_finger()
    finger.alpha = 1
    finger.y = _H - 100
    finger.xScale = 1.5
    finger.yScale = 1.5
    transition.to(finger, {xScale = 1, yScale = 1, time=900, onComplete=move_finger})
  end
  
  function move_finger()
  	myLine = display.newRect (_W/2, _H-130, 10, 0)
    myLine:setFillColor( 1, 1, 1, 50/255 ) 
    transition.to(myLine, {height=100, y=_H-80, time=500})
    transition.to(finger, {y=_H, time=500, onComplete=reset_finger})
  end

  function reset_finger()
    finger.alpha = 0
    move_ball()
    display.remove(myLine)
    ballfloor.isSensor = true
  end

  function move_ball() 
    ball:applyLinearImpulse( 0, -5, ball.x, ball.y)  
  end
  set_finger()  

  --Função de animação da cesta
  local function move_basket1()
    local move_basketback1 = function()
      transition.to( basket, {x=80, time=1700, onComplete=move_basket1} )
    end
      transition.to( basket, {x=_W-80, time=1700, onComplete=move_basketback1} )
  end

  move_basket1( basket1 )  
  local function move_linhabaixo1()
    local move_linhabaixoback1 = function()
      transition.to( fisicabaixo1, {x=80, time=1700, onComplete=move_linhabaixo1} )
    end
      transition.to( fisicabaixo1, {x=_W-80, time=1700, onComplete=move_linhabaixoback1} )
  end
  move_linhabaixo1( fisicabaixo1 ) 

  local function move_linha1()
    local move_linhaback1 = function()
      transition.to( fisicacesta1, {x=80, time=1700, onComplete=move_linha1} )
    end
      transition.to( fisicacesta1, {x=_W-80, time=1700, onComplete=move_linhaback1} )
  end
  move_linha1( fisicacesta1 )

  --Adiciona, cria e movimenta o pássaro azul
  local sheet2 = graphics.newImageSheet( "images/bird3.png", { width=125, height=85, numFrames=4 } )

  instance2 = display.newSprite( sheet2, { name="bird2", start=1, count=4, time=500 } )
    fisica.addBody(instance2, "static", {radius=40, density=0, friction=1, bounce=0.5})
    instance2.y = _H/2 + 20
    instance2.xScale = 0.9
    instance2.yScale = 0.9
    instance2:play()
    group:insert(instance2)

  local function move_bird2( bird )
    if instance2.alpha == 0 then
      instance2.alpha = 1
    end  
    instance2.isSensor = false
    instance2.rotation = 5
    instance2.x = _W+100
    transition.to( instance2, {x=-400, time=7000, onComplete=move_bird2} )
  end
  move_bird2( instance2 )

  --Função que reseta a bola para a posição inicial
  function resetaBola()
    ball.x = _W/2 
    ball.y = _H - 130
  end  

  --Função de colisão que aciona a cesta, elimina o pássaro e reseta a bola
  local function onLocalCollision( self, event )
    if ( event.phase == "began" ) then
      if event.other == fisicacesta1 then
        fisicabaixo1.isSensor = true
      end
      if event.other == chao then
        collision = true
        fisicabaixo1.isSensor = false
        ballfloor.isSensor = false
        um = timer.performWithDelay( 300, resetaBola, resetaBola)
        dois = timer.performWithDelay( 900, set_finger, set_finger)
        ball:setLinearVelocity( 0, 0 )
        ball.angularVelocity = 0
      end 
      if event.other == instance2 then
        transition.cancel(instance2)
        local function animate( event )
          instance2.isSensor = true
          transition.to( instance2, { rotation = instance2.rotation +720, time=1000, onComplete=move_bird2 } )
          transition.to( instance2, {alpha = 0, time=700})
        end
        animate()
      end  
    end  
  end
  ball.collision = onLocalCollision
  ball:addEventListener( "collision", ball )

  function goto_menu()
    storyboard.gotoScene("menu", transicaoCena)
  end	 
end

function scene:enterScene( event )
	
  Runtime:addEventListener("tap", goto_menu)
  storyboard.removeScene("menu")
end

function scene:exitScene( event )
  if collision == true then	
    timer.cancel(um)
    timer.cancel(dois)
  end
  transition.cancel()
  display.remove(finger)
  display.remove(myLine)
  display.remove(instance2)
  display.remove(basket)
  display.remove(ball)
  ball:removeEventListener("collision", ball )
  Runtime:removeEventListener("tap", goto_menu) 
end

-- Recebe os metodos criados
scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )

return scene	        