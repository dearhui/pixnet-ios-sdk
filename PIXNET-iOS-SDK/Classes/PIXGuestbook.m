//
//  PIXGuestbook.m
//  PIXNET-iOS-SDK
//
//  Created by Cloud Sung on 2014/4/15.
//  Copyright (c) 2014年 PIXNET. All rights reserved.
//

#import "PIXGuestbook.h"


@implementation PIXGuestbook
-(void)getGuestbookMessagesWithUserName:(NSString *)userName filter:(PIXGuestbookFilter)filter cursor:(NSString *)cursor perPage:(NSUInteger)perPage completion:(PIXHandlerCompletion)completion{
    if (userName==nil || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 參數格式有誤"]);
        return;
    }
    NSString *filterString = nil;
    switch (filter) {
        case PIXGuestbookFilterNoReply:
            filterString = @"noreply";
            break;
        case PIXGuestbookFilterWhisper:
            filterString = @"whisper";
            break;
        default:
            break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:userName forKey:@"user"];
    if (filterString) {
        [params setObject:filterString forKey:@"filter"];
    }
    if (cursor) {
        [params setObject:cursor forKey:@"cursor"];
    }
    if (perPage<1) {
        perPage=20;
    }
    [params setObject:@(perPage) forKey:@"per_page"];
    [self invokeMethod:@selector(callAPI:parameters:requestCompletion:) parameters:@[@"guestbook", params, completion] receiver:[PIXAPIHandler new]];
}
-(void)createGuestbookMessageWithUserName:(NSString *)userName body:(NSString *)body author:(NSString *)author title:(NSString *)title url:(NSString *)url email:(NSString *)email isOpen:(BOOL)isOpen completion:(PIXHandlerCompletion)completion{
    if (userName==nil || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 參數格式有誤"]);
        return;
    }
    if (body==nil || body.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"body 參數格式有誤"]);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:userName forKey:@"user"];
    [params setObject:body forKey:@"body"];
    if (author) {
        [params setObject:author forKey:@"author"];
    }
    if (title) {
        [params setObject:title forKey:@"title"];
    }
    if (url) {
        [params setObject:url forKey:@"url"];
    }
    if (email) {
        [params setObject:email forKey:@"email"];
    }
    [params setObject:[NSString stringWithFormat:@"%i", isOpen] forKey:@"is_open"];
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:uploadData:parameters:requestCompletion:) parameters:@[@"guestbook", @"POST", @YES, [NSNull null], params, completion] receiver:[PIXAPIHandler new]];
}
-(void)deleteGuestbookMessageWithMessageID:(NSString *)messageId completion:(PIXHandlerCompletion)completion{
    if (messageId==nil || messageId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"messageId 參數格式有誤"]);
        return;
    }
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[[NSString stringWithFormat:@"guestbook/%@", messageId], @"POST", @YES, @{@"_method":@"delete"}, completion] receiver:[PIXAPIHandler new]];
}
-(void)getGuestbookMessageWithMessageID:(NSString *)messageId userName:(NSString *)userName completion:(PIXHandlerCompletion)completion{
    if (messageId==nil || messageId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"messageId 參數格式有誤"]);
        return;
    }
    if (userName==nil || userName.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"userName 參數格式有誤"]);
        return;
    }
    NSString *path = [NSString stringWithFormat:@"guestbook/%@", messageId];
    NSDictionary *param = @{@"user": userName};
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"GET", @YES, param, completion] receiver:[PIXAPIHandler new]];
}
-(void)replyGuestbookMessageWithMessageID:(NSString *)messageId body:(NSString *)body completion:(PIXHandlerCompletion)completion{
    if (messageId==nil || messageId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"messageId 參數格式有誤"]);
        return;
    }
    if (body==nil || body.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"body 參數格式有誤"]);
        return;
    }

    NSString *path = [NSString stringWithFormat:@"guestbook/%@/reply", messageId];
    NSDictionary *param = @{@"reply": body};
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, param, completion] receiver:[PIXAPIHandler new]];
}
-(void)markGuestbookMessageAsOpenWithMessageID:(NSString *)messageId completion:(PIXHandlerCompletion)completion{
    [self operateGuestbookMessageWithAction:@"open" messageId:messageId completion:completion];
}
-(void)markGuestbookMessageAsCloseWithMessageID:(NSString *)messageId completion:(PIXHandlerCompletion)completion{
    [self operateGuestbookMessageWithAction:@"close" messageId:messageId completion:completion];
}
-(void)markGuestbookMessageAsSpamWithMessageID:(NSString *)messageId completion:(PIXHandlerCompletion)completion{
    [self operateGuestbookMessageWithAction:@"mark_spam" messageId:messageId completion:completion];
}
-(void)markGuestbookMessageAsHamWithMessageID:(NSString *)messageId completion:(PIXHandlerCompletion)completion{
    [self operateGuestbookMessageWithAction:@"mark_ham" messageId:messageId completion:completion];
}
/**
 *  將留言設定為 公開/悄悄話/廣告/非廣告 的參數都一樣，所以用這個 method 做整合
 */
-(void)operateGuestbookMessageWithAction:(NSString *)action messageId:(NSString *)messageId completion:(PIXHandlerCompletion)completion{
    if (messageId==nil || messageId.length==0) {
        completion(NO, nil, [NSError PIXErrorWithParameterName:@"messageId 參數格式有誤"]);
        return;
    }

    NSString *path = [NSString stringWithFormat:@"guestbook/%@/%@", messageId, action];
    [self invokeMethod:@selector(callAPI:httpMethod:shouldAuth:parameters:requestCompletion:) parameters:@[path, @"POST", @YES, [NSNull null], completion] receiver:[PIXAPIHandler new]];
}
@end
