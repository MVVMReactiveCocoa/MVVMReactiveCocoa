//
//  MRCRepoSettingsViewModel.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 15/5/11.
//  Copyright (c) 2015年 leichunfeng. All rights reserved.
//

#import "MRCRepoSettingsViewModel.h"
#import "MRCUserDetailViewModel.h"

@interface MRCRepoSettingsViewModel ()

@property (strong, nonatomic, readwrite) OCTRepository *repository;

@end

@implementation MRCRepoSettingsViewModel

- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(id)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.repository = params[@"repository"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
    
    self.title = @"Settings";
    
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self)
        if (indexPath.section == 0) {
            NSDictionary *dictionary = @{ @"login": self.repository.ownerLogin ?: @"",
                                          @"avatarURL": self.repository.ownerAvatarURL.absoluteString ?: @"" };
            
            MRCUserDetailViewModel *viewModel = [[MRCUserDetailViewModel alloc] initWithServices:self.services params:@{ @"user": dictionary }];
            [self.services pushViewModel:viewModel animated:YES];
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                return [[self.services client] mrc_starRepository:self.repository];
            } else if (indexPath.row == 1) {
                return [[self.services client] mrc_unstarRepository:self.repository];
            }
        }
        return [RACSignal empty];
    }];
}

@end
