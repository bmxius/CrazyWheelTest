//
//  DetailViewController.m
//  CrazyWheel
//
//  Created by Stig on 25.11.14.
//  Copyright (c) 2014 YESS. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextView *textViewDetail;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _labelTitle.text = _dictionaryDetail[@"title"];
    _textViewDetail.text = _dictionaryDetail[@"text"];
}


@end
