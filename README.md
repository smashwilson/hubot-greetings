# Hubot Greetings

*Customized greetings for individual people by your Hubot.*

## Installation

1. Add `hubot-greetings` to your `package.json`:

   ```json
   "dependencies": {
     "hubot-greetings": "~1.0.0"
  },
   ```
2. Require the module in `external-scripts.json`:

  ```json
  ["hubot-greetings"]
  ```
3. Run `npm update` and restart your Hubot.

## Commands

To tell Hubot to greet you with a specific phrase, tell him:

```irc
Hubot: greet me with your hovercraft is full of eels!
```

Hubot will remember *all* of the greetings that you've told him, and choose one randomly each time you enter the room. If you want him to stop using one of them, use:

```irc
Hubot: don't greet me with the worst. really, just the worst
```

You can wipe the slate clean with:

```irc
Hubot: forget my greetings
```

It's a bit spammy, but you can ask Hubot to list all of the greetings that he knows with:

```irc
Hubot: show my greetings
```

Replace `me` with `you` or another user's username to change other people's greetings, if you're allowed to do so. Possessive forms are also recognized, so `Hubot: show Kyle's greetings` will work for a user named `Kyle`.

## Greetings Czar

By default, Hubot will only let you add and remove greetings from yourself. You can change this by either setting the environment variable `HUBOT_GREETINGS_FFA` to something nonempty, to make it a giant free-for-all. Alternately, if you're using the [auth script](https://github.com/github/hubot/blob/master/src/scripts/auth.coffee), you can grant your inner circle the **"greeting czar"** role, and they and only they can change whatever greetings they like.
