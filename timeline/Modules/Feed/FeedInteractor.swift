import UIKit

protocol FeedBusinessLogic
{
  func getAlbums(request: Feed.AlbumFeed.Request)
  func getPhoto(request: Feed.Photo.Request)
  func setDataPostView(request: Feed.Post.Request)
  func getSearchList(request: Feed.Search.Request)
  func checkNewPost(request: Feed.NewPost.Request)
}

protocol FeedDataStore
{
  var albums: Albums? { get set }
  var newPost: NewPost.NewPost.Request? { get set }
  var dataPostView: PresentModel? { get set }
}

class FeedInteractor: FeedBusinessLogic, FeedDataStore
{
  var presenter: FeedPresentationLogic?
  var worker: FeedWorker?
  var albums: Albums?
  var newPost: NewPost.NewPost.Request?
  var dataPostView: PresentModel?
  
  // MARK: Do something

  func getAlbums(request: Feed.AlbumFeed.Request) {
    worker = FeedWorker()
    worker?.getAlbums(success: { data in
      self.albums = data
      let response = Feed.AlbumFeed.Response(albums: data)
      self.presenter?.presentFeed(response: response)
    }, error: { _ in
      // TODO : handle error
    })
  }

  func getPhoto(request: Feed.Photo.Request) {
    worker = FeedWorker()
    worker?.getPhoto(albumId: request.id, success: { data in
      self.albums?.result[request.indexPath.row].photos = data
      let response = Feed.Photo.Response(id: request.id, photo: data, indexPath: request.indexPath)
      self.presenter?.presentPhoto(response: response)
    }, error: { _ in
      // TODO : handle error
    })
  }

  func setDataPostView(request: Feed.Post.Request) {
    dataPostView = request.data
    presenter?.presentPostView(response: Feed.Post.Response())
    
  }

  func getSearchList(request: Feed.Search.Request) {
    let response = Feed.Search.Response(data: request.data)
    self.presenter?.presentSearch(response: response)
  }

  func checkNewPost(request: Feed.NewPost.Request) {
    guard let data = newPost else {
      return
    }
    let edit = Edit.init(href: "")
    let links = Links.init(linksSelf: edit, edit: edit)
    let newAlbum = Album.init(id: "", userID: "", title: "", links: links, photos: nil)
    albums?.result.insert(newAlbum, at: 0)
    let response = Feed.NewPost.Response(text: data.text, image1: data.image1, image2: data.image2, image3: data.image3)
    newPost = nil
    presenter?.presentNewPost(response: response)

  }

}
