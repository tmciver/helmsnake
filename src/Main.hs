
import Prelude hiding (Left, Right)

import Linear.V2 (V2(V2))

import Helm
import Helm.Color
import Helm.Engine.SDL (SDLEngine)
import Helm.Graphics2D

import qualified Helm.Cmd as Cmd
import qualified Helm.Mouse as Mouse
import qualified Helm.Engine.SDL as SDL
import qualified Helm.Sub as Sub
import qualified Helm.Keyboard as Keyboard
import qualified Helm.Time as Time

windowDims :: V2 Int
windowDims = V2 800 600

segmentSize :: Int
segmentSize = 20

speed :: Int -- pixels per second
speed = 100

data Action = DoNothing
            | Animate Double
            | MoveUp
            | MoveDown
            | MoveLeft
            | MoveRight

data Dir = Up | Down | Left | Right

-- The snake is represented as a list of 2D positions
-- which represent each segment of its body plus the
-- direction in which it is currently moving.
data Model = Snake Dir [(V2 Int)]

initial :: (Model, Cmd SDLEngine Action)
initial = (snake, Cmd.none)
  where snake = Snake Right [ V2 x y
                            , V2 x (y + segmentSize)
                            , V2 x (y + 2 * segmentSize)
                            ]
        V2 w h = windowDims
        (x, y) = (w `div` 2, h `div` 2) -- start the snake's head in the middle of the screen

update :: Model -> Action -> (Model, Cmd SDLEngine Action)
update snake DoNothing = (snake, Cmd.none)

update (Snake dir oldSnake@((V2 x y):_)) (Animate _) = (snake, Cmd.none)
  where snake = (Snake dir (take (length oldSnake) newSnake))
        newSnake = newHead:oldSnake
        newHead = case dir of
          Up -> V2 x (y - segmentSize)
          Down -> V2 x (y + segmentSize)
          Left -> V2 (x - segmentSize) y
          Right -> V2 (x + segmentSize) y

update (Snake _ segments) MoveUp = (Snake Up segments, Cmd.none)
update (Snake _ segments) MoveDown = (Snake Down segments, Cmd.none)
update (Snake _ segments) MoveLeft = (Snake Left segments, Cmd.none)
update (Snake _ segments) MoveRight = (Snake Right segments, Cmd.none)

subscriptions :: Sub SDLEngine Action
subscriptions = Sub.batch
                [ Keyboard.presses $ \key -> case key of
                     Keyboard.UpKey -> MoveUp
                     Keyboard.DownKey -> MoveDown
                     Keyboard.LeftKey -> MoveLeft
                     Keyboard.RightKey -> MoveRight
                     _ -> DoNothing
                , Time.fps 2 Animate
                ]

view :: Model -> Graphics SDLEngine
--view (Snake _ segments) = Graphics2D $ collage [move pos $ filled (rgb 1 0 0) $ square 10]
view (Snake _ segments) = Graphics2D $ collage body
  where body = map (\pos -> move (fromIntegral <$> pos) $ filled (rgb 1 1 1) $ square (fromIntegral segmentSize)) segments

main :: IO ()
main = do
  engine <- SDL.startupWith $ SDL.defaultConfig
    { SDL.windowIsResizable = False
    , SDL.windowDimensions = windowDims }

  run engine GameConfig
    { initialFn       = initial
    , updateFn        = update
    , subscriptionsFn = subscriptions
    , viewFn          = view
    }
