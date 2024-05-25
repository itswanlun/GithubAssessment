//
//  HomeViewModel.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/24.
//

import Foundation
import Combine
import CombineExt

enum AppError: Error {
    case emptyKeyword
}

enum Home {
    struct Section {
        let rows: [Row]
    }
    
    enum Row {
        case result(SearchResultCell.Model)
    }
    
    enum FetchDataAction {
        case first
        case next
    }
}

class HomeViewModel {
    // Input
    let keywordSubject = CurrentValueSubject<String?, Never>(nil)
    let pageSubject = CurrentValueSubject<Int, Never>(1)
    let triggerLoadPageSubject = PassthroughSubject<Void, Never>()
    let triggerNextPageSubject = PassthroughSubject<Void, Never>()
    
    // Output
    var dataChangedPublisher: AnyPublisher<[Home.Section], Never> {
        sectionsSubject.eraseToAnyPublisher()
    }
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    // Private
    private var isEndOfPageSubject = CurrentValueSubject<Bool, Never>(false)
    private var sectionsSubject = CurrentValueSubject<[Home.Section], Never>([])
    private let fetchDataSubject = PassthroughSubject<(Home.FetchDataAction, String), Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    private let repositoresSubject = CurrentValueSubject<[Item], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        binding()
    }
    
    private func binding() {
        let triggerLoadPage = triggerLoadPageSubject
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.pageSubject.send(1)
            })
            .withLatestFrom(keywordSubject, isEndOfPageSubject) { (action: Home.FetchDataAction.first, keyword: $1.0, isEnd: $1.1) }
         
        let triggerNextPage = triggerNextPageSubject
            .withLatestFrom(keywordSubject, isEndOfPageSubject) { (action: Home.FetchDataAction.next, keyword: $1.0, isEnd: $1.1) }
        
        Publishers.Merge(triggerLoadPage, triggerNextPage)
            .throttle(for: 3.0, scheduler: RunLoop.main, latest: true)
            .filter { !$0.isEnd }
            .sink(receiveValue: { [weak self] (action, keyword, isEnd) in
                if let keyword, !keyword.isEmpty {
                    self?.fetchDataSubject.send((action, keyword))
                } else {
                    self?.errorSubject.send(AppError.emptyKeyword)
                }
            })
            .store(in: &cancellables)
        
        fetchDataSubject
            .withLatestFrom(pageSubject, repositoresSubject) { (action: $0.0, keyword: $0.1, page: $1.0, currentItems: $1.1) }
            .map { action, keyword, page, currentItems in
                APIClient.shared.getRepositores(q: keyword, page: page)
                    .tryMap {
                        try $0.get().items
                    }
                    .replaceNil(with: [])
                    .replaceError(with: [])
                    .map { (action, page, currentItems, $0) }
            }
            .switchToLatest()
            .sink(receiveValue: { [weak self] (action, page, currentItems, newItems) in
                if newItems.isEmpty {
                    self?.isEndOfPageSubject.send(true)
                } else {
                    switch action {
                    case .first:
                        self?.repositoresSubject.send(newItems)
                    case .next:
                        self?.repositoresSubject.send(currentItems + newItems)
                    }
                    self?.pageSubject.send(page + 1)
                }
            })
            .store(in: &cancellables)
        
        repositoresSubject
            .map { items in
                items.map {
                    Home.Row.result(SearchResultCell.Model(icon: $0.owner.icon, fullname: $0.fullname, description: $0.description))
                }
            }
            .map { [Home.Section(rows: $0)] }
            .subscribe(sectionsSubject)
            .store(in: &cancellables)
        
        keywordSubject
            .filter { $0.isEmptyOrNil }
            .sink(receiveValue: { [weak self] _ in
                self?.repositoresSubject.send([])
            })
            .store(in: &cancellables)
    }
}

extension HomeViewModel {
    func numberOfRowsInSections(_ section: Int) -> Int {
        sectionsSubject.value[safe: section]?.rows.count ?? 0
    }
    
    func cellForRowAt(_ indexPath: IndexPath) -> Home.Row? {
        sectionsSubject.value[safe: indexPath.section]?.rows[safe: indexPath.row]
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) -> Item? {
        repositoresSubject.value[safe: indexPath.row]
    }
}
