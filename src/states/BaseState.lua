--[[
    GD50
    Breakout Remake

    -- BaseState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Used as the base class for all of our states, so we don't have to
    define empty methods in each of them. StateMachine requires each
    State have a set of four "interface" methods that it can reliably call,
    so by inheriting from this base state, our State classes will all have
    at least empty versions of these methods even if we don't define them
    ourselves in the actual classes.
]]
--[[
  TODO / My approch
  I had writen all steps I had taken for solving this assignment
	DEBUG THE RECOVER POINTS MISHAP
	CHANGE SIZE OF PADDLES
      decrease the paddle size - done
      increase paddle size - done
IMPLIMENT THE DIFFERENT POWERUP DOING DOWN - DONE
        generate the powers ups sprites - done
        make powers up class - done
        render the powers ups - done
	BALL POWER UPS - DONE
      impliment the inPlay function in ball class - done
      change Ball() to {Ball()} in play state - done
      produce more balls - done
      debug the health error - done
	KEY AND UNLOCKING THE BRICK
      take out the lock brick sprite - done
      implement the function for lock brick in brick class - done
      produce at least and at most one lock bricks - doing
      produce power up to unlock the brick
]]
BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end
