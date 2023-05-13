import Preferences

final class HeaderView: UITableViewCell {
    private let tweakLabel: UILabel = .init()
    private let devLabel: UILabel = .init()
    
    private func setupView() {
        self.contentView.backgroundColor = .clear
        let width: CGFloat = self.contentView.bounds.size.width
        let height: CGFloat = 120.0
        
        tweakLabel.text = "Satella"
        tweakLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        tweakLabel.textColor = .white
        tweakLabel.sizeToFit()
        
        devLabel.text = "by Paisseon"
        devLabel.font = UIFont.systemFont(ofSize: 24, weight: .light)
        devLabel.textColor = .lightText
        devLabel.sizeToFit()
        
        let labelContainer: UIView = .init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        labelContainer.autoresizingMask = .flexibleHeight
        
        labelContainer.addSubview(tweakLabel)
        labelContainer.addSubview(devLabel)
        
        contentView.addSubview(labelContainer)
        
        let totalHeight: CGFloat = tweakLabel.frame.height + devLabel.frame.height - 10
        
        tweakLabel.center = CGPoint(x: width / 2, y: (height - totalHeight) / 2)
        devLabel.center = CGPoint(x: width / 2 + tweakLabel.frame.width / 2, y: CGRectGetMaxY(tweakLabel.frame) - 8)
        
        tweakLabel.alpha = 0
        devLabel.alpha = 0
        
        tweakLabel.layer.shadowColor = UIColor.black.cgColor
        tweakLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        tweakLabel.layer.shadowOpacity = 0.5
        tweakLabel.layer.shadowRadius = 2
        
        devLabel.layer.shadowColor = UIColor.black.cgColor
        devLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        devLabel.layer.shadowOpacity = 0.5
        devLabel.layer.shadowRadius = 2
        
        let rotate: CGAffineTransform = CGAffineTransform(rotationAngle: -.pi / 8)
        tweakLabel.transform = rotate
        devLabel.transform = rotate
        
        let animation: () -> Void = { [self] in
            tweakLabel.center = CGPoint(x: width / 2, y: (height - totalHeight) / 2)
            tweakLabel.alpha = 1.0
            tweakLabel.transform = CGAffineTransformIdentity
            tweakLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
            tweakLabel.layer.shadowRadius = 4
            tweakLabel.layer.shadowOpacity = 1
            
            devLabel.center = CGPoint(x: width / 2 + CGRectGetWidth(tweakLabel.frame) / 2, y: CGRectGetMaxY(tweakLabel.frame) + 8)
            devLabel.alpha = 1.0
            devLabel.transform = CGAffineTransformIdentity
            devLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
            devLabel.layer.shadowRadius = 4
            devLabel.layer.shadowOpacity = 1
        }
        
        UIView.animate(
            withDuration: 6,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: animation
        ) { _ in }
    }
    
    override var frame: CGRect {
        get { CGRect(origin: .zero, size: CGSize(width: super.bounds.width, height: super.bounds.height + 10)) }
        set { super.frame = newValue }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) { abort() }
}
