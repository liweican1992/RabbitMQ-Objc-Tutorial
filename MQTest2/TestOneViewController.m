
#import "TestOneViewController.h"
#import <RMQClient/RMQClient.h>
@interface TestOneViewController (){
    NSInteger count;
}
@property (weak, nonatomic) IBOutlet UITextView *sendTextView;
@property (weak, nonatomic) IBOutlet UITextView *receiveTextView;

@property (weak, nonatomic) IBOutlet UIButton *receiveButton;
@property (strong, nonatomic) RMQConnection * connection;
@end

@implementation TestOneViewController

- (IBAction)sendButtonAction:(id)sender {
    RMQConnection *conn = [[RMQConnection alloc] initWithDelegate:[RMQConnectionDelegateLogger new]];
    [conn start];
    
    id<RMQChannel> ch = [conn createChannel];
    
    RMQQueue *q = [ch queue:@"weican"];
    
    NSString *str = [NSString stringWithFormat:@"Hello World!%ld",(long)++count];
    [ch.defaultExchange publish:[str dataUsingEncoding:NSUTF8StringEncoding] routingKey:q.name];
    NSLog(@"Send %@",str);
    
    self.sendTextView.text = [self.sendTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@ \n",str]];
    CGFloat offset = self.sendTextView.contentSize.height - self.sendTextView.bounds.size.height;
    if (offset > 0)
    {
        [self.sendTextView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
    [conn close];
}
- (IBAction)receiveButtonAction:(UIButton *)sender {
    if (sender.selected) {
        [sender setTitle:@"收取" forState:0];
        [self.connection close];
        self.connection = nil;
        sender.selected = NO;
    }else{
        sender.selected = YES;
        self.connection = [[RMQConnection alloc]initWithDelegate:[RMQConnectionDelegateLogger new]];
        [self.connection start];
        [sender setTitle:@"收取中...点击关闭" forState:0];
        id<RMQChannel> ch = [self.connection createChannel];
        
        RMQQueue *q = [ch queue:@"weican"];
        NSLog(@"Waiting for messages.");
        
        __block NSString *str ;
        __weak __typeof(&*self)weakSelf = self;
        [q subscribe:^(RMQMessage * _Nonnull message) {
            
            NSLog(@"Received %@", [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding]);
            str = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
            [weakSelf performSelectorOnMainThread:@selector(showWithMessage:) withObject:str waitUntilDone:YES];
        }];
    }
}
- (void)showWithMessage:(NSString *)str{
    self.receiveTextView.text = [self.receiveTextView.text stringByAppendingString:str];
    self.receiveTextView.text = [self.receiveTextView.text stringByAppendingString:@" \n"];
    CGFloat offset = self.receiveTextView.contentSize.height - self.receiveTextView.bounds.size.height;
    if (offset > 0)
    {
        [self.receiveTextView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}
@end
