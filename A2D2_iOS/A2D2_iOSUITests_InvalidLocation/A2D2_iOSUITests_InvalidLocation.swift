//
//  A2D2_iOSUITests_InvalidLocation.swift
//  A2D2_iOSUITests_InvalidLocation
//
//  Created by Daniel Crean on 3/27/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import XCTest

class A2D2_iOSUITests_InvalidLocation: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this."Request Driver"
    }
    
    
    override func tearDown() {
        app.terminate()
    }
    
    
    /***** Navigation Functions *****/
    
    //this function will also give the view enough time to load
    func doesViewExist(viewName: String) -> Bool {
        let requestView = app.otherElements[viewName]
        let viewExists = requestView.waitForExistence(timeout: 10)
        if viewExists{
            return true
        }
        else {return false}
    }
    
    
    func goToRulesPage(){
        app.buttons["btn_RequestRide"].tap()
    }
    
    
    func goToPickupRequestOptionsPage(){
        goToRulesPage()
        app.buttons["btn_Agree"].tap()
        addUIInterruptionMonitor(withDescription: "Location permission", handler: { alert in
            alert.buttons["Allow"].tap()
            return true
        })
        app.tap()
        //Will need to handle Navigations Permissions here
    }
    
    
    func goToRideStatusPage(){
        goToPickupRequestOptionsPage()
        XCTAssert(doesViewExist(viewName: "vw_PickupRequestOptions"))
        app.textFields["txtFld_Name"].tap()
        app.textFields["txtFld_Name"].typeText("Test Name")
        app.textFields["txtFld_PhoneNumber"].tap()
        app.textFields["txtFld_PhoneNumber"].typeText("3345389408")
        //        app.staticTexts["Gender"].tap()
        app.staticTexts["Gender"].tap()
        app.buttons["btn_RequestDriver"].tap()
        //Will need to handle mandatory fields and input here
        //Alert as well
    }
    
    
    func goToDriverLoginPage(){
        app.buttons["btn_DriverLogin"].tap()
    }
    
    
    func goToRideRequestsPage(){
        goToDriverLoginPage()
        app.textFields["txtFld_Email"].tap()
        app.textFields["txtFld_Email"].typeText("sheldon@boot.com")
        app.secureTextFields["txtFld_Password"].tap()
        app.secureTextFields["txtFld_Password"].typeText("fruitloops")
        app.accessibilityActivate()
        app.staticTexts["Welcome!"].tap()//Slightly Hacky -- Find better way to tap off
        app.otherElements["vw_DriverLogin"].tap()
        app.buttons["btn_Login"].tap()
    }
    
    
    func goToRideRequestsDetailPage(){
        goToRideRequestsPage()
        XCTAssert(app.cells["cell_RequestStatus"].waitForExistence(timeout: 10))
        app.cells.element(boundBy: 0).tap()
    }
    
    /*** End Navigation ***/
    
    
    //Tests for alert when user is outside pickup range
    func testRules_AcceptOutsideRange() {
        goToRulesPage()
        app.buttons["Agree"].tap()
        XCTAssert(app.alerts["Location out of range!"].waitForExistence(timeout: 10))
    }
}
