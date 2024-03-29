import UIKit

protocol NewPostDisplayLogic: class
{
  func routeToParent(viewModel: NewPost.NewPost.ViewModel)
}

class NewPostViewController: UIViewController, NewPostDisplayLogic
{
  var interactor: NewPostBusinessLogic?
  var router: (NSObjectProtocol & NewPostRoutingLogic & NewPostDataPassing)?

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
    let interactor = NewPostInteractor()
    let presenter = NewPostPresenter()
    let router = NewPostRouter()
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    shouldHideKeyboardWhenTappedAnyArea()
    navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Close", style: .done, target: self, action: #selector(close))
    navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Create", style: .done, target: self, action: #selector(create))
    setupView()
  }
  
  // MARK: Do something
  
  @IBOutlet var inputTextView: UITextView!
  @IBOutlet var image1: UIImageView!
  @IBOutlet var image2: UIImageView!
  @IBOutlet var image3: UIImageView!
  @IBOutlet var addImage1: UIButton!
  @IBOutlet var addImage2: UIButton!
  @IBOutlet var addImage3: UIButton!
  var imagePicker: ImagePicker!
  var itemImageSelect: UIButton?
  var valuePlacehoder = " What's on your mind?  "
  
  @IBAction func action1(_ sender: Any) {
    itemImageSelect = addImage1
    imagePicker.present(from: sender as! UIView)
  }
  @IBAction func action2(_ sender: Any) {
    itemImageSelect = addImage2
    imagePicker.present(from: sender as! UIView)
  }
  @IBAction func action3(_ sender: Any) {
    itemImageSelect = addImage3
    imagePicker.present(from: sender as! UIView)
  }

  func setupView() {
    inputTextView.applyBorderConner(radius: 16, color: .darkGray)
    addImage1.applyBorderConner(radius: 0, color: .systemBlue)
    addImage2.applyBorderConner(radius: 0, color: .systemBlue)
    addImage3.applyBorderConner(radius: 0, color: .systemBlue)
    addImage2.isHidden = true
    addImage3.isHidden = true
    imagePicker = ImagePicker(presentationController: self, delegate: self)
    inputTextView.delegate = self
    inputTextView.text = valuePlacehoder
    inputTextView.textColor = UIColor.lightGray
  }

  func routeToParent(viewModel: NewPost.NewPost.ViewModel) {
    router?.routeToParent(segue: nil)
  }

  @objc func create() {
    let text: String
    if let inputText = inputTextView.text, inputText != valuePlacehoder {
      text = inputText
    } else {
      text = ""
    }
    let request = NewPost.NewPost.Request(text: text, image1: image1.image, image2: image2.image ,image3: image3.image)
    interactor?.setNewPost(request: request)
  }

  @objc func close() {
    self.navigationController?.dismiss(animated: true)
  }
}

extension NewPostViewController: ImagePickerDelegate {
  func didSelect(image: UIImage?) {
    switch itemImageSelect {
    case addImage1:
      image1.image = image
      addImage1.isHidden = true
      addImage2.isHidden = false
    case addImage2:
      image2.image = image
      addImage2.isHidden = true
      addImage3.isHidden = false
    case addImage3:
      image3.image = image
      addImage3.isHidden = true
    default:
      break
    }
  }
}

extension NewPostViewController: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.textColor == UIColor.lightGray {
          textView.text = nil
          textView.textColor = UIColor.black
      }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text.isEmpty {
          textView.text = valuePlacehoder
          textView.textColor = UIColor.lightGray
      }
  }
}
