#BButton 3.0

BButton is a subclass of UIButton that looks like the [Twitter Bootstrap](http://getbootstrap.com) buttons. 

*New!* Use Bootstrap [version 2](http://getbootstrap.com/2.3.2/) or [version 3](http://getbootstrap.com) style!

Forked from [@mattlawer / BButton](https://github.com/mattlawer/BButton) and refactored for more awesome.

Includes [@leberwurstsaft / FontAwesome-for-iOS](https://github.com/leberwurstsaft/FontAwesome-for-iOS), fixed for iOS from the original [FontAwesome](http://fortawesome.github.com/Font-Awesome/).

![BButton Screenshot 1][img1] &nbsp;&nbsp;&nbsp;&nbsp; ![BButton Screenshot 2][img2]

### Features

* iOS 6.1+, ARC, Storyboards
* Style like Bootstrap 2 or 3
* Set corner radius via UIAppearance
* Option to show button 'disabled' state
* Many button type (color) options
* FontAwesome included

## Installation

### From [CocoaPods](http://www.cocoapods.org)

#### **This fork**
	
	pod 'BButton',  :git => 'https://github.com/jessesquires/BButton.git'

#### Original repo

	pod `BButton`

### From source

* Drag the `BButton/` folder to your project (make sure you copy all files/folders)
* `#import "BButton.h"`
* Add `Fonts provided by application` key to `Info.plist` and include `FontAwesome.ttf`

![plist][img3]

## How To Use

### With Storyboards

Create a `UIButton` and change its class to `BButton`

### Create programmatically

Initialize with any of the following methods:

````objective-c
- (id)initWithFrame:(CGRect)frame type:(BButtonType)type style:(BButtonStyle)aStyle
- (id)initWithFrame:(CGRect)frame
               type:(BButtonType)type
              style:(BButtonStyle)aStyle
               icon:(FAIcon)icon
           fontSize:(CGFloat)fontSize
- (id)initWithFrame:(CGRect)frame color:(UIColor *)aColor style:(BButtonStyle)aStyle
- (id)initWithFrame:(CGRect)frame
              color:(UIColor *)aColor
              style:(BButtonStyle)aStyle
               icon:(FAIcon)icon
           fontSize:(CGFloat)fontSize
+ (BButton *)awesomeButtonWithOnlyIcon:(FAIcon)icon
                                  type:(BButtonType)type
                                 style:(BButtonStyle)aStyle
+ (BButton *)awesomeButtonWithOnlyIcon:(FAIcon)icon
                                 color:(UIColor *)color
                                 style:(BButtonStyle)aStyle
````

### UI Appearance

Set corner radius for all buttons via UIAppearance

````objective-c
[[BButton appearance] setButtonCornerRadius:[NSNumber numberWithFloat:0.0f]];
````
![BButton Screenshot 3][img4] &nbsp;&nbsp;&nbsp;&nbsp; ![BButton Screenshot 4][img5]

**See the included demo project `BButtonDemo.xcodeproj`**

**See `FontAwesomeIcons.html` for list of icons**

## Apps Using This Control

[Gitty for GitHub](https://itunes.apple.com/us/app/gitty-for-github/id645696309?mt=8)

[Hemoglobe](http://bit.ly/hemoglobeapp)

[iPaint uPaint](http://bit.ly/ipupappstr)

[Audiotrip](https://itunes.apple.com/us/app/audiotrip/id569634193?mt=8)

[iExplorer for DeviantART](https://itunes.apple.com/us/app/iexplorer-for-deviantart/id657212778?mt=8)

*[Contact me](mailto:jesse.squires.developer@gmail.com) to have your app listed here.*

## [MIT License](http://opensource.org/licenses/MIT)

Copyright &copy; 2012, Mathieu Bolard. All rights reserved.

Refactored by Jesse Squires, April 2013.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

##[FontAwesome](https://github.com/FortAwesome/Font-Awesome) License

* The Font Awesome font is licensed under the [SIL Open Font License](http://scripts.sil.org/OFL)
* Font Awesome CSS, LESS, and SASS files are licensed under the [MIT License](http://opensource.org/licenses/mit-license.html)
* The Font Awesome pictograms are licensed under the [CC BY 3.0 License](http://creativecommons.org/licenses/by/3.0)
* Attribution is no longer required in Font Awesome 3.0, but much appreciated:
	* *"Font Awesome by Dave Gandy - http://fortawesome.github.com/Font-Awesome"*

[img1]:https://raw.github.com/jessesquires/BButton/master/Screenshots/screenshot-0.png
[img2]:https://raw.github.com/jessesquires/BButton/master/Screenshots/screenshot-2.png
[img3]:https://raw.github.com/jessesquires/BButton/master/Screenshots/plist.png
[img4]:https://raw.github.com/jessesquires/BButton/master/Screenshots/screenshot-4.png
[img5]:https://raw.github.com/jessesquires/BButton/master/Screenshots/screenshot-5.png
