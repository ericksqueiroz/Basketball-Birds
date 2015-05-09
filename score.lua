_W = display.contentWidth
_H = display.contentHeight


--Requisita o storyboard e cria uma nova cena
local storyboard = require("storyboard")
local scene = storyboard.newScene()

--Adiciona som ao game
bgSound = audio.loadStream("sounds/score.mp3")
mySong = audio.play(bgSound, { channel = 1, loops = -1 })

function scene:createScene(event)
  local group = self.view

  --Adiciona o background
  local background = display.newImage("images/menubg.jpg")
	  background.x = _W/2
    background.y = _H/2
    group:insert(background)

  --Cria "Your Score" e aplica efeito de pulsação
  scores = display.newText("Your Score", _W/2, 150, "DS-Digital", 80)
    group:insert(scores)

  function movescoreUp()
	  transition.to(scores, {time = 1000, alpha = 1, x = (_W/2), y = (150), xScale = 1.35, yScale = 1.35, onComplete = movescoreDown});
  end

  function movescoreDown()
	  scores.alpha = 1;
	  transition.to(scores, {time = 1000, alpha = 1, x = (_W/2), y = (150), xScale = 1, yScale = 1, onComplete = movescoreUp});
  end
  movescoreUp();

  scoreFinal = (scoreFinal)
  pontuacaoFinal = display.newText(scoreFinal, _W/2, _H/2-200, "DS-Digital", 150)
    group:insert(pontuacaoFinal)

  --Adiciona o pássaro vermelho
  local sheet1 = graphics.newImageSheet( "images/deadbird1.png", { width=125, height=85, numFrames=4 } )

  --Cria o sprite do pássaro vermelho
  deadbird1 = display.newSprite( sheet1, { name="bird", start=1, count=4, time=500 } )
    deadbird1.x = _W/2 - 160
    deadbird1.y = _H/2 - 180
    deadbird1.xScale = 1.3
    deadbird1.yScale = 1.3
    deadbird1.rotation = -10
    deadbird1:play()
    group:insert(deadbird1)

  --Adiciona o pássaro azul
  local sheet2 = graphics.newImageSheet( "images/deadbird2.png", { width=125, height=85, numFrames=4 } )

  --Cria o sprite do pássaro azul
  deadbird2 = display.newSprite( sheet2, { name="bird", start=1, count=4, time=500 } )
    deadbird2.x = _W/2 + 160
    deadbird2.y = _H/2 - 180
    deadbird2.xScale = 1.3
    deadbird2.yScale = 1.3
    deadbird2.rotation = 10
    deadbird2:play()
    group:insert(deadbird2)  

  --Adiciona o pássaro cinza
  local sheet3 = graphics.newImageSheet( "images/finalbird.png", { width=125, height=90, numFrames=4 } )

  --Cria o sprite do pássaro cinza
  finalbird = display.newSprite( sheet3, { name="bird", start=1, count=4, time=500 } )
    finalbird.x = _W/2 + 160
    finalbird.y = _H - 180
    finalbird.xScale = 1.3
    finalbird.yScale = 1.3
    finalbird:play()
    group:insert(finalbird)  

  --Adiciona a bola de basquete
  ball = display.newImage("images/ball.png")
    ball.x = _W/2   
    ball.y = _H-180 
    ball.xScale = 0.7
    ball.yScale = 0.7 
    group:insert(ball)  
    
  local function animate( event )
    transition.to( ball, { rotation = ball.rotation +360, time=600, onComplete=animate } )
  end
  animate()

  retry = display.newImage("images/retry.png")
    retry.x = _W/2
    retry.y = _H/2-30
    retry.xScale = 0.4
    retry.yScale = 0.4
    group:insert(retry)

  function goto_Game()
    storyboard.gotoScene("game", transicaoCena)
  end
  retry:addEventListener("tap", goto_Game)

  menu = display.newImage("images/menu.png")
    menu.x = _W/2
    menu.y = _H/2+100
    menu.xScale = 0.4
    menu.yScale = 0.4
    group:insert(menu)

  function game_menu()
    storyboard.gotoScene("menu")
  end
  menu:addEventListener("tap", game_menu)  
end

function scene:enterScene(event)
  local group = self.view;
  storyboard.removeScene("menu")
  storyboard.removeScene("game")
  bgSoundChannelGame = audio.play(bgSound, {channel = 4, loops = -1});
end

function scene:exitScene( event )
  local group = self.view;
  transition.cancel()
	display.remove(background)
  display.remove(retry)
  display.remove(menu)
  display.remove(scores)
  display.remove(deadbird1)
  display.remove(deadbird2)
  display.remove(finalbird)
  display.remove(ball)
  display.remove(pontuacaoFinal)
	menu:removeEventListener("tap", game_menu)
	audio.stop()
end

--Recebe os metodos criados
scene:addEventListener("createScene", scene)

scene:addEventListener("enterScene", scene)

scene:addEventListener("exitScene", scene)

return scene

 








