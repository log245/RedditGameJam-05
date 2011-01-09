-- 
--  scene_gameover.lua
--  redditgamejam-05
--  
--  Created by Jay Roberts on 2011-01-09.
--  Copyright 2011 GloryFish.org. All rights reserved.
-- 

require 'vector'

gameover = Gamestate.new()

function gameover.enter(self, pre)
  gameover.title = 'Game Over'
  gameover.subtitle = 'Forever together!'
  
  gameover.redditlogo = love.graphics.newImage('resources/images/redditgamejam05.png')
  
  gameover.sounds = {
    gameoverselect = love.audio.newSource('resources/sounds/menuselect.mp3', 'static'),
    gameovermove = love.audio.newSource('resources/sounds/menumove.mp3', 'static')
  } 
  
  gameover.entries = {
    {
      title = 'Play Again',
      scene = game,
      level = 'levelone'
    },
    {
      title = 'Main Menu',
      scene = menu
    }
  }
  
  gameover.colors = {
    text = {
      r = 255,
      g = 255,
      b = 255,
      a = 255
    },
    highlight = {
      r = 255,
      g = 0,
      b = 0,
      a = 255
    },
    background = {
      r = 240,
      g = 200,
      b = 200,
      a = 255
    }
  }
  
  gameover.position = vector(100, 100)
  
  gameover.lineHeight = 20
  
  gameover.index = 1
  
  music.title:setVolume(1.0)
  love.audio.play(music.title)
  
  gameover.leaving = false
  gameover.leaveInterval = 1
  gameover.leaveDuration = 0

  gameover.counting = true
  gameover.countInterval = 3
  gameover.countDuration = 0
  
  gameover.displayscore = 0
end

function gameover.update(self, dt)
  if gameover.counting then
    gameover.countDuration = gameover.countDuration + dt
    
    gameover.displayscore = math.floor((gameover.countDuration / gameover.countInterval) * gameover.finalscore)
    
    if gameover.countDuration > gameover.countInterval then
      gameover.counting = false
      gameover.displayscore = gameover.finalscore
    end
  end
  
  if gameover.leaving then
    gameover.leaveDuration = gameover.leaveDuration + dt
    
    music.title:setVolume(1 - ((gameover.leaveInterval - gameover.leaveDuration) / gameover.leaveInterval))
    
    if gameover.leaveDuration > gameover.leaveInterval then
      gameover.leaving = false
      music.title:pause()
      Gamestate.switch(gameover.entries[gameover.index].scene)
    end
  else
    input:update(dt)

    if input.state.buttons.newpress.down then
      gameover.index = gameover.index + 1
      if gameover.index > #gameover.entries then
        gameover.index = 1
      end
      love.audio.play(self.sounds.gameovermove)
    end

    if input.state.buttons.newpress.up then
      gameover.index = gameover.index - 1
      if gameover.index < 1 then
        gameover.index = #gameover.entries
      end
      love.audio.play(self.sounds.gameovermove)
    end

    if input.state.buttons.newpress.select then
      if gameover.entries[gameover.index].title == 'Quit' then
        love.event.push('q')
      else
        if gameover.entries[gameover.index].level ~= nil then
          gameover.entries[gameover.index].scene.level = gameover.entries[gameover.index].level
        end

        gameover.leaving = true
        gameover.leaveDuration = 0
        love.audio.play(self.sounds.gameoverselect)
      end
    end

    if input.state.buttons.newpress.cancel then
      love.event.push('q')
    end
  end
end

function gameover.draw(self)
  love.graphics.setColor(self.colors.text.r,
                         self.colors.text.g,
                         self.colors.text.b,
                         self.colors.text.a);
  
  love.graphics.setFont(fonts.large)
  love.graphics.print(gameover.title, 40, 20);
  
  love.graphics.setFont(fonts.default)

  love.graphics.print(gameover.subtitle, 55, 60);

  love.graphics.print(string.format("Final Score: %i", gameover.displayscore), 400, 60);
  
  
  
  love.graphics.setBackgroundColor(self.colors.background.r,
                                   self.colors.background.g,
                                   self.colors.background.b,
                                   self.colors.background.a);

  local currentLinePosition = 0
  
  for index, entry in pairs(self.entries) do
    love.graphics.setColor(self.colors.text.r,
                           self.colors.text.g,
                           self.colors.text.b,
                           self.colors.text.a);

    if index == self.index then
      love.graphics.setColor(self.colors.highlight.r,
                             self.colors.highlight.g,
                             self.colors.highlight.b,
                             self.colors.highlight.a);
    end

    love.graphics.print(entry.title, 
                        self.position.x, 
                        self.position.y + currentLinePosition);

    currentLinePosition = currentLinePosition + self.lineHeight;
  end
  
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(gameover.redditlogo, 500, 500)
  
  if gameover.leaving then
    local overlayAlpha = (1 - ((gameover.leaveInterval - gameover.leaveDuration) / gameover.leaveInterval)) * 255
    love.graphics.setColor(255, 255, 255, overlayAlpha)
    
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  end
  
end

function gameover.leave(self)
end