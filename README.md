## [Project 26: Marble Maze](https://www.hackingwithswift.com/read/26/overview)
Written by [Paul Hudson](https://www.hackingwithswift.com/about)  ![twitter16](https://github.com/juliangyurov/PH-Project6a/assets/13259596/445c8ea0-65c4-4dba-8e1f-3f2750f0ef51)
  [@twostraws](https://twitter.com/twostraws)

**Description:** Respond to device tilting by steering a ball around a vortex maze.

- Setting up

- Loading a level: `categoryBitMask`, `collisionBitMask`, `contactTestBitMask`

- Tilt to move: `CMMotionManager`

- Contacting but not colliding

- Wrap up
  
## [Review what you learned](https://www.hackingwithswift.com/review/hws/project-26-marble-maze)

**Challenge**

1. Rewrite the `loadLevel()` method so that it's made up of multiple smaller methods. This will make your code easier to read and easier to maintain, or at least it should do if you do a good job!

2. When the player finally makes it to the finish marker, nothing happens. What should happen? Well, that's down to you now. You could easily design several new levels and have them progress through.

3. Add a new block type, such as a teleport that moves the player from one teleport point to the other. Add a new letter type in `loadLevel()`, add another collision type to our `enum`, then see what you can do.
