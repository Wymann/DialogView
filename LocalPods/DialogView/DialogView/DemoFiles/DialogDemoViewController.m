//
//  DialogDemoViewController.m
//  DialogViewDemo
//
//  Created by OwenChen on 2020/10/12.
//

#import "DialogDemoViewController.h"

#import "DialogHeader.h"

#import "UIFont+Dialog.h"

typedef NS_ENUM(NSInteger, DialogType) {
    DialogTypeCommon1 = 0,            // 普通弹框 点击空白处消失
    DialogTypeCommon2 = 1,            // 普通弹框 点击空白处不消失
    DialogTypeCommon3 = 2,            // 普通弹框 可自定义文字颜色
    DialogTypeTextField = 3,          // 带输入框的弹框1
    DialogTypeTextView = 4,           // 带输入框的弹框2
    DialogTypeNetImageBottom = 5,     // 加载网络图片（图片在下）
    DialogTypeLocalImageBottom = 6,   // 加载本地图片（图片在下）
    DialogTypeCustomView = 7,         // 自定义视图
    DialogTypeAttributedSubtitle = 8, // 副标题是富文本
    DialogTypeTopIcon = 9,            // 顶部有icon标示的弹框
    DialogTypeLocalImageTop = 15,     // 顶部有大 icon 标示的弹框
    DialogTypeNetImageTop = 16,       // 顶部有网络图片的弹框
    DialogTypeNetImageTopTime = 17,   // 顶部有网络图片的弹框，且带时间
    DialogTypeShowByPriority = 10,    // 根据优先级依次弹出弹框
    DialogTypeShowBySequence = 11,    // 根据顺序依次弹出弹框
    DialogTypeSingleSelector = 12,    // 单选选择器弹框
    DialogTypeSingleSelector2 = 13,   // 单选选择器弹框2
    DialogTypeMutSelector = 14,       // 多项选择器
    DialogTypeVerticalButtons = 18,   // 垂直布局的按钮
};


@interface DialogDemoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dialogTypes;

@end


