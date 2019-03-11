//
//  StartupViewController.swift
//  Concentration
//
//  Created by Dima Panchuk on 3/5/19.
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import UIKit

class StartupViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Sport": ["🏀", "⚽️", "🏐", "🏈", "⚾️", "🎱"],
        "Faces": ["😀", "😊", "😂", "😉", "😎", "🤪"],
        "Cats": ["😺", "😸", "😹", "😻", "🙀", "😿"]
    ]
    
    var themeButtons: UIStackView?
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
        initThemeButtons()
        drawThemeButtons()
        setDefaultTheme()
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        return true
    }
    
    private func initThemeButtons() {
        let buttonsStackView = UIStackView(arrangedSubviews: initButtons(themes: Array(themes.keys.sorted())))
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 20
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .equalSpacing
        
        view.addSubview(buttonsStackView)
        buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        themeButtons = buttonsStackView
    }
    
    private func drawThemeButtons() {
        for button in themeButtons!.subviews {
            UIView.animate(
                withDuration: 2,
                animations: { button.alpha = 1 }
            )
        }
    }
    
    private func setDefaultTheme() {
        if let detail = splitViewController?.viewControllers.last as? ConcentrationViewController {
            let theme = themes.keys.sorted().first!
            detail.emojies = themes[theme]!
        }
    }
    
    private func initButtons(themes: [String]) -> [UIButton] {
        return themes.map { theme in
            let button = UIButton()
            button.setTitle(theme, for: .normal)
            button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 40)
            button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            button.layer.cornerRadius = 5
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(StartupViewController.touchThemeButton(sender:)), for: .touchUpInside)
            button.alpha = 0
            return button
        }
    }
    
    @objc func touchThemeButton(sender: UIButton) {
        performSegue(withIdentifier: "Choose theme", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIButton,
            let theme = button.titleLabel?.text,
            let dest = segue.destination as? ConcentrationViewController
        else { return }

        dest.emojies = themes[theme]!
    }
    
}
