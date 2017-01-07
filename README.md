[![MadeInSweden](https://img.shields.io/badge/Made In-Stockholm, Sweden-blue.svg)](https://en.wikipedia.org/wiki/Stockholm)

[![Status](https://img.shields.io/badge/Status-Active doing well & alive-blue.svg)](https://github.com/MKGitHub/UIPheonix)
[![Version](https://img.shields.io/badge/Version-2.0.0-blue.svg)](https://github.com/MKGitHub/UIPheonix)
[![Pod](https://img.shields.io/badge/pod-2.0.0-blue.svg)](https://github.com/MKGitHub/UIPheonix)

[![Platform](https://img.shields.io/badge/Platforms-macOS + iOS + tvOS-blue.svg)](https://github.com/MKGitHub/UIPheonix)
[![Swift](https://img.shields.io/badge/Swift Version-3.0.1-blue.svg)](https://github.com/MKGitHub/UIPheonix)

[![RUIC Implementation Version](https://img.shields.io/badge/RUIC Implementation Version-2-blue.svg)](https://github.com/MKGitHub/UIPheonix)


![UIPheonix Logo](https://raw.githubusercontent.com/MKGitHub/UIPheonix/master/Images/Banner.png)

* Forget static layouts, constraint issues and warning explosions in the console.
* Forget all the glue code, all the boilerplate code and all the very common overly engineered unnecessary pile of garbage code in your app.
* UIPheonix is super easy, flexible, dynamic and highly scalable.
* Make changes to your UI quickly in a snap.
* Make your UI reusable.
* Focus on creating your app, not fighting layout issues.

Inspired by game development UIPheonix is a simple framework + concept for building apps where you create reusable UI controls. The same API apply for cross platform development! Think of it as using Lego blocks, you can use similar ones and move them around easy as pie.

![macOS Demo](https://raw.githubusercontent.com/MKGitHub/UIPheonix/master/Images/macOS.gif)
![iOS Demo](https://raw.githubusercontent.com/MKGitHub/UIPheonix/master/Images/iOS.png)
![tvOS Demo](https://raw.githubusercontent.com/MKGitHub/UIPheonix/master/Images/tvOS.png)

* Reusable UI Control (from here on mentioned as a "RUIC") – Is basically just a model+view.
You can configure a RUIC in any way you want, in the demo apps I'm using both JSON files and simple code to setup the models.

![RUIC Diagram](https://raw.githubusercontent.com/MKGitHub/UIPheonix/master/Images/RUIC.png)

* Display Models (list) – An array of [model, model, model…], etc., this is how UIPheonix knows what to display.

![States](https://raw.githubusercontent.com/MKGitHub/UIPheonix/master/Images/States.png)

* Display State – In the demo apps I'm using a simple "state machine".
You may find alternative solutions, and your milage may vary :-)

* Model-View Relationships (dictionary) – A dictionary defining the relationship between model+view.

UIPheonix and the demo apps are all cross-platform (macOS, iOS and tvOS), that’s how I Kung Fu!


Example RUICs
------
Making a RUIC is pretty simple as making a model and a view.

![ExampleRUIC1](https://raw.githubusercontent.com/MKGitHub/UIPheonix/master/Images/Example1.png)
![ExampleRUIC1](https://raw.githubusercontent.com/MKGitHub/UIPheonix/master/Images/Example2.png)


Whats Next?
------
* Add more features.
* Try to make everything even simpler.


Used In Apps
------
* Hoppa
* McDonald's Sweden
* McDonald's Switzerland


Contributing
------
Please contribute or create your own RUICs!

In the folder "3rd Party RUICs" you may add your own RUICs, if you already have a Cocoa Control (www.cocoacontrols.com) please consider converting it to the simple UIPheonix architecture.
A great thing about RUICs in UIPheonix is that they all have the same architecture, so you don't have to implement and follow different implementations for each Cocoa Control in your app = less fragmentation!

As UIPheonix may progress and evolve the "RUIC Implementation Version" will increase, and so in order to know which version of UIPheonix a RUIC is compatible with please add this info to your RUIC.


Notes
------
   https://github.com/MKGitHub/UIPheonix

   http://www.xybernic.com

   http://www.khanofsweden.com

   Copyright 2016/2017 Mohsan Khan

   Licensed under the Apache License, Version 2.0.

