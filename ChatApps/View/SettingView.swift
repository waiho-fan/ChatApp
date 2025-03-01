//
//  SettingView.swift
//  ChatApps
//
//  Created by Gary on 2/3/2025.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("username") private var username: String = "User123"
    @AppStorage("darkMode") private var darkMode: Bool = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("soundEnabled") private var soundEnabled: Bool = true
    
    var body: some View {
        Form {
            Section(header: Text("個人資料")) {
                HStack {
                    // 頭像
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(username)
                            .font(.headline)
                        
                        Text("點擊更換頭像")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 8)
                }
                .padding(.vertical, 8)
                
                TextField("用戶名稱", text: $username)
            }
            
            Section(header: Text("外觀")) {
                Toggle("深色模式", isOn: $darkMode)
                    .onChange(of: darkMode) { _, newValue in
                        // 在實際應用中，這裡可能需要更新應用的主題
                    }
            }
            
            Section(header: Text("通知")) {
                Toggle("啟用通知", isOn: $notificationsEnabled)
                Toggle("聲音", isOn: $soundEnabled)
                    .disabled(!notificationsEnabled)
            }
            
            Section(header: Text("聊天設定")) {
                NavigationLink(destination: Text("聊天背景設定")) {
                    Text("聊天背景")
                }
                
                NavigationLink(destination: Text("聊天字體設定")) {
                    Text("聊天字體")
                }
                
                NavigationLink(destination: Text("隱私設定")) {
                    Text("隱私與安全")
                }
            }
            
            Section(header: Text("關於")) {
                NavigationLink(destination: Text("應用版本：1.0.0\n開發者：Gary\n版權所有 © 2025")) {
                    Text("應用資訊")
                }
                
                NavigationLink(destination: Text("隱私政策內容")) {
                    Text("隱私政策")
                }
                
                NavigationLink(destination: Text("服務條款內容")) {
                    Text("服務條款")
                }
            }
            
            Section {
                Button(action: {
                    // 登出操作
                }) {
                    Text("登出")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("設定")
    }
}

#Preview {
    NavigationView {
        SettingView()
    }
}
