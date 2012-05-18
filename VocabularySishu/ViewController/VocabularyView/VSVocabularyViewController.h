//
//  VSVocabularyViewController.h
//  VocabularySishu
//
//  Created by xiao xiao on 12-5-4.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSVocabularyViewController : UIViewController {
    IBOutlet UILabel *vocabularyLabel;
    IBOutlet UILabel *phoneticLabel;
}

@property (nonatomic, strong) UILabel *vocabularyLabel;
@property (nonatomic, strong) UILabel *phoneticLabel;
@property (nonatomic, strong) UINavigationController *navigationController;

- (IBAction)randomClick:(id)sender;

- (IBAction)clickShow:(id)sender;

@end
