//
//  ViewController.swift
//  DrawTelegram
//
//  Created by Ivan Petukhov on 11/10/2022.
//

import UIKit
import PencilKit
import Lottie
import PhotosUI

class InitialViewController: UIViewController {

    var contentView: UIView!

    var animationView: LottieAnimationView!
    var label: UILabel!
    var allowAccessButton: UIButton!

    let buttonTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
        NSAttributedString.Key.kern: 0.24
    ]

    let labelTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold),
        NSAttributedString.Key.kern: 0.24
    ]

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        addSubviews()

        contentView.constraintOnYAxis(with: view)
        contentView.constraintToHorizontalEdges(in: view)

        animationView.frame = .init(origin: .zero, size: .init(width: CGFloat.greatestFiniteMagnitude,
                height: 320))
        animationView.constraintTop(to: contentView, with: 20)
        animationView.constraintOnXAxis(with: contentView)
        animationView.constraintBottom(toTopOf: label, with: -16)
        animationView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([animationView.heightAnchor.constraint(lessThanOrEqualToConstant: 160)])

        label.attributedText = .init(string: "Access your Photos and Videos", attributes: labelTextAttributes)
        label.constraintOnXAxis(with: contentView)
        label.constraint(height: 52)
        label.constraintBottom(toTopOf: allowAccessButton, with: -16)

        allowAccessButton.setAttributedTitle(.init(string: "Allow Access", attributes: buttonTextAttributes), for: .normal)
        allowAccessButton.backgroundColor = .systemBlue
        allowAccessButton.layer.cornerRadius = 8
        allowAccessButton.constraintToHorizontalEdges(in: contentView, with: 20)
        allowAccessButton.constraint(height: 48)
        allowAccessButton.constraintBottom(to: contentView)
        allowAccessButton.addTarget(self, action: #selector(allowAccess), for: .touchUpInside)
    }

    private func addSubviews() {
        contentView = UIView()
        view.addSubview(contentView)

        animationView =  LottieAnimationView(name: "duck")
        contentView.addSubview(animationView)

        label = UILabel()
        contentView.addSubview(label)

        allowAccessButton =
                .init(frame: .init(origin: .zero,
                        size: .init(
                                width: CGFloat.greatestFiniteMagnitude,
                                height: 50)))
        contentView.addSubview(allowAccessButton)

        [contentView, animationView, label, allowAccessButton].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }

    @objc func allowAccess(sender: Any) {
//        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] (status) in
//            DispatchQueue.main.async { [unowned self] in
//                showUI(for: status)
//            }
//        }
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {
                    DispatchQueue.main.async { [unowned self] in
                        self?.navigationController?.setViewControllers([PhotoCollectionViewController()], animated: true)

                    }

                } else {

                }
            }
        }
    }
}
