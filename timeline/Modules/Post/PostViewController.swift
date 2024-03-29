import UIKit
import Kingfisher

protocol PostDisplayLogic: class
{
  func displayPost(viewModel: Post.Post.ViewModel)
  func displayFullImage(viewModel: Post.FullImage.ViewModel)
}

class PostViewController: UIViewController, PostDisplayLogic
{
  var interactor: PostBusinessLogic?
  var router: (NSObjectProtocol & PostRoutingLogic & PostDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = PostInteractor()
    let presenter = PostPresenter()
    let router = PostRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UITabBarItem(tabBarSystemItem: .more, tag: 0).selectedImage,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(moreTab))
    getPost()
  }

  // MARK: Do something
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var image1: UIImageView!
  @IBOutlet var image2: UIImageView!
  @IBOutlet var image3: UIImageView!
  @IBOutlet var imageFullVIew: UIView!
  @IBOutlet var imageFull: UIImageView!
  @IBOutlet var parentImage1: UIView!
  @IBOutlet var parentImage2: UIView!
  @IBOutlet var parentImage3: UIView!
  
  @IBAction func imageTab1(_ sender: Any) {
    showFullImage(image: image1.image)
  }
  
  @IBAction func imageTab2(_ sender: Any) {
    showFullImage(image: image2.image)
  }

  @IBAction func imageTab3(_ sender: Any) {
    showFullImage(image: image3.image)
  }

  @IBAction func closeFullImage(_ sender: Any) {
    imageFullVIew.isHidden = true
  }

  func getPost()
  {
    let request = Post.Post.Request()
    interactor?.getPost(request: request)
  }

  func showFullImage(image: UIImage?) {
    let request = Post.FullImage.Request(image: image)
    interactor?.getFullImage(request: request)
  }
  
  fileprivate func setImage(view: UIImageView, parentView: UIView, viewModel: Post.Post.ViewModel, index: Int) {
    let data = viewModel.data
    switch data.imageType {
    case .image:
      guard let photo = viewModel.data.imageList?[safe: index], photo != nil else {
        parentView.isHidden = true
        return
      }
      view.image = photo
    default:
      guard let url = viewModel.data.urlList?[safe: index] else {
        parentView.isHidden = true
        return
      }
      view.kf.setImage(with: URL(string: url))
    }
  }
  
  func displayPost(viewModel: Post.Post.ViewModel)
  {
    titleLabel.text = viewModel.data.title
    timeLabel.text = viewModel.data.date.getTime()
    setImage(view: image1, parentView: parentImage1,viewModel: viewModel, index: 0)
    setImage(view: image2, parentView: parentImage2,viewModel: viewModel, index: 1)
    setImage(view: image3, parentView: parentImage3,viewModel: viewModel, index: 2)
  }

  func displayFullImage(viewModel: Post.FullImage.ViewModel) {
    imageFull.image = viewModel.image
    imageFullVIew.isHidden = false
  }

  @objc func moreTab() {

  }

}
