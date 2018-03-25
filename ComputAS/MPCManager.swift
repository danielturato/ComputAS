//
//  MPCManager.swift
//  ComputAS
//
//  Created by Daniel Turato on 06/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

//import UIKit
//import MultipeerConnectivity
//
//protocol MPCManagerDelegate {
//    
//    func foundPeer()
//    
//    func lostPeer()
//    
//    func invitationWasRecieved(fromPeer: String)
//    
//    func connectedWithPeer(peerID: MCPeerID)
//    
//}
//
//class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
//    
//    var session: MCSession!
//    var peer: MCPeerID!
//    var browser: MCNearbyServiceBrowser!
//    var advertiser: MCNearbyServiceAdvertiser!
//    
//    var foundPeers = [MCPeerID]()
//    var invitationHandler: ((Bool, MCSession?)->Void)!
//    
//    var delegate: MPCManagerDelegate?
//    
//    override init() {
//        super.init()
//        
//        peer = MCPeerID(displayName: UserDefaults.standard.string(forKey: "username")!)
//        
//        session = MCSession(peer: peer)
//        session.delegate = self
//        
//        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "appcoda-mpc")
//        browser.delegate = self
//        
//        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "appcoda-mpc")
//        advertiser.delegate = self
//    }
//    
//    
//
//}
