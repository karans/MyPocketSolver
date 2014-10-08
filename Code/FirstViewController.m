//
//  FirstViewController.m
//  MathPicTest2
//
//  Created by Karan Samel on 12/1/13.
//  Copyright (c) 2014 Karan Samel. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
@property (strong, nonatomic) IBOutlet UITextField *data1;
//@property (strong, nonatomic) IBOutlet UITextField *data2;
@property (strong, nonatomic) IBOutlet UITextField *min;
@property (strong, nonatomic) IBOutlet UITextField *Q1;
@property (strong, nonatomic) IBOutlet UITextField *median;
@property (strong, nonatomic) IBOutlet UITextField *Q3;
@property (strong, nonatomic) IBOutlet UITextField *max;
@property (strong, nonatomic) IBOutlet UITextField *mean;
@property (strong, nonatomic) IBOutlet UITextField *stdDev;
@property (strong, nonatomic) IBOutlet UITextField *sum;
@property (strong, nonatomic) IBOutlet UITextField *terms;

@end

@implementation FirstViewController

int commas = 0;
float meanT = 0;
float count = 0;
- (IBAction)VarStats:(UIButton *)sender {
    NSMutableArray* unsorted = [[NSMutableArray alloc] initWithArray:[self getNumbers:_data1.text]];
    NSMutableArray* numbers = [unsorted sortedArrayUsingSelector:@selector(compare:)];
    
    NSLog(@"%@",numbers);
    //start filling in stats
    [self fiveNumberSummary:numbers];
    NSLog(@"finished 5 number summary");
    [self mean:numbers]; //calculates mean and sum
    [self stdDev:numbers];
    _terms.text = [NSString stringWithFormat:@"%i",[numbers count]];

}

/*
- (IBAction)twoVarStats:(UIButton *)sender {

}
*/

- (NSMutableArray*)getNumbers:(NSString *) inString{ // converts the text from data1 to an array and returns
    NSMutableArray* output = [[NSMutableArray alloc] initWithCapacity:100];
    int index1 = 0;
    int index2 = 0;
    NSString* prepare = inString;
    NSString* input = [prepare stringByReplacingOccurrencesOfString:@" " withString:@""];
    for (int i = 0; i < input.length; i++){
        NSString* temp = [NSString stringWithFormat:@"%c" , [input characterAtIndex:i]];
        if ([temp isEqualToString:@","]) {
            index1 = index2;
            index2 = i;
            NSString *result = [input substringWithRange:NSMakeRange(index1, index2-index1)];
            NSString *result2 = [result stringByReplacingOccurrencesOfString:@"," withString:@""];
            [output addObject: [NSNumber numberWithInteger:[result2 integerValue]]];
            commas++;
        }
        if (i == input.length-1) {
            int iterator = i;
            while ([input characterAtIndex:iterator] != ',') {
                iterator--;
            }
            NSString *result = [input substringWithRange:NSMakeRange(iterator, (i-iterator)+1)];
            NSString *result2 = [result stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSLog(@"last number:%@",result2);
            [output addObject: [NSNumber numberWithInteger:[result2 integerValue]]];

        }
    }
    return output;
}

-(void)fiveNumberSummary:(NSMutableArray *) input{
    _min.text = [NSString stringWithFormat:@"%@",[input objectAtIndex:0]];
    _max.text = [NSString stringWithFormat:@"%@",[input objectAtIndex:[input count] -1] ];
    count = [input count];
    float median = 0;
    float q1 = 0;
    float q3 = 0;
    float rangeCheck = 0;
    if([input count]%2 == 1){
        _median.text = [NSString stringWithFormat:@"%@",[input objectAtIndex:[input count]/2]];
        if ([input count] == 5) {
            q1 = ([[input objectAtIndex:0] floatValue] + [[input objectAtIndex:1] floatValue])/2;
            q3 = ([[input objectAtIndex:3] floatValue] + [[input objectAtIndex:4]floatValue])/2;
            _Q1.text = [NSString stringWithFormat:@"%f",q1];
            _Q3.text = [NSString stringWithFormat:@"%f",q3];
            return;
        }
        float oddCount =  count + 1;
        rangeCheck = oddCount/4;
        if (rangeCheck - (int)rangeCheck != 0) {
            NSLog(@"testing odd terms NON mult of 4");
            q1 = ([[input objectAtIndex:(int)rangeCheck - 1] floatValue] + [[input objectAtIndex:(int)rangeCheck] floatValue])/2;
            q3 = ([[input objectAtIndex:(count -(int)rangeCheck - 1)] floatValue] + [[input objectAtIndex:(count -(int)rangeCheck)] floatValue])/2;
            _Q1.text = [NSString stringWithFormat:@"%f",q1];
            _Q3.text = [NSString stringWithFormat:@"%f",q3];
        }
        else{
            NSLog(@"testing odd terms mult of 4");
            q1 = [[input objectAtIndex:(oddCount/4 -1)] doubleValue];
            q3 = [[input objectAtIndex:(count - oddCount/4)] doubleValue];
            
            _Q1.text = [NSString stringWithFormat:@"%f",q1];
            _Q3.text = [NSString stringWithFormat:@"%f",q3];
            
        }
        return;
    
    }
    else{
        median = ([[input objectAtIndex:([input count]/2 -1)] doubleValue] + [[input objectAtIndex:([input count]/2)] doubleValue])/2;
        _median.text = [NSString stringWithFormat:@"%f",median];
        if ([input count] == 2) {
            _Q1.text = [NSString stringWithFormat:@"%@",[input objectAtIndex:0]];
            _Q3.text = [NSString stringWithFormat:@"%@",[input objectAtIndex:1]];
            return;
        }
        rangeCheck = count/4;
        if (rangeCheck - (int)rangeCheck != 0) {
            NSLog(@"testing even terms NON mult of 4");
            _Q1.text = [NSString stringWithFormat:@"%@",[input objectAtIndex:(int)rangeCheck]];
            _Q3.text = [NSString stringWithFormat:@"%@",[input objectAtIndex:([input count] - (int)rangeCheck-1)]];
        }
        else{
            NSLog(@"testing odd terms NON mult of 4");
            q1 = ([[input objectAtIndex:([input count]/4 -1)] doubleValue] + [[input objectAtIndex:([input count]/4)] doubleValue])/2;
            q3 = ([[input objectAtIndex:(count - count/4)] doubleValue] + [[input objectAtIndex:( count - count/4 - 1)] doubleValue])/2;

            _Q1.text = [NSString stringWithFormat:@"%f",q1];
            _Q3.text = [NSString stringWithFormat:@"%f",q3];
                        
        }
        return;
    }
}

-(void)mean:(NSMutableArray *) input{
    float mean = 0;
    for (int i = 0; i < [input count]; i++) {
        mean += [[input objectAtIndex:i] floatValue];
    }
    _sum.text = [NSString stringWithFormat:@"%f",mean];
    _mean.text = [NSString stringWithFormat:@"%f",mean/[input count]];
    meanT = mean/[input count];
}

-(void)stdDev:(NSMutableArray *) input{
    float stdDev = 0;
    for (int i =0; i < [input count]; i++) {
        stdDev += powf(([[input objectAtIndex:i] floatValue]-meanT),2);
    }
    stdDev = powf(stdDev/([input count]-1), .5);
    _stdDev.text = [NSString stringWithFormat:@"%f",stdDev];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.data1.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    //self.data2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
