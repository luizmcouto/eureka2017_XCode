/******************************************************************************/
//                                   EUREKA                                   //
//----------------------------------------------------------------------------//
/*!
 * @brief	Classe ProjetoController
 *
 * Esta classe funciona como controller dos trabalhos de graduação
 *
 * @author	Luiz Felipe Couto
 */
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// Import declaration
//------------------------------------------------------------------------------
import UIKit

//==============================================================================
// Class Definition
//==============================================================================
class ProjetoController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate {
    
//    @IBOutlet weak var tabBar: UITabBar!

    @IBOutlet weak var trabalhoSearchBar: UISearchBar!
    @IBOutlet weak var trabalhoTableView: UITableView!
    
    @IBOutlet weak var engenhariaButton: UIButton!
    @IBOutlet weak var designButton: UIButton!
    @IBOutlet weak var administracaoButton: UIButton!
    
    /**************************************************************************/
    
    //Controller da busca
    var searchController: UISearchController?
    
    //Curso do trabalho a ser escolhido
    var curso: String!
    
    //Trabalho selecionado
    var trabalhoSelected: Trabalho?
    
    /**************************************************************************/
    
    @IBAction func setAreaTrabaho(_ sender: UIButton) {
        if (sender.tag == 1) {
            self.curso = "engenharia"
        } else if (sender.tag == 2) {
            self.curso = "design"
        } else if (sender.tag == 3) {
            self.curso = "administração"
        }
        
        self.trabalhoSearchBar.becomeFirstResponder()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let textFieldInsideSearchBar = self.trabalhoSearchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.layer.borderWidth = 0.7
        textFieldInsideSearchBar?.layer.borderColor = UIColor.white.cgColor
        textFieldInsideSearchBar?.layer.cornerRadius = 6
        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 0.00, green: 0.10, blue: 0.17, alpha: 1.0)
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        self.searchController = UISearchController(searchResultsController: nil)
        
        //self.tabBar.selectedItem = self.tabBar.items![0]

        self.definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.curso = ""
        
        // self.trabalhoTableView.setContentOffset(CGPoint.zero, animated: false)
    }

    //------------------------------ preferredStatusBarStyle -------------------
    /*
     @brief
     
     @return
     */
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.trabalhoSearchBar.text != "" || (self.curso != nil && self.curso != "")) {
            return filteredTrabalhos.count
        } else {
            return trabalhos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var trabalho: Trabalho
        
        if (self.trabalhoSearchBar.text != "" || (self.curso != nil && self.curso != "")) {
            trabalho = filteredTrabalhos[(indexPath as NSIndexPath).row]
        } else {
            trabalho = trabalhos[(indexPath as NSIndexPath).row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trabalhoCell", for: indexPath) as! ProjetoViewCell
        
        cell.tituloLabel.text = trabalho.titulo
        cell.descricaoLabel.text = trabalho.descricao
        
        return cell
    }
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let row = (trabalhoTableView.indexPath(for: cell)! as NSIndexPath).row

            if (segue.identifier == "trabalhoDetalheSegue") {
                let projetoDetalheController = segue.destination as! ProjetoDetalheController
                
                if (self.trabalhoSearchBar.text != "" || (self.curso != nil && self.curso != "")) {
                    projetoDetalheController.trabalho = filteredTrabalhos[row]
                } else {
                    projetoDetalheController.trabalho = trabalhos[row]
                }
                
                self.trabalhoSearchBar.text = ""
                self.trabalhoSearchBar.showsCancelButton = false
            }
        }
     }

    
    // MARK: - Search
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if (self.curso != "") {
            filteredTrabalhos = trabalhos.filter { trabalho in
                return (trabalho.curso.lowercased().contains(self.curso))
            }
        }
        
        searchBar.showsCancelButton = true
        
        let cancelButtonSearchBar = searchBar.value(forKey: "cancelButton") as? UIButton
        
        cancelButtonSearchBar?.setTitle("Cancelar", for: UIControlState())
        
        self.trabalhoTableView.isHidden = false
        self.trabalhoTableView.reloadData()

        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.trabalhoTableView.isHidden = true
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.curso = ""
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if (self.curso == "") {
            filteredTrabalhos = trabalhos.filter { trabalho in
                return trabalho.titulo.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredTrabalhos = trabalhos.filter { trabalho in
                return trabalho.titulo.lowercased().contains(searchText.lowercased()) && (trabalho.curso.lowercased().contains(self.curso))
            }
        }
        
        self.trabalhoTableView.reloadData()
    }

}
