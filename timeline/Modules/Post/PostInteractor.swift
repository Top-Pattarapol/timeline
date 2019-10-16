//
//  PostInteractor.swift
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

protocol PostBusinessLogic
{
  func getPost(request: Post.Post.Request)
  func getFullImage(request: Post.FullImage.Request)
}

protocol PostDataStore
{
  var data: Post.data { get set }
}

class PostInteractor: PostBusinessLogic, PostDataStore
{
  var presenter: PostPresentationLogic?
  var worker: PostWorker?
  var data: Post.data = Post.data(title: "", time: "", image1: nil, image2: nil, image3: nil)
  
  // MARK: Do something
  
  func getPost(request: Post.Post.Request)
  {
    let response = Post.Post.Response(data: data)
    presenter?.presentPost(response: response)
  }

  func getFullImage(request: Post.FullImage.Request) {
    var image: UIImage? = nil
    switch request.index {
    case 0:
      image = data.image1
    case 1:
      image = data.image2
    case 2:
      image = data.image3
    default:
      break
    }
    let response = Post.FullImage.Response(imageUrl: image)
    presenter?.presentFullImage(response: response)
  }
}
