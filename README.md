# Stellar Deception

Made for the 81st Godot Wild Jam

![Main Theme](https://img.itch.zone/aW1nLzIxMTEyMTQyLnBuZw==/original/2gfan8.png)
![Wildcards](https://img.itch.zone/aW1nLzIxMTEyMTUxLnBuZw==/original/AsoyOk.png)

For this jam I tried to conform more to the Godot style of coding, mainly:
- Using `snake_case` naming conventions rather than `PascalCase` or `camelCase` as I normally do.
- Using more signals. I usually prefer to get the reference to the node I want and then call a function or something directly but I figured I'd give signals a try. They're cleaner, but usually more lines of code.
- Using Timer nodes rather than creating a variable and modifying it in `_process()` like I usually do.

Also discovered some cool new things in Godot 4.4 like the `remap()` function, and this is the first time I've messed around with Physics bodies and AnimationPlayers

`main.gd` sort of handles everything, and the autoloads too. If you want to see how I cobbled this together, those are great places to start looking.
