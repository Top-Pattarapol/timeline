import UIKit

enum Feed
{
  // MARK: Use cases

  enum NewPost {
    struct Request
    {
    }
    struct Response
    {
      let text: String
      let image1, image2, image3: UIImage?
    }
  }

  enum AlbumFeed {
    struct Request
    {
    }
    struct Response
    {
      let albums: Albums
    }
    struct ViewModel
    {
      let data: [PresentModel]
    }
  }

  enum Photo
  {
    struct Request
    {
      let id: String
      let indexPath: IndexPath
    }
    struct Response
    {
      let id: String
      let photo: Photos
      let indexPath: IndexPath
    }
    struct ViewModel
    {
      let data: [PresentModel]
      let indexPath: IndexPath
    }
  }

  enum Post
  {
    struct Request
    {
      let data: PresentModel
    }
    struct Response
    {
    }
    struct ViewModel
    {
    }
  }

  enum Search
  {
    struct Request
    {
      let data: String
    }
    struct Response
    {
      let data: String
    }
    struct ViewModel
    {
      let data: [PresentModel]
    }
  }

}

struct PresentModel {
  let id, title: String
  let date: Date
  var imageType: ImageType
  var urlList: [String]?
  var imageList: [UIImage?]?
}

enum ImageType {
  case url(isLoad: Bool)
  case image
}
