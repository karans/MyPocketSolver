//
//  SecondViewController.m
//  MathPicTest2
//
//  Created by Karan Samel on 12/1/13.
//  Copyright (c) 2014 Karan Samel. All rights reserved.
//

#import "SecondViewController.h"
#import "DDMathParser.h"
@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UITextField *leftSideOfEquation;
@property (weak, nonatomic) IBOutlet UITextField *rightSideOfEquation;
@property (weak, nonatomic) IBOutlet UITextField *answer;
@property (weak, nonatomic) IBOutlet UITextField *answer2;
@property (weak, nonatomic) IBOutlet UITextField *answer3;
@property (weak, nonatomic) IBOutlet UITextField *answer4;
@end

@implementation SecondViewController
- (IBAction)solve:(UIButton *)sender
{
    //sample equation (3+5^x)/4=17x     = .06032 or 3.36804
    _answer.text = @"computing...";
    _answer2.text = NULL;
    _answer3.text = NULL;
    _answer4.text = NULL;
 
    

    
    
    NSLog(self.leftSideOfEquation.text);
    NSLog(self.rightSideOfEquation.text);

    NSMutableString *leftFormula = self.leftSideOfEquation.text;
    NSMutableString *rightFormula = self.rightSideOfEquation.text;
    NSMutableString *x = @"10000";
    NSMutableArray *answers = [[NSMutableArray alloc] init];//addObject: [NSNumber numberWithInt: 0]
    
    //did some parsing myself, things i couldnt figure out so far
    leftFormula = [self parseString:leftFormula];
    //leftFormula = [leftFormula stringByReplacingOccurrencesOfString:@"x" withString:x];
    rightFormula = [self parseString:rightFormula];
    //rightFormula = [rightFormula stringByReplacingOccurrencesOfString:@"x" withString:x];
    
    
    
    //set up the expression and evaluator
    NSError *error = nil;
    DDExpression *e = [DDExpression expressionFromString:leftFormula error:&error];
    DDMathEvaluator *evaluator = [DDMathEvaluator defaultMathEvaluator];
    
    
    //start iterating the equations on both sides till equal to a certain degree
    //with limited memory when doing powers things can get crazy, espcially on phones, so I toned interation down
    NSDictionary *s;
    float iterator;
    float previousIterator = 0;
    float iteratorIterator = 1;
    int exponentialLocation;
    if ([leftFormula rangeOfString:@"**"].location == NSNotFound && [rightFormula rangeOfString:@"**"].location == NSNotFound) {
        s = @{@"x" : @-100000};
        iterator = -100000;

    }
    else{
        s = @{@"x" : @-10000};
        iterator = -10000;
        exponentialLocation = 0;
    }
    
    
    //if you look at two equations, as x values increase, 1 equation will always have higher y values until some point ( a solution), so this starts with the large iteration
    NSNumber *numLeft = [evaluator evaluateString:leftFormula withSubstitutions:s];
    float left = [numLeft floatValue];
    NSLog(@"answer of the left equation is %@",numLeft);
    NSNumber *numRight = [evaluator evaluateString:rightFormula withSubstitutions:s];
    float right = [numRight floatValue];
    NSLog(@"answer of the left equation is %@",numRight);
    
    int stage;
    if (right > left)
        stage = 0;
    else if (right < left)
        stage = 1;
    else
        stage = 2;
    
    double degreeOfError = .0001;
    switch (stage) {
        case 0:
            case0:
            while ((left-right) > degreeOfError || (left-right) < -degreeOfError) {
            while ((left-right) > degreeOfError || (left-right) < -degreeOfError || iterator < 100000) {
                
                if (iterator > 300000) {
                    goto Exitpoint;
                }
                if (previousIterator == iterator) {
                    [answers addObject:[NSNumber numberWithFloat:iterator]];
                    goto Exitpoint;
                }
                previousIterator = iterator;
                s = @{@"x" : @(iterator)};
                NSLog(@"iterator: %f",iterator);
                NSNumber *numLeft = [evaluator evaluateString:leftFormula withSubstitutions:s];
                float left = [numLeft floatValue];
                NSLog(@"(0)answer of the left equation is %@",numLeft);
                NSNumber *numRight = [evaluator evaluateString:rightFormula withSubstitutions:s];
                float right = [numRight floatValue];
                NSLog(@"(0)answer of the right equation is %@",numRight);
                
                if ((left-right) < degreeOfError && (left-right) > -degreeOfError) {
                    if([answers containsObject:[NSNumber numberWithFloat:iterator]]){
                        NSLog(@"ANSWER ALREADY FOUND, EXITING: %f",iterator);
                        stage = 3;
                        goto Exitpoint;
                        break;
                    }
                    [answers addObject:[NSNumber numberWithFloat:iterator]];
                    NSLog(@"ANSWER FOUND: %f",iterator);
                    iterator = fabsf(iterator);
                    iteratorIterator = 1;
                    stage =1;
                    goto case1;
                    break;
                }
                if (right < left) {
                    break;
                }
                iterator+= (50 /iteratorIterator);
            }
            iterator -= (50 /iteratorIterator);
            iteratorIterator*=10;
            }
            break;
            
        case 1:
            case1:
            while ((left-right) > degreeOfError || (left-right) < -degreeOfError) {
                while ((left-right) > degreeOfError || (left-right) < -degreeOfError || iterator < 100000) {
                    
                    if (iterator > 300000) {
                        goto Exitpoint;
                    }
                    if (previousIterator == iterator) {
                        [answers addObject:[NSNumber numberWithFloat:iterator]];
                        goto Exitpoint;
                    }
                    previousIterator = iterator;
                    s = @{@"x" : @(iterator)};
                    NSLog(@"iterator: %f",iterator);
                    NSNumber *numLeft = [evaluator evaluateString:leftFormula withSubstitutions:s];
                    float left = [numLeft floatValue];
                    NSLog(@"(1)answer of the left equation is %@",numLeft);
                    NSNumber *numRight = [evaluator evaluateString:rightFormula withSubstitutions:s];
                    float right = [numRight floatValue];
                    NSLog(@"(1)answer of the right equation is %@",numRight);
                    if ((left-right) < degreeOfError && (left-right) > -degreeOfError) {
                        if([answers containsObject:[NSNumber numberWithFloat:iterator]]){
                            NSLog(@"ANSWER ALREADY FOUND, EXITING: %f",iterator);

                            stage = 3;
                            goto Exitpoint;
                            break;
                        }
                        [answers addObject:[NSNumber numberWithFloat:iterator]];
                        NSLog(@"ANSWER FOUND: %f",iterator);
                        iterator = fabsf(iterator);
                        iteratorIterator = 1;
                        stage =0;
                        goto case0;
                        break;
                    }
                    if (right > left) {
                        break;
                    }
                    iterator+= (50 /iteratorIterator);
                }
                iterator -= (50 /iteratorIterator);
                iteratorIterator*=10;
            }
            break;
            
        case 2:
            //somehow that was the answer...
            [answers addObject:[NSNumber numberWithFloat:right]];
            break;
            
        case 3:
            NSLog(@"ALL SOLUTIONS FOUND!!!!!!");
        default:
            _answer.text = @"no solutions found";
            break;
    }

    Exitpoint:
    NSLog(@"fell out of loop");
    if(answers.count == 0)
        _answer.text = @"Solutions not found";
    if(answers.count >= 1){
        NSLog(@"first answer: %@",answers[0]);
        _answer.text  = [answers[0] stringValue];
    }
    if(answers.count >= 2){
        NSLog(@"second answer: %@",answers[1]);
        if (fabsf([answers[1] floatValue] - [answers[0] floatValue]) <= .0001) {
            _answer2.text = @"";
        }
        else{
        _answer2.text = [answers[1] stringValue];
        }
    }
    if(answers.count >= 3){
        NSLog(@"second answer: %@",answers[1]);
        _answer3.text = [answers[2] stringValue];
    }
    if(answers.count >= 4){
        NSLog(@"second answer: %@",answers[1]);
        _answer4.text = [answers[3] stringValue];
    }
}



-(NSMutableString*)parseString:(NSMutableString*)formula{
    for(int i = 0; i < formula.length; i++){
        NSLog(@"current character:%c", [formula characterAtIndex:i]);
        //if there are values like 8x instead of 8*x
        if ([formula characterAtIndex:i] == 'x') {
            if ([formula characterAtIndex:(i-1)]>='0' && [formula characterAtIndex:(i-1)]<='9'){
                formula = [formula stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*x"];
            }
        }

    }
    formula = [formula stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    formula = [formula stringByReplacingOccurrencesOfString:@"x" withString:@"$x"];

    NSLog(@"my parsed string: %@",formula);
    return formula;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.leftSideOfEquation.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.rightSideOfEquation.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
