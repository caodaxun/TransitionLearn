# TransitionLearn
转场动画

iOS7教程系列：自定义导航转场动画以及更多<http://www.cocoachina.com/ios/20131224/7597.html>

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
                     
                     
                     
                     
##### UIViewControllerAnimatedTransitioning

我们可以在协议方法中编写自定义的动画代码

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





















