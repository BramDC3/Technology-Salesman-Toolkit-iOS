import UIKit

/**
 The detail screen of a service It contains a list of
 instructions that belong to the service.
 */
class ServiceDetailViewController: UIViewController {
    
    /// Service which instructions are displayed.
    var service: Service!
    
    /// Instructions of the selected service.
    var instructions: [Instruction] = []
    
    /// Slides created to displayed the instructions in a 'ViewPager'.
    var instructionSlides: [InstructionView] = []

    /// Contains all instruction slides and is used as a 'ViewPager'.
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = service.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /// Adding an observer that gets notified when the instructions are fetched.
        /// SOURCE: https://learnappmaking.com/notification-center-how-to-swift/
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveNotification(_:)), name: .didFetchInstructions, object: nil)
        
        InstructionController.instance.setServiceId(to: service.id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /// Removing the observer that gets notified when the instructions are fetched.
        /// SOURCE: https://learnappmaking.com/notification-center-how-to-swift/
        NotificationCenter.default.removeObserver(self, name: .didFetchServices, object: nil)
    }
    
    /// Function that gets called when the user rotates his/her device.
    /// The instruction slides need to be reorganised to be displayed properly.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.setupSlideScrollView()
        }
    }
    
    /// Called when the observer is notified.
    /// SOURCE: https://www.raywenderlich.com/472-uisearchcontroller-tutorial-getting-started
    @objc private func onReceiveNotification(_ notification: Notification) {
        updateUI()
    }
    
    /// Ferches the latest instructions, builds the slides and sets up the 'ViewPager'.
    private func updateUI() {
        DispatchQueue.main.async {
            self.instructions = InstructionController.instance.getInstructions()
            self.instructionSlides = self.createInstructionSlides()
            self.setupSlideScrollView()
        }
    }
    
    /// Filling instruction views with the data of the instructions.
    private func createInstructionSlides() -> [InstructionView] {
        var slides: [InstructionView] = []
        
        instructions.forEach { (instruction) in
            let slide = Bundle.main.loadNibNamed("InstructionView", owner: self, options: nil)?.first as! InstructionView
            
            slide.titleLabel.text = instruction.title
            slide.descriptionLabel.text = instruction.shortDescription
            slide.contentLabel.text = StringUtils.formattingInstructionsList(with: instruction.content)
            
            if let link = URL(string: instruction.image) {
                FirebaseUtils.fetchImage(with: link) { (image) in
                    guard let image = image else { return }
                    DispatchQueue.main.async {
                        slide.imageView.image = image
                    }
                }
            }
            
            slides.append(slide)
        }
        
        return slides
    }
    
    /// Setting up the 'ViewPager'
    /// SOURCE: https://medium.com/@anitaa_1990/create-a-horizontal-paging-uiscrollview-with-uipagecontrol-swift-4-xcode-9-a3dddc845e92
    private func setupSlideScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(instructionSlides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< instructionSlides.count {
            instructionSlides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(instructionSlides[i])
        }
    }

}
