# Popover
Popover is an UIPopoverController like control for iOS.

### How does it look like?

<p align="left">

<img src="./ScreenShoots/1.gif" width=40%"> 
<img src="./ScreenShoots/2.gif" width=40%"> 

</p>

### How to use

```swift
import PopoverSwift

// In view controller
let image = UIImage(named: "collection_hightlight")
let item0 = PopoverItem(title: "发起群聊", image: image) { debugPrint($0.title) }
let item1 = PopoverItem(title: "添加胖友", image: image) { debugPrint($0.title) }
let item2 = PopoverItem(title: "扫一扫", image: image) { debugPrint($0.title) }
let item3 = PopoverItem(title: "收付款", image: image) { debugPrint($0.title) }
let items = [item0, item1, item2, item3]

let controller = PopoverController(items: items, fromView: rightTopButton, direction: .Down, style: .WithImage)
popover(controller)        
```
### Notice

-   v0.x for swift 2.2
-   v1.x for swift2.3
-   v2.x for swift3.x