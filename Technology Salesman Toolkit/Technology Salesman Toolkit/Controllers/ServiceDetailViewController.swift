//
//  ServiceDetailViewController.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 11/12/2018.
//  Copyright © 2018 Bram De Coninck. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController {
    
    var serviceId: String!
    var serviceName: String!
    var instructions: [Instruction] = []
    var instructionSlides: [InstructionView] = []

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = serviceName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FirestoreAPI.fetchInstructions(fromService: serviceId) { (instructions) in
            if let instructions = instructions {
                self.updateUI(with: instructions)
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupSlideScrollView()
    }
    
    private func updateUI(with instructions: [Instruction]) {
        DispatchQueue.main.async {
            self.instructions = instructions
            self.instructionSlides = self.createInstructionSlides()
            self.setupSlideScrollView()
        }
    }
    
    private func createInstructionSlides() -> [InstructionView] {
        var slides: [InstructionView] = []
        
        instructions.forEach { (instruction) in
            let slide = Bundle.main.loadNibNamed("InstructionView", owner: self, options: nil)?.first as! InstructionView
            
            slide.titleLabel.text = instruction.title
            slide.descriptionLabel.text = instruction.shortDescription
            slide.contentLabel.text = StringUtils.formatInstructionsList(withContent: instruction.content)
            
            if let link = URL(string: instruction.image) {
                FirebaseUtils.fetchImage(url: link) { (image) in
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