@implementation DialogDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dialogTypes = @[@(0), @(18), @(1), @(2), @(3), @(4), @(5), @(6), @(15), @(16), @(17), @(9), @(7), @(8), @(10), @(11), @(12), @(13), @(14)];

    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.navigationItem.title = @"Dialog 示例";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dialogTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DialogCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DialogCell"];
    }

    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont dialog_normalFontWithFontSize:15.0];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont dialog_normalFontWithFontSize:13.0];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    DialogType type = [self.dialogTypes[indexPath.row] integerValue];
    switch (type) {
        case DialogTypeCommon1: {
            cell.textLabel.text = @"普通弹框1";
            cell.detailTextLabel.text = @"点击空白处消失";
        } break;
        case DialogTypeCommon2: {
            cell.textLabel.text = @"普通弹框2";
            cell.detailTextLabel.text = @"点击空白处不消失";
        } break;
        case DialogTypeCommon3: {
            cell.textLabel.text = @"普通弹框3";
            cell.detailTextLabel.text = @"可自定义文字颜色";
        } break;
        case DialogTypeTextField: {
            cell.textLabel.text = @"TextField弹框";
            cell.detailTextLabel.text = @"单行";
        } break;
        case DialogTypeTextView: {
            cell.textLabel.text = @"TextView弹框";
            cell.detailTextLabel.text = @"多行";
        } break;
        case DialogTypeNetImageBottom: {
            cell.textLabel.text = @"图片弹框1";
            cell.detailTextLabel.text = @"加载网络图片（图片在下面）";
        } break;
        case DialogTypeLocalImageBottom: {
            cell.textLabel.text = @"图片弹框2";
            cell.detailTextLabel.text = @"加载本地图片（图片在下面）";
        } break;
        case DialogTypeCustomView: {
            cell.textLabel.text = @"自定义视图弹框";
            cell.detailTextLabel.text = @"弹出自定义视图";
        } break;
        case DialogTypeAttributedSubtitle: {
            cell.textLabel.text = @"副标题是富文本类型";
            cell.detailTextLabel.text = @"富文本显示副标题";
        } break;
        case DialogTypeTopIcon: {
            cell.textLabel.text = @"图片弹框6";
            cell.detailTextLabel.text = @"顶部有icon 100 * 100";
        } break;
        case DialogTypeLocalImageTop: {
            cell.textLabel.text = @"图片弹框3";
            cell.detailTextLabel.text = @"加载本地图片（图片在顶部）";
        } break;
        case DialogTypeNetImageTop: {
            cell.textLabel.text = @"图片弹框4";
            cell.detailTextLabel.text = @"加载网络图片（图片在顶部）";
        } break;
        case DialogTypeNetImageTopTime: {
            cell.textLabel.text = @"图片弹框5";
            cell.detailTextLabel.text = @"加载网络图片（图片在顶部，带时间）";
        } break;
        case DialogTypeShowByPriority: {
            cell.textLabel.text = @"根据不同优先级依次弹出";
            cell.detailTextLabel.text = @"不同优先级";
        } break;
        case DialogTypeShowBySequence: {
            cell.textLabel.text = @"根据顺序依次弹出";
            cell.detailTextLabel.text = @"按照顺序";
        } break;
        case DialogTypeSingleSelector: {
            cell.textLabel.text = @"单选选择弹框";
            cell.detailTextLabel.text = @"单选";
        } break;
        case DialogTypeSingleSelector2: {
            cell.textLabel.text = @"单选选择弹框2";
            cell.detailTextLabel.text = @"单选2";
        } break;
        case DialogTypeMutSelector: {
            cell.textLabel.text = @"多选选择弹框";
            cell.detailTextLabel.text = @"多选";
        } break;
        case DialogTypeVerticalButtons: {
            cell.textLabel.text = @"普通弹框1-1";
            cell.detailTextLabel.text = @"按钮垂直布局";
        } break;
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DialogType type = [self.dialogTypes[indexPath.row] integerValue];
    switch (type) {
        case DialogTypeCommon1: {
            NSArray *buttons = @[@"确定"];
            [Dialog showDialogWithTitle:@"普通弹框1"
                               subtitle:@"有标题、副标题和按钮组成。点击空白处可消失。"
                                buttons:buttons
                            resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                return YES;
                            }];
        } break;
        case DialogTypeVerticalButtons: {
            NSArray *buttons = @[@"确定", @"取消"];
            [Dialog showDialogWithTitle:@"普通弹框1-1"
                               subtitle:@"按钮是垂直布局"
                                buttons:buttons
                      buttonsLayoutType:DialogButtonsLayoutVertical
                            resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                return YES;
                            }];
        } break;
        case DialogTypeCommon2: {
            NSArray *buttons = @[@"取消", @"确定"];
            DialogView *dialogView = [Dialog showDialogWithTitle:@"普通弹框2"
                                                        subtitle:@"有标题、副标题和按钮组成。点击空白处不消失。"
                                                         buttons:buttons
                                                     resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                                         DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                                         return YES;
                                                     }];
            [dialogView sideTapEnable:NO];

            /*
            // 或者
            [Dialog showDialogWithTitle:@"普通弹框2"
                               subtitle:@"有标题、副标题和按钮组成。点击空白处不消失。"
                                buttons:buttons
                            resultBlock:^BOOL(DialogResult *_Nonnull result) {
                if (result.buttonIndex == -1) {
                    return NO;
                }
                DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                return YES;
            }];
             */
        } break;
        case DialogTypeCommon3: {
            NSArray *buttons = @[@"优秀", @"良好", @"差"];
            [Dialog showDialogWithTitle:@"普通弹框2"
                             titleColor:nil
                               subtitle:@"自定义一些文字的颜色"
                          subtitleColor:@"#8B008B"
                                buttons:buttons
                           buttonColors:@[@"#4169E1", @"#1E90FF", @"#00CED1"]
                            resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                return YES;
                            }];
        } break;
        case DialogTypeTextField: {
            NSArray *buttons = @[@"取消", @"确定"];
            DialogView *dialogView = [Dialog showTextFieldDialogWithTitle:@"TextField弹框"
                                                                 subtitle:@"不能输入超过10个字"
                                                                inputText:nil
                                                              placeHolder:@"输入你的昵称"
                                                             keyboardType:UIKeyboardTypeDefault
                                                                  buttons:buttons
                                                              resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                                                  DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                                                  DIALOG_LOG(@"输入框中的文本：%@", result.inputText);
                                                                  return YES;
                                                              }];

            // 可以用于做一些输入限制
            dialogView.textShouldChangeBlock =
                ^TextShouldChangeResModel *_Nullable(id _Nonnull inputView, NSRange changeRange, NSString *_Nonnull replacementText) {
                return [TextShouldChangeResModel modelWithShouldChange:YES tipString:@""];
            };

            __weak typeof(dialogView) weakDialogView = dialogView;

            // 可以用于做一些输入限制
            dialogView.textDidChangeBlock = ^NSString *_Nullable(id _Nonnull inputView) {
                UITextField *textField = (UITextField *)inputView;
                NSString *toBeString = textField.text;

                //获取高亮部分
                UITextRange *selectedRange = [textField markedTextRange];
                UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];

                if (textField.text.length > 0) {
                    [weakDialogView enableButtonAtIndex:1];
                } else {
                    [weakDialogView disabledButtonAtIndex:1];
                }

                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if (!position) {
                    if (toBeString.length > 10) {
                        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:10];
                        if (rangeIndex.length == 1) {
                            textField.text = [toBeString substringToIndex:10];
                        } else {
                            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 10)];
                            textField.text = [toBeString substringWithRange:rangeRange];
                        }
                        return @"输入字符不能超过10个";
                    } else {
                        return @"";
                    }
                } else {
                    return @"";
                }
            };

            // 初始时候让“确定”按钮无法点击
            [dialogView disabledButtonAtIndex:1];

            // 点击空白不消失
            [dialogView sideTapEnable:NO];
        } break;
        case DialogTypeTextView: {
            NSArray *buttons = @[@"取消", @"确定"];
            DialogView *dialogView = [Dialog showTextViewDialogWithTitle:@"TextView弹框"
                                                                subtitle:@"输入不能包含“我”这个字"
                                                               inputText:nil
                                                             placeHolder:@"输入你的建议"
                                                            keyboardType:UIKeyboardTypeDefault
                                                                 buttons:buttons
                                                           maxTextLength:100
                                                             resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                                                 DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                                                 DIALOG_LOG(@"输入框中的文本：%@", result.inputText);
                                                                 return YES;
                                                             }];

            dialogView.textShouldChangeBlock =
                ^TextShouldChangeResModel *_Nullable(id _Nonnull inputView, NSRange changeRange, NSString *_Nonnull replacementText) {
                if ([replacementText containsString:@"我"]) {
                    return [TextShouldChangeResModel modelWithShouldChange:NO tipString:@"输入不能包含“我”这个字"];
                } else {
                    return [TextShouldChangeResModel modelWithShouldChange:YES tipString:@""];
                }
            };
        } break;
        case DialogTypeNetImageBottom: {
            NSArray *buttons = @[@"取消", @"确定"];
            NSString *imageUrl =
                @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1296060925,2049657022&fm=26&gp=0.jpg";
            [Dialog showDialogWithTitle:@"图片弹框1"
                               subtitle:@"加载网络图片"
                               imageUrl:imageUrl
                              imageType:DialogImageTypeCommon
                              imageSize:CGSizeMake(730, 557)
                            placeholder:[UIImage imageNamed:@"PlaceHolderSquare"]
                             errorImage:nil
                                buttons:buttons resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                    DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                    return YES;
                                }];
        } break;
        case DialogTypeLocalImageBottom: {
            NSArray *buttons = @[@"取消", @"确定"];

            [Dialog showDialogWithTitle:@"图片弹框2"
                               subtitle:@"加载本地图片"
                                  image:[UIImage imageNamed:@"AddDeviceError"]
                              imageType:DialogImageTypeCommon
                                buttons:buttons
                            resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                return YES;
                            }];
        } break;
        case DialogTypeCustomView: {
            UILabel *customView = [[UILabel alloc] init];
            customView.text = @"这是一个自定义视图";
            customView.font = [UIFont dialog_boldFontWithFontSize:17.0];
            customView.backgroundColor = [UIColor whiteColor];
            customView.textColor = [UIColor redColor];
            customView.textAlignment = NSTextAlignmentCenter;
            //            [Dialog showDialogWithCustomView:customView customViewHeight:150 resultBlock:nil];
            [Dialog showDialogWithCustomView:customView
                              customViewSize:CGSizeMake(300, 200)
                                 resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                     DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                     return YES;
                                 }];
        } break;
        case DialogTypeAttributedSubtitle: {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                initWithString:@"1: 哈哈哈，哈哈哈，哈哈哈，哈哈哈，哈哈哈\n2: 啦啦啦啦啦\n3: 啦啦啦啦啦点点滴滴\n4: 啦啦啦啦啦大发大发 啥地方\n5: "
                               @"啦啦啦啦啦啦啦啦啦啦啦\n6: 啦啦啦啦啦啦啦啦啦啦啦《TCL*****协议》\n2: 啦啦啦啦啦\n3: 啦啦啦啦啦点点滴滴\n4: "
                               @"啦啦啦啦啦大发大发 啥地方\n2: 啦啦啦啦啦\n3: 啦啦啦啦啦点点滴滴\n4: 啦啦啦啦啦大发大发 啥地方\n2: 啦啦啦啦啦\n3: "
                               @"啦啦啦啦啦点点滴滴\n4: 啦啦啦啦啦大发大发 啥地方\n2: 啦啦啦啦啦\n3: 啦啦啦啦啦点点滴滴\n4: 啦啦啦啦啦大发大发 啥地方"];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, attributedString.string.length)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont dialog_normalFontWithFontSize:14.0] range:NSMakeRange(0, attributedString.string.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]
                                     range:[attributedString.string rangeOfString:@"《TCL*****协议》"]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:6];
            [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
            paragraphStyle.alignment = NSTextAlignmentLeft;
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString.string length])];

            [Dialog showDialogWithTitle:@"富文本弹框"
                     attributedSubtitle:attributedString
                                buttons:@[@"我知道了"]
                            resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                return YES;
                            }];
        } break;
        case DialogTypeTopIcon: {
            //            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
            //                initWithString:@"1: 哈哈哈，哈哈哈，哈哈哈，哈哈哈，哈哈哈\n2: 啦啦啦啦啦\n3: 啦啦啦啦啦点点滴滴\n4: 啦啦啦啦啦大发大发 啥地方\n5: "
            //                               @"啦啦啦啦啦啦啦啦啦啦啦\n6: 啦啦啦啦啦啦啦啦啦啦啦《TCL*****协议》\n2: 啦啦啦啦啦\n3: 啦啦啦啦啦点点滴滴\n4: "
            //                               @"啦啦啦啦啦大发大发 啥地方\n2: 啦啦啦啦啦\n3: 啦啦啦啦啦点点滴滴\n4: 啦啦啦啦啦大发大发 啥地方\n2: 啦啦啦啦啦\n3: "
            //                               @"啦啦啦啦啦点点滴滴\n4: 啦啦啦啦啦大发大发 啥地方\n2: 啦啦啦啦啦\n3: 啦啦啦啦啦点点滴滴\n4: 啦啦啦啦啦大发大发 啥地方"];
            //            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, attributedString.string.length)];
            //            [attributedString addAttribute:NSFontAttributeName value:[UIFont dialog_normalFontWithFontSize:14.0] range:NSMakeRange(0, attributedString.string.length)];
            //            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]
            //                                     range:[attributedString.string rangeOfString:@"《TCL*****协议》"]];
            //            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            //            [paragraphStyle setLineSpacing:6];
            //            [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
            //            paragraphStyle.alignment = NSTextAlignmentLeft;
            //            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString.string length])];
            //
            //            UIImage *topIcon = [UIImage imageNamed:@"Switch_on"];
            //
            //            [Dialog showDialogWithImage:topIcon
            //                              imageType:DialogImageTypeSmall
            //                                  title:@"顶部带Icon富文本（模拟一条很长的标题文字，模拟一条很长的标题文字）"
            //                     attributedSubtitle:attributedString
            //                                buttons:@[@"取消", @"我知道了"]
            //                            resultBlock:^BOOL(DialogResult * _Nonnull result) {
            //                DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
            //                return YES;
            //            }];

            NSString *headurl = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=623994087,1173615898&fm=26&gp=0.jpg";

            [Dialog showDialogWithImageUrl:headurl
                                 imageType:DialogImageTypeSmall
                                 imageSize:CGSizeMake(100, 100)
                               placeholder:[UIImage imageNamed:@"UserIcon_default"]
                                errorImage:nil
                                     title:@"用户名"
                                  subtitle:@"确定分享吗?"
                                   buttons:@[@"取消", @"分享"]
                               resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                   return YES;
                               }];
        } break;
        case DialogTypeLocalImageTop: {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                initWithString:@"1、App启动速度性能提升\n2、优化设备配网速度提升\n3、更多福利活动体验优化"];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor dialog_colorWithHexString:@"#2D3132"] range:NSMakeRange(0, attributedString.string.length)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont dialog_normalFontWithFontSize:16.0] range:NSMakeRange(0, attributedString.string.length)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:6];
            [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
            paragraphStyle.alignment = NSTextAlignmentLeft;
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString.string length])];

            UIImage *topImage = [UIImage imageNamed:@"ForceUpdate"];

            [Dialog showDialogWithImage:topImage
                              imageType:DialogImageTypeLarge
                                  title:@"有新版本啦！"
                     attributedSubtitle:attributedString
                                buttons:@[@"以后", @"版本更新"]
                            resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                return YES;
                            }];
        } break;
        case DialogTypeNetImageTop: {
            NSString *imageUrl = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=623994087,1173615898&fm=26&gp=0.jpg";

            [Dialog showDialogWithImageUrl:imageUrl
                                 imageType:DialogImageTypeCommon
                                 imageSize:CGSizeMake(600, 600)
                               placeholder:[UIImage imageNamed:@"PlaceHolderSquare"]
                                errorImage:nil
                                     title:@"胁迫开门"
                                  subtitle:@"【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！"
                               maxSubLines:3
                                   buttons:@[@"忽略", @"查看门口"]
                              buttonColors:@[@"#000000", @"#FF0000"]
                               resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                   DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                   return YES;
                               }];
        } break;
        case DialogTypeNetImageTopTime: {
            NSString *imageUrl = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=623994087,1173615898&fm=26&gp=0.jpg";

            [Dialog showDialogWithImageUrl:imageUrl
                                 imageType:DialogImageTypeCommon
                                 imageSize:CGSizeMake(600, 400)
                               placeholder:[UIImage imageNamed:@"PlaceHolderSquare"]
                                errorImage:[UIImage imageNamed:@"AddDeviceError"]
                                     title:@"胁迫开门"
                                  timeText:@"2021-06-04 11:12:30"
                                  subtitle:@"【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！【王小丫】使用胁迫指纹开门，可能遇到了危险！"
                               maxSubLines:5
                                   buttons:@[@"忽略", @"查看门口"]
                              buttonColors:@[@"#000000", @"#FF0000"]
                               resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                   DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                   return YES;
                               }];
        } break;
        case DialogTypeShowByPriority: {
            NSArray *buttons1 = @[@"取消", @"确定"];
            DialogView *dialogView1 = [Dialog dialogWithTitle:@"普通弹框1"
                                                     subtitle:@"有标题、副标题和按钮组成。点击空白处可消失。"
                                                      buttons:buttons1
                                                  resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                                      DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                                      return YES;
                                                  }];

            DialogPriorityModel *model1 = [DialogPriorityModel createDialogPriorityModelWithDialogView:dialogView1
                                                                                          priorityType:DialogPriorityA
                                                                                         priorityValue:@(100)];

            NSArray *buttons2 = @[@"取消", @"确定"];
            DialogView *dialogView2 = [Dialog dialogWithTitle:@"普通弹框2"
                                                     subtitle:@"有标题、副标题和按钮组成。点击空白处不消失。"
                                                      buttons:buttons2
                                                  resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                                      DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                                      return YES;
                                                  }];
            [dialogView2 sideTapEnable:NO];
            DialogPriorityModel *model2 = [DialogPriorityModel createDialogPriorityModelWithDialogView:dialogView2
                                                                                          priorityType:DialogPriorityS
                                                                                         priorityValue:@(50)];
            model2.timeOnShow = 5; // 显示5秒时间无操作的话自动消失

            NSArray *buttons3 = @[@"优秀", @"良好", @"差"];
            DialogView *dialogView3 = [Dialog dialogWithTitle:@"普通弹框2"
                                                   titleColor:nil
                                                     subtitle:@"自定义一些文字的颜色"
                                                subtitleColor:@"#8B008B"
                                                      buttons:buttons3
                                                 buttonColors:@[@"#4169E1", @"#1E90FF", @"#00CED1"]
                                                  resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                                      DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                                      return YES;
                                                  }];

            DialogPriorityModel *model3 = [DialogPriorityModel createDialogPriorityModelWithDialogView:dialogView3
                                                                                          priorityType:DialogPriorityA
                                                                                         priorityValue:@(50)];
            model3.timeInQueue = 10; // 在队列中等待的时间

            [Dialog addDialogPriorityModels:@[model1, model2, model3]];
        } break;
        case DialogTypeShowBySequence: {
            NSMutableArray *array = [NSMutableArray array];
            for (NSInteger i = 0; i < 10; i++) {
                NSArray *buttons1 = @[@"取消", @"确定"];
                DialogView *dialogView1 = [Dialog dialogWithTitle:[NSString stringWithFormat:@"普通弹框:%ld", i]
                                                         subtitle:@"有标题、副标题和按钮组成。点击空白处可消失。"
                                                          buttons:buttons1
                                                      resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                                          DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                                          return YES;
                                                      }];
                [array addObject:dialogView1];
            }

            [Dialog addDialogViews:array];
        } break;
        case DialogTypeSingleSelector: {
            NSMutableArray *array = [NSMutableArray array];
            for (NSInteger i = 0; i < 10; i++) {
                NSString *title = [NSString stringWithFormat:@"标题:%ld", i];
                NSString *subtitle = [NSString stringWithFormat:@"副标题:%ld", i];
                SelectorDialogItem *item = [SelectorDialogItem createItemWithTitle:title
                                                                          subtitle:subtitle
                                                                          selected:NO
                                                                           enabled:i != 9];
                [array addObject:item];
            }

            [Dialog showSelectorDialogWithTitle:nil
                                       subtitle:@"**设备需要跟智能家居管理器绑定工作，请选择："
                            selectorDialogItems:array
                                   maxSelectNum:1
                              resultFromItemTap:YES
                                        buttons:nil
                                    resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                        DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                        DIALOG_LOG(@"items:%@", result.selectedItems);
                                        DIALOG_LOG(@"indexs:%@", result.selectedIndexes);
                                        return YES;
                                    }];
        } break;
        case DialogTypeSingleSelector2: {
            NSMutableArray *array = [NSMutableArray array];
            for (NSInteger i = 0; i < 10; i++) {
                NSString *title = [NSString stringWithFormat:@"标题:%ld", i];
                NSString *subtitle = [NSString stringWithFormat:@"副标题:%ld", i];
                SelectorDialogItem *item = [SelectorDialogItem createItemWithTitle:title subtitle:subtitle selected:NO enabled:i != 9];
                [array addObject:item];
            }

            [Dialog showSelectorDialogWithTitle:nil
                                       subtitle:@"**设备需要跟智能家居管理器绑定工作，请选择："
                            selectorDialogItems:array
                                   maxSelectNum:1
                              resultFromItemTap:NO
                                        buttons:@[@"取消", @"确定"]
                                    resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                        DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                        DIALOG_LOG(@"items:%@", result.selectedItems);
                                        DIALOG_LOG(@"indexs:%@", result.selectedIndexes);
                                        return YES;
                                    }];
        } break;
        case DialogTypeMutSelector: {
            NSMutableArray *array = [NSMutableArray array];
            for (NSInteger i = 0; i < 10; i++) {
                NSString *title = [NSString stringWithFormat:@"标题:%ld", i];
                NSString *subtitle = [NSString stringWithFormat:@"副标题:%ld", i];
                SelectorDialogItem *item = [SelectorDialogItem createItemWithTitle:title
                                                                          subtitle:subtitle
                                                                          selected:NO
                                                                           enabled:i != 9];
                [array addObject:item];
            }

            [Dialog showSelectorDialogWithTitle:nil
                                       subtitle:@"多选（最多选择3个），请选择："
                            selectorDialogItems:array
                                   maxSelectNum:3
                              resultFromItemTap:NO
                                        buttons:@[@"取消", @"确定"]
                                    resultBlock:^BOOL(DialogResult *_Nonnull result) {
                                        DIALOG_LOG(@"点击了第 %ld 个按钮：%@", result.buttonIndex, result.buttonTitle);
                                        DIALOG_LOG(@"items:%@", result.selectedItems);
                                        DIALOG_LOG(@"indexs:%@", result.selectedIndexes);
                                        return YES;
                                    }];
        } break;
        default:
            break;
    }
}

@end
