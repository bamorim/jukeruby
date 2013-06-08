Pytera Jukebox
==============

About
-----

It's a simple jukebox written in ruby, it's still a WIP, so use it on your own risk.
Basically you have to start the music player (jukeserver.rb) and the sinatra application (application.rb).

If you want people to discover the webserver using the android application, start the discovery server too (discovery_server.rb)

TODO
----

Well, there are many things to do, but mainly:
* A simple refactoring, changing names of the files and splitting the project in three (Player, WebServer and Discovery Server)
* Write the documentation
* Make a RESTful API so all the front end on the android app can be done natively and not with a WebView

License
-------

Copyright (c) 2013 Bernardo Amorim

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
