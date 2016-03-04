//
//  ViewController.swift
//  LetsPlayWithAccessibility
//
//  Created by Zach Costa on 3/3/16.
//  Copyright © 2016 WillowTree. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    var string: String? {
        didSet {
            label.text = string
        }
    }
    @IBOutlet weak var label: UILabel!

    override var isAccessibilityElement: Bool {
        get { return true }
        set {}
    }

    override var accessibilityLabel: String? {
        get { return string!}
        set { }
    }
}

class ContainerCell: UICollectionViewCell {
}


class InnerViewController: UICollectionViewController {

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! Cell
        cell.string = String(indexPath.item)
        return cell

    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

}

class ShellViewController: UIViewController {

}

class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        collectionView?.registerNib(UINib(nibName: "Cell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView?.registerNib(UINib(nibName: "ContainerCell", bundle: nil), forCellWithReuseIdentifier: "ContainerCell")
    }


    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ContainerCell", forIndexPath: indexPath)

            let bundle = NSBundle(forClass: ShellViewController.self)
            let storyboard = UIStoryboard(name: "Main", bundle: bundle)
            let controller = storyboard.instantiateViewControllerWithIdentifier("ShellViewController") as! ShellViewController

            self.addChild(controller, toView: cell)

            let controller2 = storyboard.instantiateViewControllerWithIdentifier("InnerViewController") as! InnerViewController

            controller.addChild(controller2, toView: controller.view)
            return cell
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! Cell
        cell.string = String(indexPath.item)
        return cell

    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

}

extension UIViewController {
    func addChild(child: UIViewController, toView view: UIView) {
        child.view.translatesAutoresizingMaskIntoConstraints = false

        var top: NSLayoutConstraint
        if child.edgesForExtendedLayout.contains(.Top) {
            top = NSLayoutConstraint(item: child.view, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        } else {
            top = NSLayoutConstraint(item: child.view, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        }

        var bottom: NSLayoutConstraint
        if child.edgesForExtendedLayout.contains(.Bottom) {
            bottom = NSLayoutConstraint(item: child.view, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        } else {
            bottom = NSLayoutConstraint(item: child.view, attribute: .Bottom, relatedBy: .Equal, toItem: bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: 0.0)
        }

        let left = NSLayoutConstraint(item: child.view, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: child.view, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: 0.0)

        self.addChildViewController(child)
        view.addSubview(child.view)
        NSLayoutConstraint.activateConstraints([top, right, bottom, left])
        child.didMoveToParentViewController(self)
    }
}