//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Valeriy Bezuglyy.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

#import <Foundation/Foundation.h>

/**
 *  VBException is a base class for your own exceptions. It makes exception creation and handling more effective.
 *
 *  Use case
 *  1. Create VBException subclass.
 *  2. Implement <i>+reasonWithUserInfo:</i> method.
 *  3. Call <i>+exception:</i> or <i>+exceptionWithUserInfo:</i> to create an instance.
 *
 *  By default, exception name is its classname. It can be changed by implementing <i>+name</i> method.
 *
 */
@interface VBException : NSException

/**
 *  The main method for exception creation.
 *  Calls @code +exceptionWithUserInfo:nil @endcode
 *  You should NOT override this method.
 *
 *  @return The created exception object or nil if the object couldn't be created.
 */
+ (instancetype) exception;

/**
 *  Creates exception with userInfo.
 *  You should NOT override this method.
 *
 *  @param userInfo User-defined exception information.
 *
 *  @return The created exception object or nil if the object couldn't be created.
 */
+ (instancetype) exceptionWithUserInfo:(NSDictionary*)userInfo;

/**
 *  The reason for exception. Override this method in subclasses. You can use userInfo dictionary to provide more useful reason string format.
 *
 *  @param userInfo User-defined exception information. Use given userInfo to provide stringWithFormat: reasons.
 *
 *  @return NSString to be used as exception reason.
 */
+ (NSString*) reasonWithUserInfo:(NSDictionary*)userInfo;

/**
 *  Exception name.
 *  By default, exception name is its classname.
 *
 *  @return NSString to be used as exception name. NSStringFromClass, by default.
 */
+ (NSString*) name;

@end
