//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import  Firebase
import ChameleonFramework


class ChatViewController: UIViewController , UITableViewDelegate ,  UITableViewDataSource , UITextFieldDelegate{
 
    
    
    // Declare instance variables here

    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    var MessageArray : [Message] = [Message] ()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        
        
        //TODO: Set yourself as the delegate and datasource here:
        
        
        
        //TODO: Set yourself as the delegate of the text field here:

        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle : nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
        messageTableView.separatorStyle = .none
        
        
        

        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
  
    
  
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        
        cell.messageBody.text  = MessageArray[indexPath.row].messageBody
        cell.senderUsername.text  = MessageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == FIRAuth.auth()?.currentUser?.email as String! {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }
        else
        {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        
        return cell
        
    }
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    //TODO: Declare tableViewTapped here:
    
    @objc func tableViewTapped (){
        messageTextfield.endEditing(true)
    }
    
    //TODO: Declare configureTableView here:
    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
   
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        
        //TODO: Send the message to Firebase and save it in our database
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        let messageDB = FIRDatabase.database().reference().child("Messages")
        let messageDict = ["Sender" : FIRAuth.auth()?.currentUser?.email , "MessageBody" : messageTextfield.text]
        
        messageDB.childByAutoId().setValue(messageDict){
            (error,ref) in
            
            if error !=  nil{
              print(error!)
            }
            else{
                print("Message Save Successfully")

                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
        
        
        
        
        
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages() {
        let messageDB = FIRDatabase.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            //
            let snapShotValue = snapshot.value as! Dictionary< String,String >
            let text = snapShotValue["MessageBody"]!
            let sender = snapShotValue["Sender"]!
            
            print(text,sender)
            
            let message  = Message()
            message.messageBody = text
            message.sender = sender
            self.MessageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            
            
        }
        
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
        try FIRAuth.auth()?.signOut()
            
        }
        catch{
            
        }
        
        guard (navigationController?.popToRootViewController(animated: true)) != nil
            else{
                print("No View Controllers")
                return
        }
        
        
        
        
        
    }
    


}
