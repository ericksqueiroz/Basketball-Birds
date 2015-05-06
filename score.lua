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
local score = display.newText("Your Score:", _W/2, 150, "DS-Digital", 80)
group:insert(score)

function movescoreUp()
	transition.to(score, {time = 1000, alpha = 1, x = (_W/2), y = (150), xScale = 1.35, yScale = 1.35, onComplete = movescoreDown});
end

function movescoreDown()
	score.alpha = 1;
	transition.to(score, {time = 1000, alpha = 1, x = (_W/2), y = (150), xScale = 1, yScale = 1, onComplete = movescoreUp});
end
movescoreUp();

local retry = display.newImage("images/retry.png")
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
scene:addEventListener("createScene", scene)

function scene:enterScene(event)
  local group = self.view;
    storyboard.removeScene("menu")
    storyboard.removeScene("game")
    bgSoundChannelGame = audio.play(bgSound, {channel = 4, loops = -1});
end
scene:addEventListener("enterScene", scene)

function scene:exitScene( event )
	display.remove(background)
	menu:removeEventListener("tap", game_menu)
	audio.stop( )
end
scene:addEventListener("exitScene", scene)

return scene

 








