//
// Created by Ivan Petukhov on 13/10/2022.
//

import UIKit

extension UIView {
    func constraintToHorizontalEdges(in superview: UIView, with padding: CGFloat = 0) {
        let trailingAnchor = trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding)
        let leadingAnchor = leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding)
        NSLayoutConstraint.activate([trailingAnchor, leadingAnchor])
    }

    func constraintOnYAxis(with superview: UIView) {
        NSLayoutConstraint.activate([centerYAnchor.constraint(equalTo: superview.centerYAnchor)])
    }

    func constraintOnXAxis(with superview: UIView) {
        NSLayoutConstraint.activate([centerXAnchor.constraint(equalTo: superview.centerXAnchor)])
    }

    func constraint(height: CGFloat) {
        NSLayoutConstraint.activate([heightAnchor.constraint(equalToConstant: 48)])
    }

    func constraintBottom(toTopOf view: UIView, with padding: CGFloat = 0) {
        NSLayoutConstraint.activate([bottomAnchor.constraint(equalTo: view.topAnchor, constant: padding)])
    }

    func constraintBottom(to view: UIView, with padding: CGFloat = 0) {
        NSLayoutConstraint.activate([bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding)])
    }

    func constraintTop(to view: UIView, with padding: CGFloat = 0) {
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor, constant: padding)])
    }

    func constraint(toCenterOf view: UIView) {
        constraintOnYAxis(with: view)
        constraintOnXAxis(with: view)
    }

    func constraint(to superView: UIView) {
        constraintToHorizontalEdges(in: superView)
        constraintTop(to: superView)
        constraintBottom(to: superView)
    }
}