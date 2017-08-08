//
//  FormSection.h
//  MPMFinance
//
//  Created by Rudy Suharyadi on 6/22/17.
//  Copyright © 2017 MPMFinance. All rights reserved.
//

#import <Realm/Realm.h>
#import "FormRow.h"

@interface FormSection : RLMObject

@property NSString *title;
@property NSInteger sort;
@property BOOL hidden;

@property RLMArray<FormRow> *rows;

@end
RLM_ARRAY_TYPE(FormSection)
