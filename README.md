# TransitionLearn
转场动画  都还不会 留着慢慢看

<u>iOS7教程系列：自定义导航转场动画以及更多<http://www.cocoachina.com/ios/20131224/7597.html></u>

<u>viewController 转场 <http://objccn.io/issue-5-3/></u>

iOS自定义转场详解01 - UIViewControllerTransition的用法 <http://kittenyang.com/uiviewcontrollertransitioning/>

iOS自定义转场详解02 - 实现Keynote中的神奇效果 <http://kittenyang.com/magicmove/>

iOS自定义转场详解03 - 实现通过圆圈放大缩小的转场动画 <http://kittenyang.com/pingtransition/>

iOS自定义转场详解04 - 实现3D翻转效果 <http://kittenyang.com/3dfliptransition/>

自定义转场动画库 <https://github.com/ColinEberhardt/VCTransitionsLibrary>

<http://www.ios122.com/tag/vctransitionslibrary/>

	//iOS7中增加了2个新的基于block的方法 这样可以很少直接使用Core Animation
    //关键帧动画 只需要将每一帧动画加入到block方法中，并传入此段动画在全过程中的相对开始时间和执行时间
    [UIView animateKeyframesWithDuration:0
                                   delay:0
                                 options:0
                              animations:^{
                                  //addKeyframe添加关键帧到动画执行栈
                                  /**
                                   *  StartTime:相对开始时间 Duration:执行时间
                                   */
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                      //第一帧要执行动画
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                      //第二帧要执行动画
                                                                }];
                                  
                                  
                              } completion:^(BOOL finished) {
                                     //动画结束执行
                              }];
    //弹簧动画
    /**
     :damping 弹性阻尼 越接近0弹性效果越明显 如设成1不会有弹性效果
     :velocity 弹性修正速度 它表示视图在弹跳时恢复原位的速度，例如，如果在动画中视图被
     拉伸的最大距离是200像素，你想让视图以100像素每秒的速度恢复原位，那么就设置velocity的值为0.5
     */
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1.0
                        options:0
                     animations:^{
                         
                     } completion:^(BOOL finished) {
                         
                     }];
                     
                     
                     
## 自定义UIViewController转场动画                   
##### UIViewControllerAnimatedTransitioning

苹果公司提供了一个新的协议：UIViewControllerAnimatedTransitioning，

我们可以在协议方法中编写自定义的动画代码。苹果开发者文档中称实现了此协议的对象为动画控制器

由于我们使用了协议这一语法特性，自定义动画的代码可以灵活的放在自己想要的位置。

你可以创建一个专门用于管理动画的类， 也可以让UIViewController实现UIViewControllerAnimatedTransitioning接口。

由于需要实现一系列不同的动画，因此选择为每个动画创建一个类。接下来创建这些动画类的通用父类——BaseAnimation，

它定义了一些通用的属性和助手方法

	@protocol UIViewControllerAnimatedTransitioning <NSObject>

	- (NSTimeInterval)transitionDuration:(nullable id 	<UIViewControllerContextTransitioning>)transitionContext;
	
	//自定义转场动画
	- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;
	
	//它在动画完成后由系统自动调用，相当于completion block
	@optional
	- (void)animationEnded:(BOOL) transitionCompleted;
	@end


UIViewControllerTransitioning.h中

	UIKIT_EXTERN NSString *const UITransitionContextFromViewControllerKey NS_AVAILABLE_IOS(7_0);
	UIKIT_EXTERN NSString *const UITransitionContextToViewControllerKey NS_AVAILABLE_IOS(7_0);

	UIKIT_EXTERN NSString *const UITransitionContextFromViewKey NS_AVAILABLE_IOS(8_0);
	UIKIT_EXTERN NSString *const UITransitionContextToViewKey NS_AVAILABLE_IOS(8_0);


在animateTransition：中你需要处理以下过程：

1. 将“to”视图插入容器视图
2. 将“to”和“from”视图分别移动到自己想要的位置
3. 最后，在动画完成时千万别忘了调用completeTransition: 方法 这个方法更新viewController的状态

UIViewControllerAnimatedTransitioning协议中的方法都带有一个参数：transitionContext，

这是一个系统级的对象，它符合 UIView-ControllerContextTransitioning协议，

我们可以从该对象中获取用于控制转场动画的必要信息，主要包括以下内容：

![image](https://raw.githubusercontent.com/caodaxun/picture/master/trans.jpg)

现在，我们已经开发好了动画控制器，那么最后需要做的就是，将它们应用到转场动画中：我们需要对管理转场动画的UIViewController做一些操作。

一般来说，我们只需要让UIViewController符合UIViewController-TransitioningDelegate 协议， 编写

animationController-ForPresentedController和animationControllerForDismissedController方法

然后，在推入模态视图控制器时，我们设置modalPresentationStyle为UIModalPresentationFullScreen或

UIModalPresentationCustom。我们还必须将一个符合UIViewControllerTransitioningDelegate

协议的对象设置为它的transitioningDelegate，一般来说都是推入该模态视图控制器的UIViewController

	OptionsViewController *modal = [[OptionsViewController alloc] 
	initWithNibName:@"OptionsViewController" bundle:[NSBundle mainBundle]]; 
	modal.transitioningDelegate = self; 
	modal.modalPresentationStyle = UIModalPresentationCustom; 
	[self presentViewController:modal animated:YES completion:nil];

如果需要将动画控制器应用到UINavigationController的转场动画中，我们需要使用UINavigationControllerDelegate

协议中的一个新方法：animationControllerForOperation,返回自定义的动画对象。对于任何自定义的导航转场动画，

导航栏都会有一个淡入淡出的动画过程。同样，对于UITabBarController，使用UITabBarControllerDelegate

协议的新方法——animationController-ForTransitionFromViewController。


#### 为转场动画定义交互方式

必须从animationControllerForOperation得到一个有效的动画控制器

UINavigationController才会调用interactionController-ForAnimationController

	@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;

	- (void)awakeFromNib {
    	UIPanGestureRecognizer *panReconizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    	[self.navigationController.view addGestureRecognizer:panReconizer];
    	self.animator = [Animator new];
	}

	- (void)pan:(UIPanGestureRecognizer *)recognizer {
    
    	UIView *view = self.navigationController.view;
    	if (recognizer.state == UIGestureRecognizerStateBegan) {
        	CGPoint location = [recognizer locationInView:view];
        	if (location.x > CGRectGetMinX(view.bounds) && self.navigationController.viewControllers.count == 1) {
            	self.interactionController = [UIPercentDrivenInteractiveTransition new];
            
            	//如果不是storyboard 直接使用pushViewController
            	[self.navigationController.visibleViewController performSegueWithIdentifier:PushSegueIdentifier sender:self];
        	}
    	} else if (recognizer.state == UIGestureRecognizerStateChanged) {
        	CGPoint translation = [recognizer translationInView:view];
        	// fabs() 求浮点数的绝对值
        	//根据用户手指拖动的距离计算一个百分比，切换的动画效果也随着这个百分比来走
        	CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        	[self.interactionController updateInteractiveTransition:d];
    	} else if (recognizer.state == UIGestureRecognizerStateEnded) {
        	//根据用户手势的停止状态来判断该操作是结束还是取消
        	//velocityInView 检测手势的速度
        	if ([recognizer velocityInView:view].x < 0) {
            	[self.interactionController finishInteractiveTransition];
        	} else {
            	[self.interactionController cancelInteractiveTransition];
        	}
        	self.interactionController = nil;
    	}
	}





























