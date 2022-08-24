//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    enum AnchorDimension {
        case leading, trailing, top, bottom, x, y
    }

    struct AnchorProduct<D, T: NSLayoutAnchor<D>> {
        let layout: T
        let dimension: AnchorDimension
    }

    struct Alignment {

        let leading: AnchorProduct<NSLayoutXAxisAnchor, NSLayoutAnchor<NSLayoutXAxisAnchor>>
        let trailing: AnchorProduct<NSLayoutXAxisAnchor, NSLayoutAnchor<NSLayoutXAxisAnchor>>
        let top: AnchorProduct<NSLayoutYAxisAnchor, NSLayoutAnchor<NSLayoutYAxisAnchor>>
        let bottom: AnchorProduct<NSLayoutYAxisAnchor, NSLayoutAnchor<NSLayoutYAxisAnchor>>

        init(view: UIView) {
            leading = .init(layout: view.leadingAnchor, dimension: .leading)
            trailing = .init(layout: view.trailingAnchor, dimension: .trailing)
            top = .init(layout: view.topAnchor, dimension: .top)
            bottom = .init(layout: view.bottomAnchor, dimension: .bottom)
        }
    }

    struct Center {
        let x: AnchorProduct<NSLayoutXAxisAnchor, NSLayoutAnchor<NSLayoutXAxisAnchor>>
        let y: AnchorProduct<NSLayoutYAxisAnchor, NSLayoutAnchor<NSLayoutYAxisAnchor>>

        init(view: UIView) {
            x = .init(layout: view.centerXAnchor, dimension: .x)
            y = .init(layout: view.centerYAnchor, dimension: .y)
        }
    }

    struct Size {
        public enum Dimension {
            case width, height
        }

        public struct SizeProduct {
            let layout: NSLayoutDimension
            let dimension: Dimension
        }

        let width: SizeProduct
        let height: SizeProduct

        init(view: UIView) {
            width = .init(layout: view.widthAnchor, dimension: .width)
            height = .init(layout: view.heightAnchor, dimension: .height)
        }
    }

    var center: Center { .init(view: self) }
    var size: Size { .init(view: self) }
    var aligment: Alignment { .init(view: self) }

    private func prepare() {
        if translatesAutoresizingMaskIntoConstraints == true {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setSizeEqual(to view: UIView) {
        apply { [
            aligment.leading.to(view),
            aligment.trailing.to(view),
            aligment.top.to(view),
            aligment.bottom.to(view)
        ] }
    }

    func setSizeEqual(to size: CGSize) {
        apply { [
            self.size.width.constant(size.width),
            self.size.height.constant(size.height)
        ] }
    }

    func center(in view: UIView, size: CGSize) {
        apply { [
            center.y.to(view),
            center.x.to(view),
            self.size.width.constant(size.width),
            self.size.height.constant(size.height)
        ] }
    }

    func apply(_ constraints: () -> [NSLayoutConstraint?]) {
        prepare()
        let applicableConstraints = constraints().compactMap { $0 }
        NSLayoutConstraint.activate(applicableConstraints)
    }
}

public extension UIView.Size.SizeProduct {
    func to(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        switch self.dimension {
        case .height:
            return self.layout.constraint(equalTo: view.heightAnchor, constant: constant)
        case .width:
            return self.layout.constraint(equalTo: view.widthAnchor, constant: constant)
        }
    }

    func lessThanOrEqualTo(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        switch self.dimension {
        case .height:
            return self.layout.constraint(lessThanOrEqualTo: view.heightAnchor, constant: constant)
        case .width:
            return self.layout.constraint(lessThanOrEqualTo: view.widthAnchor, constant: constant)
        }
    }

    func greaterThanOrEqualTo(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        switch self.dimension {
        case .height:
            return self.layout.constraint(greaterThanOrEqualTo: view.heightAnchor, constant: constant)
        case .width:
            return self.layout.constraint(greaterThanOrEqualTo: view.widthAnchor, constant: constant)
        }
    }

    func constant(_ constant: CGFloat) -> NSLayoutConstraint {
        self.layout.constraint(equalToConstant: constant)
    }
}

public extension UIView.AnchorProduct where D == NSLayoutXAxisAnchor {
    func to(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        switch self.dimension {
        case .trailing:
            return self.layout.constraint(equalTo: view.trailingAnchor, constant: constant)
        case .leading:
            return self.layout.constraint(equalTo: view.leadingAnchor, constant: constant)
        case .x:
            return self.layout.constraint(equalTo: view.centerXAnchor, constant: constant)
        default:
            return .init()
        }
    }

    func lessThanOrEqualTo(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        switch self.dimension {
        case .trailing:
            return self.layout.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: constant)
        case .leading:
            return self.layout.constraint(lessThanOrEqualTo: view.leadingAnchor, constant: constant)
        case .x:
            return self.layout.constraint(lessThanOrEqualTo: view.centerXAnchor, constant: constant)
        default:
            return .init()
        }
    }

    func greaterThanOrEqualTo(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        switch self.dimension {
        case .trailing:
            return self.layout.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: constant)
        case .leading:
            return self.layout.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: constant)
        case .x:
            return self.layout.constraint(greaterThanOrEqualTo: view.centerXAnchor, constant: constant)
        default:
            return .init()
        }
    }
}

public extension UIView.AnchorProduct where D == NSLayoutYAxisAnchor {
    func to(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        switch self.dimension {
        case .top:
            return self.layout.constraint(equalTo: view.topAnchor, constant: constant)
        case .bottom:
            return self.layout.constraint(equalTo: view.bottomAnchor, constant: constant)
        case .y:
            return self.layout.constraint(equalTo: view.centerYAnchor, constant: constant)
        default:
            return .init()
        }
    }

    func lessThanOrEqualTo(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        switch self.dimension {
        case .top:
            return self.layout.constraint(lessThanOrEqualTo: view.topAnchor, constant: constant)
        case .bottom:
            return self.layout.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: constant)
        case .y:
            return self.layout.constraint(lessThanOrEqualTo: view.centerYAnchor, constant: constant)
        default:
            return .init()
        }
    }

    func greaterThanOrEqualTo(_ view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        switch self.dimension {
        case .top:
            return self.layout.constraint(greaterThanOrEqualTo: view.topAnchor, constant: constant)
        case .bottom:
            return self.layout.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: constant)
        case .y:
            return self.layout.constraint(greaterThanOrEqualTo: view.centerYAnchor, constant: constant)
        default:
            return .init()
        }
    }
}
