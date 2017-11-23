Custom flow layout to setup collection cells in curves.

## Requirements
- iOS 11.0+ 
- Xcode 9.0+
- Swift 4.0+

## Manual Installation
Copy CurvedFlowLayout.swift to your project.

## Usage
    @IBOutlet weak var flowLayout: CurvedFlowLayout!
    
    override func viewDidLoad() {
       ...
        // Control curve angles
        flowLayout.curveDampner = 6
        
        // Choose shape eg concex, concave,isoscelesTrapezoid.
        flowLayout.shape = .convex
        ...
     }
     
## Demo Gifs
### Convex
![demo](/ScreenShots/Convex-small.gif)

### Concave
![demo](/ScreenShots/Concave-small.gif)

### Trapezoid
![demo](/ScreenShots/Trapezoid-small.gif)


