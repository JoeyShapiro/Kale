cant use docker. i think

see what other types look like
has a lot of stuff, but need it
its fine

```dart

enabledBorder: OutlineInputBorder(
    borderRadius:
        BorderRadius.all(Radius.circular(100)),
    borderSide:
        BorderSide(color: Colors.greenAccent)),
focusedBorder: OutlineInputBorder(
    borderRadius:
        BorderRadius.all(Radius.circular(100)),
    borderSide:
        BorderSide(color: Colors.greenAccent)),
```

i have to give container. they give an element to put in it

https://api.flutter.dev/flutter/material/Autocomplete-class.html
could use the apple thing, but this is exactly what i was thinking
and i can do it async

i want `Autocomplete - async, debouncing, and network errors`, but wholey code
i will do basic for now. then not do request for the list
actually it should be stored on system. and keep it there, for a while

seems to be known, but its only on mobile from my view point

bottom: 0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,

oh, its a neg trans issue. but it still doesnt exist for desktop

why was it neg neg
made progress. but still doesnt seem right

oh the offset is at the page level. not where it was
it thinks its at the top
i did it!!!!! no idea how !!!!!!

1. all in stack
2. transform in position with bottom 0
3. works for me `¯\_(ツ)_/¯`
... but it is a bug

new idea will be different, so just try taht now
should be fine and easier

i could use dropdown with dropdown menuitem,
but it gets in the way. it wouldnt work for end goal
i want dropdown input, so might as well test on it.
should work differently, so just use that
yeah, not gonna use it so whatever

should try for scanning. maybe i can get category from it
but this is fine for starrting

this is better, but should do a raw, for control, and add the nodes to the gesture group

https://world.openfoodfacts.org/product/5449000214911/coca-cola
need a flutter barcode scanner
is that cheating?

make widget line up with keyboard
    should it be basd on size
move widget to its own class
make cool anims a setting
make category look better
make the buttons look better
day night mode
start working on list
able to add items

cant think of it. so additional would get messy
yeah, if thats the case. then i think i need it

they are only needed in init, but now they arent
play right, and its fine

are these only called once, or when it built everytimew

oh the service and controller crap. ugh
could use an acutal api search. with items and shit
but this good for now
should i create a new list everytime. we will see what i need to do. but its minor stuff
how could i programmatically change icon. i will find out. must be way. but actual good pkg
maybe dont use font awesom, but i have it.
should i have to lists, no cant
one list with categroy
have that one on the bottom
make that category different, or add it on top of

should i just create one big list
but have separate stuff for everything.. and put it all together
should the category be collected though
why not. they are not needed anymore

could use different list view. but this seems the proper way. have most control, and wasnt *that* hard

could make separate list for collected, but dont like. gets over done. i think i can do all one list
the list might need to grow. if i keep it

i think this is the best way to handle it. what if thy have the name, or kepp it indepent
cant have to list views

doesnt have function like go %+v, but can get close i guess.
this is good enough
cant get the objects

should personal list be its own table, or in the family list with a different id
should it be its own table with a standard list, since only one person is using it. or source controlled

could make a popup. but that is too many popups
could have a advanced field, but that seems still odd,
button to bring it up is too many things to do, and too many states to watch
this way works, i guess. and it can expanad which is nice
would like to completely hide it, but this is fine

also using more popups or advanced would be hard to keep track of values
with show advanced, it would be the same height, then bigger

it can handle objects, but i dont need taht

this way only works with small lists. i could do something different, but i feel it might render poorly
i will just do the more work
https://stackoverflow.com/questions/49153087/flutter-scrolling-to-a-widget-in-listview
should maybe add it to the list. seems more usable

i need to remove these double lists. it gets super in the way
just want one list somehows

if they have too many items, load only a few. if they jump to a section, load that part
this is cool, but would not work. it is possible, but a lot of work
it would also only be useful when they have a lot of change and a lot of stuff
better to just bite the bullet

send precompile if over a threshhold
send precompile if change is larger than precompile. this would mean i would need to precomiple
i think i would always need to precompile
then i would only send that
or only send precompiled change
then tell them to just add that
look into this all later, but would need to precompile all of it regardless. that is a lot of work
could not descriminate
but save all data on device, and save the date of last rx. this is good idea so far
no, sending precompiled change wouldnt work, what about del and collect. it would only work with add
or it would be just a preprecompile. or precompile to compile
that would be getting to deep and compliacted. look into if i need it. need to learn
would be useful for bad actors, but i can just watch for them
oh, but i need to learn precompile regardless, and the server will have to do it at some point
i can use this as an opportunintyu to test it and see if i want it to precdompile everytime
but i need to learn how it will work, and python is a good start.

https://api.flutter.dev/flutter/widgets/ContextMenuController-class.html
this is a nice idea for the reactions, but wont really work
the menu cannot get the current item, unless each item has its own complex menu
also, it cant do a row. it uses context menu, which is column

dont save actions, but save final list. how would i do this then
i can just make it not final, and make changes, but i should have a fun way to make chagnes
if they are not final, then when i change something, say the name, i would need to recreate the object, and readd it to the list
is that worth it. yeah that could cause issues, may not be worth the effort.
yeah because it wouldnt be the same, because of the list, i need to make it the same

i would have to update by calls and not objects, because they cant be modified. so i can touch it later
i could delete the objects and place the new one, but that seems like a lot of work. yeah
better to modify what is there where they match uuid

keys are wierdc, but allow for unique use
would it break with a normal key /shrug
