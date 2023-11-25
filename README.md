## [Project 25: Selfie Share](https://www.hackingwithswift.com/read/25/overview)
Written by [Paul Hudson](https://www.hackingwithswift.com/about)  ![twitter16](https://github.com/juliangyurov/PH-Project6a/assets/13259596/445c8ea0-65c4-4dba-8e1f-3f2750f0ef51)
  [@twostraws](https://twitter.com/twostraws)

**Description:** Make a multipeer photo sharing app in just 150 lines of code.

- Setting up

- Importing photos again

- Going peer to peer: `MCSession`, `MCBrowserViewController`

- Invitation only: `MCPeerID`

- Wrap up
  
## [Review what you learned](https://www.hackingwithswift.com/review/hws/project-25-selfie-share)

**Challenge**

1. Show an alert when a user has disconnected from our multipeer network. Something like “Paul’s iPhone has disconnected” is enough.

2. Try sending text messages across the network. You can create a `Data` from a string using `Data(yourString.utf8)`, and convert a `Data` back to a string by using `String(decoding: yourData, as: UTF8.self)`.

3. Add a button that shows an alert controller listing the names of all devices currently connected to the session – use the `connectedPeers` property of your session to find that information.
