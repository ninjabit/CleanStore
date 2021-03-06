//
//  ListOrdersViewControllerTests.swift
//  CleanStore
//
//  Created by Raymond Law on 10/31/15.
//  Copyright (c) 2015 Raymond Law. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import CleanStore
import XCTest

class ListOrdersViewControllerTests: XCTestCase
{
  // MARK: - Subject under test
  
  var sut: ListOrdersViewController!
  var window: UIWindow!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    window = UIWindow()
    setupListOrdersViewController()
  }
  
  override func tearDown()
  {
    window = nil
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupListOrdersViewController()
  {
    let bundle = Bundle.main
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "ListOrdersViewController") as! ListOrdersViewController
  }
  
  func loadView()
  {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: - Test doubles
  
  class ListOrdersBusinessLogicSpy: ListOrdersBusinessLogic
  {
    var orders: [Order]?
    
    // MARK: Method call expectations
    
    var fetchOrdersCalled = false
    
    // MARK: Spied methods
    
    func fetchOrders(request: ListOrders.FetchOrders.Request)
    {
      fetchOrdersCalled = true
    }
  }
  
  class TableViewSpy: UITableView
  {
    // MARK: Method call expectations
    
    var reloadDataCalled = false
    
    // MARK: Spied methods
    
    override func reloadData()
    {
      reloadDataCalled = true
    }
  }
  
  // MARK: - Tests
  
  func testShouldFetchOrdersWhenViewIsLoaded()
  {
    // Given
    let listOrdersBusinessLogicSpy = ListOrdersBusinessLogicSpy()
    sut.interactor = listOrdersBusinessLogicSpy
    
    // When
    loadView()
    
    // Then
    XCTAssert(listOrdersBusinessLogicSpy.fetchOrdersCalled, "Should fetch orders when the view is loaded")
  }
  
  func testShouldDisplayFetchedOrders()
  {
    // Given
    let tableViewSpy = TableViewSpy()
    sut.tableView = tableViewSpy
    
    let displayedOrders = [ListOrders.FetchOrders.ViewModel.DisplayedOrder(id: "abc123", date: "6/29/07", email: "amy.apple@clean-swift.com", name: "Amy Apple", total: "$1.23")]
    let viewModel = ListOrders.FetchOrders.ViewModel(displayedOrders: displayedOrders)
    
    // When
    sut.displayFetchedOrders(viewModel: viewModel)
    
    // Then
    XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched orders should reload the table view")
  }
  
  func testNumberOfSectionsInTableViewShouldAlwaysBeOne()
  {
    // Given
    let tableView = sut.tableView
    
    // When
    let numberOfSections = sut.numberOfSections(in: tableView!)
    
    // Then
    XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")
  }
  
  func testNumberOfRowsInAnySectionShouldEqaulNumberOfOrdersToDisplay()
  {
    // Given
    let tableView = sut.tableView
    let testDisplayedOrders = [ListOrders.FetchOrders.ViewModel.DisplayedOrder(id: "abc123", date: "6/29/07", email: "amy.apple@clean-swift.com", name: "Amy Apple", total: "$1.23")]
    sut.displayedOrders = testDisplayedOrders
    
    // When
    let numberOfRows = sut.tableView(tableView!, numberOfRowsInSection: 0)
    
    // Then
    XCTAssertEqual(numberOfRows, testDisplayedOrders.count, "The number of table view rows should equal the number of orders to display")
  }
  
  func testShouldConfigureTableViewCellToDisplayOrder()
  {
    // Given
    let tableView = sut.tableView
    let testDisplayedOrders = [ListOrders.FetchOrders.ViewModel.DisplayedOrder(id: "abc123", date: "6/29/07", email: "amy.apple@clean-swift.com", name: "Amy Apple", total: "$1.23")]
    sut.displayedOrders = testDisplayedOrders
    
    // When
    let indexPath = IndexPath(row: 0, section: 0)
    let cell = sut.tableView(tableView!, cellForRowAt: indexPath)
    
    // Then
    XCTAssertEqual(cell.textLabel?.text, "6/29/07", "A properly configured table view cell should display the order date")
    XCTAssertEqual(cell.detailTextLabel?.text, "$1.23", "A properly configured table view cell should display the order total")
  }
}
