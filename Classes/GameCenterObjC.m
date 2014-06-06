//
//  GameCenterObjC.m
//
//  Created by yoshidayuki on 2014/05/28.
//
//

#import "GameCenterObjC.h"

@implementation GameCenterObjC

+(void) loginGameCenter{
    //for iOS6+
    if(floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_6_0){
        GKLocalPlayer* player = [GKLocalPlayer localPlayer];
        UIViewController* rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
        player.authenticateHandler = ^(UIViewController* ui, NSError* error )
        {
            if( nil != ui )
            {
                NSLog(@"Need to login");
                [rootController presentViewController:ui animated:YES completion:nil];
            }
            else if( player.isAuthenticated )
            {
                NSLog(@"Authenticated");
            }
            else
            {
                NSLog(@"Failed");
            }
        };
    }
    //for iOS6-
    else{
        GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
        
        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if(localPlayer.authenticated){
                NSLog(@"Authenticated");
            }
            else{
                NSLog(@"Not authenticated");
            }
        }];

    }
}

+(void) openRanking{
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    if(localPlayer.authenticated){
        UIViewController* rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        GKLeaderboardViewController* leaderboardController = [[GKLeaderboardViewController alloc] init];
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = (id<GKLeaderboardViewControllerDelegate>)rootController;
        
        [rootController presentModalViewController:leaderboardController animated:YES];
        [leaderboardController release];
    }
    else{
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"GameCenterへのログインが必要です。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
}

+(void) postHighScore:(NSString*)key score:(double)score{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if([localPlayer isAuthenticated])
    {
        GKScore *gkScore = [[GKScore alloc]initWithCategory:key];
        gkScore.value = score;
        gkScore.context = 1;
        [gkScore reportScoreWithCompletionHandler:^(NSError *error) {
            if(error)
            {
                NSLog(@"Error : %@",error);
            }
            else
            {
                NSLog(@"Sent highscore.");
            }
        }];
    }
    else
    {
        NSLog(@"Gamecenter not authenticated.");
    }
}
@end
