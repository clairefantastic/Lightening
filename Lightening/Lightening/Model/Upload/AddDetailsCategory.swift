//
//  AddDetailsCategory.swift
//  Lightening
//
//  Created by claire on 2022/4/15.
//

import UIKit

enum AddDetailsCategory: String {

    case title = "Title"

    case description = "Description"

//    case category = "Category"
//
//    case cover = "Pick a cover"
//
//    case map = "Pin on map"

    func identifier() -> String {

        switch self {

        case .title, .description: return String(describing: AddDetailsContentCell.self)

//        case .category, .cover, .map

        }
    }

    func cellForIndexPath(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier(), for: indexPath)

        guard let addContentCell = cell as? AddDetailsContentCell else { return cell }

        switch self {
        
        case .title:
            
            addContentCell.layoutCell(category: rawValue)
            
        case .description:

            addContentCell.layoutCell(category: rawValue)

        }
        
        return addContentCell
    }

}
