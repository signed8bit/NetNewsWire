//
//  SidebarContextMenu.swift
//  NetNewsWire
//
//  Created by Maurice Parker on 7/17/20.
//  Copyright © 2020 Ranchero Software. All rights reserved.
//

import SwiftUI
import RSCore
import Account

struct SidebarContextMenu: View {
	
	@Environment(\.undoManager) var undoManager
	@Environment(\.openURL) var openURL
	@EnvironmentObject private var sidebarModel: SidebarModel
	@Binding var showInspector: Bool
	var sidebarItem: SidebarItem
	
	
    @ViewBuilder var body: some View {
		// MARK: Account Context Menu
		if sidebarItem.representedType == .account {
			Button {
				showInspector = true
			} label: {
				Text("Get Info")
				#if os(iOS)
				AppAssets.getInfoImage
				#endif
			}
			Button {
				sidebarModel.markAllAsReadInAccount.send(sidebarItem.represented as! Account)
			} label: {
				Text("Mark All As Read")
				#if os(iOS)
				AppAssets.markAllAsReadImage
				#endif
			}
		}
		
		// MARK: Pseudofeed Context Menu
		if sidebarItem.representedType == .pseudoFeed {
			Button {
				guard let feed = sidebarItem.feed else {
					return
				}
				sidebarModel.markAllAsReadInFeed.send(feed)
			} label: {
				Text("Mark All As Read")
				#if os(iOS)
				AppAssets.markAllAsReadImage
				#endif
			}
		}
		
		// MARK: Webfeed Context Menu
		if sidebarItem.representedType == .webFeed {
			Button {
				showInspector = true
			} label: {
				Text("Get Info")
				#if os(iOS)
				AppAssets.getInfoImage
				#endif
			}
			Button {
				guard let feed = sidebarItem.feed else {
					return
				}
				sidebarModel.markAllAsReadInFeed.send(feed)
			} label: {
				Text("Mark All As Read")
				#if os(iOS)
				AppAssets.markAllAsReadImage
				#endif
			}
			Divider()
			Button {
				guard let homepage = (sidebarItem.feed as? WebFeed)?.homePageURL,
					  let url = URL(string: homepage) else {
					return
				}
				openURL(url)
			} label: {
				Text("Open Home Page")
				#if os(iOS)
				AppAssets.openInBrowserImage
				#endif
			}
			Divider()
			Button {
				guard let feedUrl = (sidebarItem.feed as? WebFeed)?.url else {
					return
				}
				#if os(macOS)
				URLPasteboardWriter.write(urlString: feedUrl, to: NSPasteboard.general)
				#else
				UIPasteboard.general.string = feedUrl
				#endif
				
			} label: {
				Text("Copy Feed URL")
				#if os(iOS)
				AppAssets.copyImage
				#endif
			}
			Button {
				guard let homepage = (sidebarItem.feed as? WebFeed)?.homePageURL else {
					return
				}
				#if os(macOS)
				URLPasteboardWriter.write(urlString: homepage, to: NSPasteboard.general)
				#else
				UIPasteboard.general.string = homepage
				#endif
			} label: {
				Text("Copy Home Page URL")
				#if os(iOS)
				AppAssets.copyImage
				#endif
			}
			Divider()
			Button {
				sidebarModel.deleteFromAccount.send(sidebarItem.feed!)
			} label: {
				Text("Delete")
				#if os(iOS)
				AppAssets.deleteImage
				#endif
			}
		}
		
		// MARK: Folder Context Menu
		if sidebarItem.representedType == .folder {
			Button {
				showInspector = true
			} label: {
				Text("Get Info")
				#if os(iOS)
				AppAssets.getInfoImage
				#endif
			}
			Button {
				guard let feed = sidebarItem.feed else {
					return
				}
				sidebarModel.markAllAsReadInFeed.send(feed)
			} label: {
				Text("Mark All As Read")
				#if os(iOS)
				AppAssets.markAllAsReadImage
				#endif
			}
			Divider()
			Button {
				sidebarModel.deleteFromAccount.send(sidebarItem.feed!)
			} label: {
				Text("Delete")
				#if os(iOS)
				AppAssets.deleteImage
				#endif
			}
		}
		
    }
}
