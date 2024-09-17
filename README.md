# simple-menu.vim

## what?

Create simple menus in Vim that respond to key mappings.

See the usage in the doc file for more info: `:help simple-menu`.

![example](http://i.imgur.com/fF0UEG9.gif)

## why?

For rarely-used actions in rarely used file types, I don't always remember mappings I've setup.

As an example, for Rails migrations, I might want mappings to

- run any pending migrations
- run just this current buffer's migration
- run this migration down
- re-run this migration (down then back up)
- copy the migration number to the clipboard

I don't do all of these often enough to remember the mappings so a menu is easier. I hit <enter> and then a single character to pick the action I want (e.g. `a` to run all pending migrations).

You can treat this menu like training wheels to help you learn mappings by having the menu keys correspond to your mappings (e.g. `a` in the menu runs all migrations so I know that I've bound `<localleader>a` to do the same). You can also just have the menu exist as its own thing and never bother having individual mappings for more rarely used items.
