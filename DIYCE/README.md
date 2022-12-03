# DIYCE

This is my version of DIYCE (Do It Yourself Combat Engine) for game Runes of Magic. It contains mainly dwarfs' classes combos. It's made to be used with polish language in game, so to use it with other languages, you need to translate skills names.

### Instalation

Clone this repo and put it in folder "/interface/addons" in game folder.

### Usage

Make a macro in game:

/script KillSequence("","1")

And use this macro to use this DIYCE.

For champion/roogue or champion/mage you can use those macros:
- for being a DD in 0 lvl shield:
/script KillSequence("","dps")
- for being a tank:
/script KillSequence("","tank")
- for not using automagically shield form:
/script KillSequence("","bezpostaci")

However, I don't recommend using macro for being DD before reading all used skills in thid DIYCE, as it is made to deal damage while in shield form, but when rune growth is over, it drops shield form, uses rune growth and uses dhield form.
