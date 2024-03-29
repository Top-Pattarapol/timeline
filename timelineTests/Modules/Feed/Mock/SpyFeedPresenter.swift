import XCTest
@testable import timeline

class SpyFeedPresenter: FeedPresentationLogic {

  let expect: XCTestExpectation?
  var dataFeed: Feed.AlbumFeed.Response?
  var dataPhoto: Feed.Photo.Response?
  var presentPostViewPass = 0
  var dataSearch: String?
  var responseNewPost: Feed.NewPost.Response?

  init(expect: XCTestExpectation? = nil) {
      self.expect = expect
  }

  func presentFeed(response: Feed.AlbumFeed.Response) {
    dataFeed = response
    expect?.fulfill()
  }

  func presentPhoto(response: Feed.Photo.Response) {
    dataPhoto = response
    expect?.fulfill()
  }

  func presentPostView(response: Feed.Post.Response) {
    presentPostViewPass += 1
    expect?.fulfill()
  }

  func presentSearch(response: Feed.Search.Response) {
    dataSearch = response.data
    expect?.fulfill()
  }

  func presentNewPost(response: Feed.NewPost.Response) {
    responseNewPost = response
    expect?.fulfill()
  }
}
