//
//  PostPresenter.swift
//  timeline
//
//  Created by pattarapol sawasdee on 13/10/2562 BE.
//  Copyright (c) 2562 pattarapol. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PostPresentationLogic
{
  func presentPost(response: Post.Post.Response)
  func presentFullImage(response: Post.FullImage.Response)
}

class PostPresenter: PostPresentationLogic
{
  weak var viewController: PostDisplayLogic?
  
  // MARK: Do something
  
  func presentPost(response: Post.Post.Response)
  {
    let viewModel = Post.Post.ViewModel(data: response.data)
    viewController?.displayPost(viewModel: viewModel)
  }

  func presentFullImage(response: Post.FullImage.Response) {
    let viewModel = Post.FullImage.ViewModel(image: response.image)
    viewController?.displayFullImage(viewModel: viewModel)
  }
}
