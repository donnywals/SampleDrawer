//
//  ViewController.swift
//  SampleDrawer
//
//  Created by Donny Wals on 16/07/2018.
//  Copyright © 2018 Donny Wals. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let drawer = UIView()
  let toggleButton = UIButton(type: .system)

  var isDrawerOpen = false
  var drawerPanStart: CGFloat = 0
  var animator: UIViewPropertyAnimator?

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    view.addSubview(drawer)
    drawer.addSubview(toggleButton)

    drawer.translatesAutoresizingMaskIntoConstraints = false
    toggleButton.translatesAutoresizingMaskIntoConstraints = false

    drawer.backgroundColor = .lightGray

    toggleButton.setTitle("Toggle Drawer", for: .normal)
    toggleButton.addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)

    NSLayoutConstraint.activate([
      drawer.widthAnchor.constraint(equalTo: view.widthAnchor),
      drawer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      drawer.heightAnchor.constraint(equalToConstant: 365),
      drawer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 305),
      toggleButton.centerXAnchor.constraint(equalTo: drawer.centerXAnchor),
      toggleButton.topAnchor.constraint(equalTo: drawer.topAnchor, constant: 10)])

    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanOnDrawer(recognizer:)))
    drawer.addGestureRecognizer(panGestureRecognizer)
  }
}

extension ViewController {
  func setUpAnimation() {
    guard animator == nil || animator?.isRunning == false
      else { return }

    let spring: UISpringTimingParameters
    if self.isDrawerOpen {
      spring = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: CGVector(dx: 0, dy: 10))
    } else {
      spring = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: CGVector(dx: 0, dy: -10))
    }

    animator = UIViewPropertyAnimator(duration: 1, timingParameters: spring)

    animator?.addAnimations { [unowned self] in
      if self.isDrawerOpen {
        self.drawer.transform = CGAffineTransform.identity
      } else {
        self.drawer.transform = CGAffineTransform(translationX: 0, y: -305)
      }
    }

    animator?.addCompletion { [unowned self] _ in
      self.animator = nil
      self.isDrawerOpen = !(self.drawer.transform == CGAffineTransform.identity)
    }
  }

  @IBAction func toggleTapped() {
    setUpAnimation()
    animator?.startAnimation()
  }

  @objc func didPanOnDrawer(recognizer: UIPanGestureRecognizer) {
    switch recognizer.state {
    case .began:
      setUpAnimation()
      animator?.pauseAnimation()
      drawerPanStart = animator?.fractionComplete ?? 0
    case .changed:
      if self.isDrawerOpen {
        animator?.fractionComplete = (recognizer.translation(in: drawer).y / 305) + drawerPanStart
      } else {
        animator?.fractionComplete = (recognizer.translation(in: drawer).y / -305) + drawerPanStart
      }
    default:
      drawerPanStart = 0
      let currentVelocity = recognizer.velocity(in: drawer)
      let spring = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: CGVector(dx: 0, dy: currentVelocity.y))

      animator?.continueAnimation(withTimingParameters: spring, durationFactor: 0)
      let isSwipingDown = currentVelocity.y > 0
      if isSwipingDown == !isDrawerOpen {
        animator?.isReversed = true
      }
    }
  }
}

