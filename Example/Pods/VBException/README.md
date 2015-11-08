VBException
===========

VBException is a base class for your own exceptions. It makes exception creation and handling more effective.

Use case

1. Create VBException subclass.
2. Implement <i>+reasonWithUserInfo:</i> method.
3. Call <i>+exception:</i> or <i>+exceptionWithUserInfo:</i> to create an instance.

By default, exception name is its classname. It can be changed by implementing <i>+name</i> method.

## How to install
Use CocoaPods

    pod 'VBException'

or

Drag VBException dir into your project.

## License
VBException is available under the MIT license. See the LICENSE file for more info.
