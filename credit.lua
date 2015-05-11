-- Requisita o storyboard e cria uma nova cena
local storyboard = require("storyboard")
local scene = storyboard.newScene()

function scene:createScene( event )
  local group = self.view

  --Adiciona o background
  local background = display.newImage("images/creditsbg.jpg")
    background.x = _W/2
    background.y = _H/2
    group:insert(background)  

  --Adiciona o botão de creditos
  back = display.newImage("images/back.png")
    back.x = _W/2 
    back.y = _H/2 + 270
    back.xScale = 0.4
    back.yScale = 0.4  
    group:insert(back) 
 
  function goto_menu()
    storyboard.gotoScene("menu", transicaoCena)
  end	 
end

function scene:enterScene( event )
  back:addEventListener("tap", goto_menu)
  storyboard.removeScene("menu")
end



-- Recebe os metodos criados
scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )



return scene	    