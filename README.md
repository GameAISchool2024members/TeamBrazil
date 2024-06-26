# KeepCalm Game Project 

> #Team🇧🇷



https://github.com/GameAISchool2024members/TeamBrazil/assets/3648336/90bbc040-f4d4-4cfa-a4cf-c2c8eecef533



## Table of Contents
- [Introduction](#introduction)
- [Human-Computer Interaction Experience](#human-computer-interaction-experience)
- [Frameworks Used](#frameworks-used)
- [Gameplay](#gameplay)
- [Installation](#installation)
- [Usage](#usage)
- [Development](#development)
- [Credits](#credits)

## Introduction
KeepCalm is an engaging and interactive game designed for both iPhone and iPad. The game uses the device motion data to control a character's movements, making it an ??fun?? and immersive experience for players. Players collect fruits while avoiding red poo that impose penalties. The game features a start screen, gameplay, and a ranking system where players can save their scores and initials.

![5](https://github.com/GameAISchool2024members/TeamBrazil/assets/3648336/5cde0107-dcc3-41c6-90f7-fe414d772d22)



## Future Improvements

- Use a neural network to detect different type of gestures from the motion data.
- Multiplayer (multiple iphones controlling same player and multiple players for each iPhone) 

## Human-Computer Interaction Experience
The game is designed with a focus on an intuitive and smooth human-computer interaction experience. Key aspects include:
- **Motion Control:** Players use the motion data from their devices to control the character's jumps.
- **Feedback:** Visual and haptic feedback are provided to enhance the user experience. Haptic feedback is used when the player jumps (iPhone only).
- **UI Design:** The interface includes clear and accessible buttons for starting the game and saving scores. A scrollable ranking list ensures easy navigation through high scores.

### Interaction Scheme
```
+---------------------------+
| Start Screen              |
| +-----------------------+ |
| | Start Game Button     | |
| +-----------------------+ |
+---------------------------+
             |
             v
+---------------------------+
| Game Screen               |
| +-----------------------+ |
| | Player Character      | |
| +-----------------------+ |
| | Fruit Collection      | |
| +-----------------------+ |
| | Score Display         | |
| +-----------------------+ |
+---------------------------+
             |
             v
+---------------------------+
| Ranking Screen            |
| +-----------------------+ |
| | Enter Initials        | |
| +-----------------------+ |
| | Save Score Button     | |
| +-----------------------+ |
| | Restart Game Button   | |
| +-----------------------+ |
| | Ranking List          | |
| +-----------------------+ |
+---------------------------+
```

## Frameworks Used
- **SwiftUI:** Used for building the user interface in a declarative manner.
- **SpriteKit:** Used for creating and managing the game scenes and animations.
- **CoreMotion:** Used for accessing the device’s motion data to control game mechanics.
- **MultipeerConnectivity:** Used for multiplayer capabilities and data transfer between devices.
- **AVFoundation:** Used for playing background music and sound effects.

## Gameplay
### Objective
Collect as many fruits as possible while managing your jumps. Avoid poo that impose penalties and aim for high scores.

### Controls
- **Jump:** Tilt the device to control the character's jumps.
- **Collect Fruits:** Move the character to collect different types of fruits:
  - **Banana 🍌:** Increases the score.
  - **Cherry 🍒:** Speed up the game (10s).
  - **BlueBerry 🫐:** Adds an extra jump.
  - **Poo 💩:** Has special effects.

### Scoring
- **Fruits Collected:** The score increases based on the number of fruits collected.
- **Jumps Remaining:** The game ends when the player runs out of jumps. The remaining jumps are a factor in the final score.

### Game Over
When the player runs out of jumps, the game ends, and the player is prompted to enter their initials to save their score. The ranking list is displayed, and the player can restart the game.

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/GameAISchool2024members/TeamBrazil.git
   ```
2. Open the project in Xcode:
   ```sh
   open KeepCalm.xcodeproj
   ```
3. Build and run the project on your device for the controller and other build on mac (iPad version) for the game.

## Usage
1. Launch the app on your device.
2. On the start screen, press the "Start Game" button to begin.
3. Tilt your device to control the character and collect fruits.
4. When the game ends, enter your initials and save your score.
5. View the ranking list and press "Restart Game" to play again.

## Development
### Adding New Features
1. **Haptic Feedback:** Add haptic feedback for different game events.
2. **Multiplayer Mode:** Implement a multiplayer mode using MultipeerConnectivity.
3. **New Levels:** Design and add new levels with increasing difficulty.

### Improving the UI
- Enhance the UI design for better visual appeal.
- Add animations and transitions to improve the user experience.

## Credits
- **Developer:** Ezequiel dos Santos
- **Design:** [Scirra Store License]()
- **Music:** [[8 bit Samba, by Ian Post](https://artlist.io/royalty-free-music/song/8-bit-samba/5003)]

Thank you for playing KeepCalm!

# Ranking on the day of the JAM

| Rank | Name        | Points |
|------|-------------|--------|
| 1    | MARKUS      | 85     |
| 2    | DO          | 81     |
| 3    | NURBEK B    | 79     |
| 4    | DIOGO       | 73     |
| 5    | WAFA        | 70     |
| 6    | Nuno        | 68     |
| 7    | JEREMY      | 66     |
| 8    | FANDI MENG  | 59     |
| 9    | GNY         | 57     |
| 10   | EZE         | 53     |
| 11   | CHEESE      | 50     |
| 12   | GINGER      | 48     |
| 12   | MALAK       | 48     |
| 14   | JULIAN      | 39     |
| 15   | emil        | 36     |
| 16   | jsk         | 34     |
| 17   | LUKE D      | 32     |
| 18   | alireza     | 24     |
| 19   | PYL         | 15     |
| 20   | RRT         | 12     |
| 21   | HYS         | 11     |
| 21   | BGB         | 11     |

<img src="https://github.com/GameAISchool2024members/TeamBrazil/assets/3648336/3ed8106c-0370-400f-a3cf-d0f3830568b7" height="40px" width="40px"/>
