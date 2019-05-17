# ShadowCornerView

因为平时设置圆角和阴影使用 masksToBounds 会冲突 ，并且不能想设置哪个圆角就设置哪个圆角，
所以花时间写了一个带任意几边阴影和几个角圆角的view，方便以后自由设置
方法也很简单，就是下面的例子

//使用例子
 UIView * v = [[UIView alloc] init];
 v.backgroundColor = [UIColor whiteColor];
 v.viewShadowCorner = ShadowTop|ShadowBottom|ShadowRight|CornerTopRight|CornerTopLeft|CornerBottomLeft|CornerType10;//0x10b7;
 
 UIView * shadowView = [ShadowCornerView viewWithContentView:v];
 [self.view addSubview:shadowView];
 
 [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
 make.centerX.equalTo(self.view.mas_centerX);
 make.centerY.equalTo(self.view.mas_centerY);
 make.width.height.equalTo(@100);
