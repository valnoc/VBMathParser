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

#import "VBStack.h"

@interface VBStack ()

@property (nonatomic, strong) NSMutableArray* storage;

@end

@implementation VBStack

#pragma mark - stack
- (void) pushObject:(id)object {
    [self.storage addObject:object];
}

- (id) popObject {
    id object = self.storage.lastObject;
    [self.storage removeLastObject];
    return object;
}

- (BOOL) isEmpty {
    return self.storage.count == 0;
}

- (id) lastObject {
    return self.storage.lastObject;
}

#pragma mark - helpers
-(NSMutableArray *)storage{
    if (!_storage) {
        _storage = [NSMutableArray new];
    }
    return _storage;
}

-(NSString *)debugDescription{
    return self.storage.description;
}

@end
