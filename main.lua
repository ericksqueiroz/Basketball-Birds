-- Esconde a barra de status, define os pontos de âncoragem e cria aleatorias posições para os objetos
display.setStatusBar(display.HiddenStatusBar)

-- Requisita o storyboard e vai para a tela do jogo
local storyboard = require "storyboard"
storyboard.gotoScene("menu")