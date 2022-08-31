//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//

import Foundation
import UIKit

public struct Paver {
  public let size: UIView.Size
  public let alignment: UIView.Alignment
  public let center: UIView.Center
  
  internal init(size: UIView.Size,
               alignment: UIView.Alignment,
               center: UIView.Center) {
    self.size = size
    self.alignment = alignment
    self.center = center
  }
  
  internal init(view: UIView) {
    self.size = UIView.Size.init(view: view)
    self.alignment = UIView.Alignment.init(view: view)
    self.center = UIView.Center.init(view: view)
  }
}

public extension UIView {
  enum AnchorDimension {
    case leading, trailing, top, bottom, x, y
  }
  
  struct AnchorProduct<D, T: NSLayoutAnchor<D>> {
    public let layout: T
    public let dimension: AnchorDimension
  }
  
  struct Alignment {
    
    public let leading: AnchorProduct<NSLayoutXAxisAnchor, NSLayoutAnchor<NSLayoutXAxisAnchor>>
    public let trailing: AnchorProduct<NSLayoutXAxisAnchor, NSLayoutAnchor<NSLayoutXAxisAnchor>>
    public let top: AnchorProduct<NSLayoutYAxisAnchor, NSLayoutAnchor<NSLayoutYAxisAnchor>>
    public let bottom: AnchorProduct<NSLayoutYAxisAnchor, NSLayoutAnchor<NSLayoutYAxisAnchor>>
    
    init(view: UIView) {
      leading = .init(layout: view.leadingAnchor, dimension: .leading)
      trailing = .init(layout: view.trailingAnchor, dimension: .trailing)
      top = .init(layout: view.topAnchor, dimension: .top)
      bottom = .init(layout: view.bottomAnchor, dimension: .bottom)
    }
  }
  
  struct Center {
    public let x: AnchorProduct<NSLayoutXAxisAnchor, NSLayoutAnchor<NSLayoutXAxisAnchor>>
    public let y: AnchorProduct<NSLayoutYAxisAnchor, NSLayoutAnchor<NSLayoutYAxisAnchor>>
    
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
    
    public let width: SizeProduct
    public let height: SizeProduct
    
    init(view: UIView) {
      width = .init(layout: view.widthAnchor, dimension: .width)
      height = .init(layout: view.heightAnchor, dimension: .height)
    }
  }
  
  var paver: Paver { Paver(view: self) }
  
  private func prepare() {
    if translatesAutoresizingMaskIntoConstraints == true {
      translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  func setSizeEqual(to view: UIView) {
    apply { paver in [
      paver.alignment.leading.to(view),
      paver.alignment.trailing.to(view),
      paver.alignment.top.to(view),
      paver.alignment.bottom.to(view)
    ] }
  }
  
  func setSizeEqual(to size: CGSize) {
    apply { paver in [
      paver.size.width.constant(size.width),
      paver.size.height.constant(size.height)
    ] }
  }
  
  func center(in view: UIView, size: CGSize) {
    apply { paver in [
      paver.center.y.to(view),
      paver.center.x.to(view),
      paver.size.width.constant(size.width),
      paver.size.height.constant(size.height)
    ] }
  }
  
  func apply(_ constraints: (_ paver: Paver) -> [NSLayoutConstraint?]) {
    prepare()
    let applicableConstraints = constraints(paver).compactMap { $0 }
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
  func to(_ anchor: NSLayoutAnchor<D>, constant: CGFloat = 0) -> NSLayoutConstraint {
    self.layout.constraint(equalTo: anchor, constant: constant)
  }
  
  func lessThanOrEqualTo(_ anchor: NSLayoutAnchor<D>, constant: CGFloat = 0) -> NSLayoutConstraint {
    self.layout.constraint(lessThanOrEqualTo: anchor, constant: constant)
  }
  
  func greaterThanOrEqualTo(_ anchor: NSLayoutAnchor<D>, constant: CGFloat = 0) -> NSLayoutConstraint {
    self.layout.constraint(greaterThanOrEqualTo: anchor, constant: constant)
  }

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
  func to(_ anchor: NSLayoutAnchor<D>, constant: CGFloat = 0) -> NSLayoutConstraint {
    self.layout.constraint(equalTo: anchor, constant: constant)
  }
  
  func lessThanOrEqualTo(_ anchor: NSLayoutAnchor<D>, constant: CGFloat = 0) -> NSLayoutConstraint {
    self.layout.constraint(lessThanOrEqualTo: anchor, constant: constant)
  }
  
  func greaterThanOrEqualTo(_ anchor: NSLayoutAnchor<D>, constant: CGFloat = 0) -> NSLayoutConstraint {
    self.layout.constraint(greaterThanOrEqualTo: anchor, constant: constant)
  }
  
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
