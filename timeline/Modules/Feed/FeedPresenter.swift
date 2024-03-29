import UIKit

protocol FeedPresentationLogic
{
  func presentFeed(response: Feed.AlbumFeed.Response)
  func presentPhoto(response: Feed.Photo.Response)
  func presentPostView(response: Feed.Post.Response)
  func presentSearch(response: Feed.Search.Response)
  func presentNewPost(response: Feed.NewPost.Response)
}

class FeedPresenter: FeedPresentationLogic
{
  weak var viewController: FeedDisplayLogic?
  
  // MARK: Do something
  var feedData: [PresentModel]?

  func presentFeed(response: Feed.AlbumFeed.Response) {

    let presentFeedData = response.albums.result.map { item -> PresentModel in
      return PresentModel(id: item.id, title: item.title, date: Date(), imageType: .url(isLoad: false))
    }
    feedData = presentFeedData
    let viewModel = Feed.AlbumFeed.ViewModel(data: presentFeedData)
    viewController?.displayFeed(viewModel: viewModel)
  }

  func presentPhoto(response: Feed.Photo.Response) {

    var photos: [String] = []
    response.photo.result.forEach { item in
      if photos.count == 3 { return }
      photos.append(item.url)
    }
    feedData?[response.indexPath.row].urlList = photos
    feedData?[response.indexPath.row].imageType = .url(isLoad: true)
    guard let feedData = feedData else { return }
    let viewModel = Feed.Photo.ViewModel(data: feedData, indexPath: response.indexPath)
    viewController?.displayPhoto(viewModel: viewModel)
  }

  func presentPostView(response: Feed.Post.Response) {
    viewController?.routeToPost(viewModel: Feed.Post.ViewModel())
  }

  func presentSearch(response: Feed.Search.Response) {
    guard let feedData = feedData else { return }
    if !response.data.isEmpty {
      let newFeed = feedData.filter { item -> Bool in
        return item.title.contains(response.data)
      }
      let viewModel = Feed.Search.ViewModel(data: newFeed)
      viewController?.displaySearch(viewModel: viewModel)
    } else {
      let viewModel = Feed.Search.ViewModel(data: feedData)
      viewController?.displaySearch(viewModel: viewModel)
    }
  }

  func presentNewPost(response: Feed.NewPost.Response) {
    let newPost = PresentModel(id: "", title: response.text, date: Date(), imageType: .image, urlList: nil, imageList: [response.image1, response.image2, response.image3])
    feedData?.insert(newPost, at: 0)
    let viewModel = Feed.AlbumFeed.ViewModel(data: feedData ?? [])
    viewController?.displayFeed(viewModel: viewModel)
  }

  
}
