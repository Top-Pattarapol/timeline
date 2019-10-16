//
//  FeedRouter.swift
//  timeline
//
//  Created by pattarapol sawasdee on 12/10/2562 BE.
//  Copyright (c) 2562 pattarapol. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol FeedRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  func routeToPost(segue: UIStoryboardSegue?)
}

protocol FeedDataPassing
{
  var dataStore: FeedDataStore? { get }
}

class FeedRouter: NSObject, FeedRoutingLogic, FeedDataPassing
{
  weak var viewController: FeedViewController?
  var dataStore: FeedDataStore?
  
  // MARK: Routing

  func routeToPost(segue: UIStoryboardSegue?) {
    if let segue = segue {
      let destinationVC = segue.destination as! PostViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToPost(source: dataStore!, destination: &destinationDS)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let destinationVC = storyboard.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToPost(source: dataStore!, destination: &destinationDS)
      navigateToPost(source: viewController!, destination: destinationVC)
    }
  }

  // MARK: Navigation

  func navigateToPost(source: FeedViewController, destination: PostViewController) {
    source.show(destination, sender: nil)
  }
  
  // MARK: Passing data

  func passDataToPost(source: FeedDataStore, destination: inout PostDataStore) {
//    destination.title = source.dataForPostView?.title ?? ""
//    destination.time = source.dateForPostView
//    destination.photoList = source.dataForPostView?.urlList

    guard let data = source.dataPostView else {
      return
    }
    destination.data = data
  }

}
