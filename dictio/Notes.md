# TODO
- Look at the smallest supported phone size and fix the game view, limiting the number of letters if needed
- Add core data capabilities
- Limit daily game to once a day
- Create a list of words that are not down to be daily words (or restrict which words are used for practice to previous words and those 6 months in advance, and put in a way to handle the daily games when a player has already done the word in practice)
- Design home screen
- Design stats screen
- Fix leaderboard issue
- Set up in-game currency
- Prevent practice is coins = 0, increase coins by 1 each daily game played
- sort out drop in screen when returning from leaderbaordg

#  Views
**Initialisation View**
Loads player data

**Session View**
Decides which view to show (home, game) based on whether there is an active game

**Home View**
(When game is not active)
Gives the player their playing options, profile and stats

**Game View**
(When game is active)
Allows the player to play the game, and presents the results at the end, before returning to home view

# Data types

Game:
- correct word
- number of guesses
- guesses in order (dictionary: [1:"guess", 2: "guess"])
- timestamp started
- timestamp ended

Daily game (game plus)
- Daily game number (eg. #102)



# Acheivements
- Daily game streak -
1. Complete a daily game
2. Complete a daily game for 7 days in a row
3. Complete a daily game for a whole month
4. Complete a daily game for 365 days in a row
5. Apply a streak bandage

- Friends and social - 
1. Invite a friend
2. Next up, Arsenal FC: Have 10 friends
3. Share a score on Twitter
4. Challenge a friend with a 5-letter word
5. Set up a leaderboard
6. Finish a season at the top of the leaderboard
7. Finish a season at the bottom of the leaderboard
8. Win a challenge set by a friend
9. Beat 5 friends on the same daily game

- Get the practice in - 
1. Complete a practice game
2. Complete a practice game for every letter of the alphabet

- It gets difficult - 
1. Complete a game in fewer than 15 guesses
2. Complete a game in fewer than 10 guesses
3. Complete a game in fewer than 5 guesses
4. Complete a 4-letter game
5. Complete a 5-letter game
6. Complete a 6-letter game
7. Complete a 7-letter game
8. Complete a 8-letter game
9. Complete a 9-letter game
10. Complete a 10-letter game
11. Complete a 11-letter game
12. Complete a 12-letter game
13. Complete a 13-letter game
14. Complete a 14-letter game
15. Complete a 15-letter game

