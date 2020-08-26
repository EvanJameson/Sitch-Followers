# Sitch Followers

Sitch Followers is an iOS app that allows users to follow their favorite streamers. This app was made with inspiration 
from Sean Allen's [GitHub Followers take home course](https://seanallen.teachable.com/p/take-home). 

Some features are the same:
  - UI elements and layouts (Home Screen, Followers Screen, Favorites Screen)

While others are new:
  - Top streams screen
  - Live channel badges + animations
  - App flow
  - Live channel information (User Info Screen)
  - Use of the new Twitch API

---

### Home Screen

![](https://i.ibb.co/9VKBwC8/1.png)
![](https://i.ibb.co/b1VfJQW/2.png)

Here users can search for streamers by their username.

---

### Top Streams Screen

![](https://i.ibb.co/kJvtM0h/3.png)
![](https://i.ibb.co/DrdnpZj/4.png)

Users can view the streams with the most current viewers. This screen uses pagination to limit 
large network calls with 10 streams per page. This screen also has a "pull to refresh" at the top
which will reset the screen and make a new request for the current most watched streams.

---

### Favorites Screen

![](https://i.ibb.co/8XxqWLh/5.png)
![](https://i.ibb.co/G2xjSzG/6.png)

Users can view their favorite streamers and see which ones are live at a glance.
This list can be modified via "swipe to delete".

---

### User Info Screen

![](https://i.ibb.co/Wyj4g0P/7.png)
![](https://i.ibb.co/rZJLN0S/8.png)

On this screen users can favorite the streamer, see if they are is live, read their channel description, view what 
game they are playing (if they are live), visit their stream via safari, or view their followers.

---

### Followers Screen

![](https://i.ibb.co/kqV8153/9.png)
![](https://i.ibb.co/2cd8F1y/10.png)

Users can view the followers of the streamer on this screen. If any of them are live they will have a 
live badge and animation

---
