//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//////////////////////////////////////////////////////////////////////////////////////

#import "KeyboardSize.h"


#pragma mark - KeyboardSize

DEFINE_ANE_FUNCTION(getKeyboardY)
{
    return NULL;
}

DEFINE_ANE_FUNCTION(getKeyboardHeight)
{
    return NULL;
}

DEFINE_ANE_FUNCTION(setSoftInputMode)
{
    return NULL;
}

DEFINE_ANE_FUNCTION(removeClearButtonForiOS)
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    
    setClearButtonMode(topView);
    return NULL;
}

DEFINE_ANE_FUNCTION(getMultilineTextViewHeight)
{
    FREObject ret = NULL;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    
    double height ;
    height = getTextViewHeight(topView);
    
    FRENewObjectFromDouble(height, &ret);
    return ret;
}

void setClearButtonMode(UIView *view)
{
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        //NSLog(@"%@", subview);
        if ([subview isKindOfClass:[UITextField class]])
        {
            //NSLog(@"TextField found");
            UITextField* textField= (UITextField*) subview;
            textField.clearButtonMode=UITextFieldViewModeNever;
        }
        setClearButtonMode(subview);
    }
}

double textViewHeight = 0;
double getTextViewHeight(UIView *view)
{
    NSArray *subviews = [view subviews];
    
    for (UIView *subview in subviews) {
        
        //NSLog(@"%@", subview);
        if ([subview isKindOfClass:[UITextView class]])
        {
            //NSLog(@"TextView found");
            UITextView* textView= (UITextView*) subview;
            textViewHeight = textView.contentSize.height;
            //NSLog(@"%f", textViewHeight);
            //break;
        }
        getTextViewHeight(subview);
    }
    return textViewHeight;
}


#pragma mark - C interface

void KeyboardSizeContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functionsToSet)
{
    *numFunctions = 5;
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctions);
    
    func[0].name = (const uint8_t*)"getKeyboardY";
    func[0].functionData = NULL;
    func[0].function = &getKeyboardY;
    
    func[1].name = (const uint8_t*)"getKeyboardHeight";
    func[1].functionData = NULL;
    func[1].function = &getKeyboardHeight;
    
    func[2].name = (const uint8_t*)"setSoftInputMode";
    func[2].functionData = NULL;
    func[2].function = &setSoftInputMode;
    
    func[3].name = (const uint8_t*)"removeClearButtonForiOS";
    func[3].functionData = NULL;
    func[3].function = &removeClearButtonForiOS;
    
    func[4].name = (const uint8_t*)"getMultilineTextViewHeight";
    func[4].functionData = NULL;
    func[4].function = &getMultilineTextViewHeight;
    
    *functionsToSet = func;
}

void KeyboardSizeContextFinalizer(FREContext ctx) { }

void KeyboardSizeInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &KeyboardSizeContextInitializer;
}

void KeyboardSizeFinalizer(void *extData) { }
