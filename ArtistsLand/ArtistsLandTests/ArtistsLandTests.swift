//
//  ArtistsLandTests.swift
//  ArtistsLandTests
//
//  Created by Alexia Aldea on 26.11.2024.
//

import Testing
import XCTest
import Combine
@testable import ArtistsLand

struct ArtistsLandTests {
    var userService: UserService!
    var cancellables: Set<AnyCancellable>!
    var profileViewModel: ProfileViewModel!
    var sideMenuViewModel: SideMenuViewModel!
    var changePasswordViewModel: ChangePasswordViewModel!
    var editAccountViewModel: EditAccountViewModel!
    var themeSettingsViewModel: ThemeSettingsViewModel!
    var loginViewModel: LoginViewModel!
    var registerViewModel: RegisterViewModel!
    
    @Test mutating func setup() async throws {
        userService = UserService.shared
        cancellables = Set<AnyCancellable>()
        profileViewModel = ProfileViewModel()
        sideMenuViewModel = SideMenuViewModel()
        changePasswordViewModel = ChangePasswordViewModel()
        editAccountViewModel = EditAccountViewModel(userInfo: User(id: "1", email: "alexia@domain.com", nickname: "alexia", avatarUrl: "", isArtist: true, balance: 0.0, level: 2, createdAt: Date(), posts: []))
        themeSettingsViewModel = ThemeSettingsViewModel()
        loginViewModel = LoginViewModel()
        registerViewModel = RegisterViewModel()
    }
    
    @Test mutating func tearDown() async throws {
        userService = nil
        cancellables = nil
        profileViewModel = nil
    }
    
    @Test func test_getUserInfo_whenUserIsLoggedIn_updatesUserInfo() {
        let user = User(id: "1", email: "alexia@domain.com", nickname: "alexia", avatarUrl: "", isArtist: true, balance: 0.0, level: 2, createdAt: Date(), posts: [])
        
        profileViewModel.getUserInfo()
        
        XCTAssertNotNil(profileViewModel.userInfo)
        XCTAssertEqual(profileViewModel.userInfo?.nickname, "Alexia")
        XCTAssertFalse(profileViewModel.isLoading)
    }
    
    @Test func test_getUserInfo_whenUserIsAnonymous_setsUserInfoToNil() {
        profileViewModel.getUserInfo()
        
        XCTAssertNil(profileViewModel.userInfo)
        XCTAssertFalse(profileViewModel.isLoading)
    }
    
    @Test mutating func testLogOut_Success() {
        sideMenuViewModel.eventSubject.sink { event in
            if case .logout = event {
            }
        }.store(in: &cancellables)
        
        sideMenuViewModel.logOut()
    }
    
    @Test func testChangePassword_ValidationErrors() {
        changePasswordViewModel.newPassword = "123"
        changePasswordViewModel.confirmNewPassword = "1234"
        
        changePasswordViewModel.changePassword()
        XCTAssertEqual(changePasswordViewModel.errorMessagePassword, "Password must contain at least 6 characters.")
        XCTAssertEqual(changePasswordViewModel.errorMessageConfirmNewPassword, "Passwords do not match!")
    }
    
    @Test mutating func testChangePassword_Success() {
        changePasswordViewModel.actualPassword = "password"
        changePasswordViewModel.newPassword = "newpassword"
        changePasswordViewModel.confirmNewPassword = "newpassword"
        
        
        changePasswordViewModel.eventSubject.sink { event in
            if case .completed = event {
            }
        }.store(in: &cancellables)
        
        changePasswordViewModel.changePassword()
    }
    
    @Test func testEditInfo_ValidationError() {
        editAccountViewModel.nickname = ""
        editAccountViewModel.editInfo()
        
        XCTAssertEqual(editAccountViewModel.errorMessageName, "This field can't be empty.")
    }
    
    @Test mutating func testEditInfo_Success() {
        editAccountViewModel.nickname = "NewName"
        
        editAccountViewModel.eventSubject.sink { event in
            if case .completed = event {
                
            }
        }.store(in: &cancellables)
        
        editAccountViewModel.editInfo()
    }
    
    @Test func testLoadThemePreference_SystemMode() {
        themeSettingsViewModel.loadThemePreference()
        
        XCTAssertTrue(themeSettingsViewModel.isSystemModeSelected ?? false)
    }
    
    @Test func testApplyTheme_LightMode() {
        themeSettingsViewModel.applyThemeBasedOnPreference(theme: .light)
        
        XCTAssertTrue(themeSettingsViewModel.isLightModeSelected ?? false)
    }
    
    @Test func testLogin_ValidationErrors() {
        loginViewModel.email = "invalid-email"
        loginViewModel.password = "123"
        
        loginViewModel.allFieldAreCompleted()
        
        XCTAssertEqual(loginViewModel.errorMessageEmail, "Please enter a valid email address.")
        XCTAssertEqual(loginViewModel.errorMessagePassword, "Password must contain at least 6 characters.")
    }
    
    @Test mutating func testLogin_Success() {
        loginViewModel.email = "test@example.com"
        loginViewModel.password = "password"
        
        loginViewModel.loginCompletion.sink { event in
            if case .login = event {
            }
        }.store(in: &cancellables)
        
        loginViewModel.login()
    }
    
    @Test func testEmptyFieldsValidation() {
        registerViewModel.name = ""
        registerViewModel.email = ""
        registerViewModel.password = ""
        registerViewModel.selectedUserType = ""
        registerViewModel.showGreeting = false
        
        registerViewModel.allFieldAreCompleted()
        
        XCTAssertEqual(registerViewModel.errorMessageName, "This field is required.")
        XCTAssertEqual(registerViewModel.errorMessageEmail, "Please enter a valid email address.")
        XCTAssertEqual(registerViewModel.errorMessagePassword, "This field is required.")
        XCTAssertEqual(registerViewModel.errorMessageUserType, "This field is required.")
        XCTAssertEqual(registerViewModel.errorMessageToggle, "Please accept terms.")
    }
    
    @Test func testValidFieldsPassValidation() {
        registerViewModel.name = "John Doe"
        registerViewModel.email = "john.doe@example.com"
        registerViewModel.password = "password123"
        registerViewModel.selectedUserType = "Artist"
        registerViewModel.showGreeting = true
        
        registerViewModel.allFieldAreCompleted()
        
        XCTAssertNil(registerViewModel.errorMessageName)
        XCTAssertNil(registerViewModel.errorMessageEmail)
        XCTAssertNil(registerViewModel.errorMessagePassword)
        XCTAssertNil(registerViewModel.errorMessageUserType)
        XCTAssertNil(registerViewModel.errorMessageToggle)
    }
}
