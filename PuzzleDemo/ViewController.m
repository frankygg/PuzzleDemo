//
//  ViewController.m
//  PuzzleDemo
//
//  Created by BoTingDing on 2018/11/19.
//  Copyright © 2018年 btding. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) PuzzleView *gameView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic) CGSize tapLocation;
@property (nonatomic) NSMutableArray *fieldArray;
@property (nonatomic) NSMutableArray *textFieldLocation;
@property (nonatomic) CGPoint originalCenter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat maxWidth = self.view.bounds.size.width;
    CGFloat maxHeight = self.view.bounds.size.height;
    CGRect displayRect;
    self.tapLocation = CGSizeMake(NSNotFound, NSNotFound);
    displayRect = CGRectMake(0, 0, maxWidth, maxHeight);
    self.gameView = [[PuzzleView alloc] initWithFrame:displayRect];
    [self.view addSubview: self.gameView];
    [self setupGestures];
    [self setUpTextField];
    [self initializeArray];
    self.textFieldLocation = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    self.originalCenter = self.gameView.center;
}

- (void)keyboardDidShow:(NSNotification *)note
{
    CGFloat tapXcoordinate = floor(self.tapLocation.width * 8 / self.view.bounds.size.width);
    CGFloat tapYcoordinate = floor(self.tapLocation.height * 8 / self.view.bounds.size.height);
    CGFloat ycoordinate = ceil(self.tapLocation.height * 8 / self.view.bounds.size.height) * self.view.bounds.size.height / 8;
    CGFloat cellDistance = self.view.bounds.size.height - ycoordinate;
    NSDictionary* info      = [note userInfo];
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    CGFloat gapDistance = keyboardFrame.size.height - cellDistance;
    CGFloat rectWidth = self.view.bounds.size.width / 8;
    CGFloat rectHeigth = self.view.bounds.size.height / 8;
    [self.textField setFrame:CGRectMake(rectWidth*tapXcoordinate, gapDistance > 0 ? rectHeigth*tapYcoordinate - gapDistance : rectHeigth*tapYcoordinate, rectWidth, rectHeigth)];
    if (gapDistance > 0) {
        self.gameView.center = CGPointMake(self.originalCenter.x, self.originalCenter.y - gapDistance);
    }
}

- (void)keyboardDidHide:(NSNotification *)note
{
    self.gameView.center = self.originalCenter;
}

- (void)setupGestures
{
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tapGuesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGuesture];
    self.gameView.delegate = self;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    [self.textFieldLocation removeAllObjects];
    CGPoint coordinate = [gestureRecognizer locationOfTouch:0 inView:self.view];
    self.tapLocation = CGSizeMake(coordinate.x, coordinate.y);
    NSLog(@"The coordinate is (%f, %f)", coordinate.x, coordinate.y);
    CGFloat tapXcoordinate = floor(self.tapLocation.width * 8 / self.view.bounds.size.width);
    CGFloat tapYcoordinate = floor(self.tapLocation.height * 8 / self.view.bounds.size.height);
    [self.textField setText:[self.fieldArray objectAtIndex:tapXcoordinate * 8 + tapYcoordinate]];
    [self.textFieldLocation addObject:[NSString stringWithFormat:@"%f", tapXcoordinate]];
    [self.textFieldLocation addObject:[NSString stringWithFormat:@"%f", tapYcoordinate]];
    [self.gameView setNeedsDisplay];
    [self.textField becomeFirstResponder];
}

- (NSMutableArray *)contentForView:(PuzzleView *)view
{
    return self.fieldArray;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= 1 || returnKey;
}

- (void)setUpTextField
{
    CGFloat rectWidth = self.view.bounds.size.width / 8;
    CGFloat rectHeigth = self.view.bounds.size.height / 8;
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(NSNotFound, NSNotFound, rectWidth, rectHeigth)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.font = [UIFont systemFontOfSize:25];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
}

- (void)initializeArray
{
    self.fieldArray = [[NSMutableArray alloc] initWithCapacity:64];
    for (int i=0; i<=7; i++) {
        for (int j=0; j<=7; j++) {
            [self.fieldArray addObject:@""];
        }
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger i = [[self.textFieldLocation objectAtIndex:0] integerValue];
    NSInteger j = [[self.textFieldLocation objectAtIndex:1] integerValue];
    [self.fieldArray replaceObjectAtIndex:(i * 8) + j withObject:textField.text];
    [self.textFieldLocation removeAllObjects];
    [self.textField setFrame:CGRectMake(NSNotFound, NSNotFound, 0, 0)];
    [self.gameView setNeedsDisplay];
}
@end
