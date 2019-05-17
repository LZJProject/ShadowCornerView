# ShadowCornerView

因为平时设置圆角和阴影使用 masksToBounds 会冲突 ，并且不能想设置哪个圆角就设置哪个圆角，<br>
所以花时间写了一个带任意几边阴影和几个角圆角的view，方便以后自由设置<br>
方法也很简单，就是下面的例子<br>

//使用例子
 UIView * v = [[UIView alloc] init];<br>
 v.backgroundColor = [UIColor whiteColor];<br>
 v.viewShadowCorner = ShadowTop|ShadowBottom|ShadowRight|CornerTopRight|CornerTopLeft|CornerBottomLeft|CornerType10;<br>
 UIView * shadowView = [ShadowCornerView viewWithContentView:v];<br>
 [self.view addSubview:shadowView];<br>
 [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {<br>
 make.centerX.equalTo(self.view.mas_centerX);<br>
 make.centerY.equalTo(self.view.mas_centerY);<br>
 make.width.height.equalTo(@100);<br>
	}];
