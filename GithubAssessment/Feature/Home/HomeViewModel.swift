//
//  HomeViewModel.swift
//  GithubAssessment
//
//  Created by WanLun on 2024/5/24.
//

import Foundation
import Combine

enum Home {
    struct Section {
        let rows: [Row]
    }
    
    enum Row {
        case result(SearchResultCell.Model)
    }
}

class HomeViewModel {
    private let repositoresSubject = CurrentValueSubject<Repositories?, Never>(nil)
    
    private(set) var sectionsSubject = CurrentValueSubject<[Home.Section], Never>([])
    var dataChangedPublisher: AnyPublisher<[Home.Section], Never> {
        sectionsSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        binding()
    }
    
    func binding() {
        repositoresSubject
            .compactMap { repo -> [Home.Section]? in
                return repo?.items
                    .map {
                        $0.map {
                            Home.Row.result(SearchResultCell.Model(icon: $0.owner.icon, fullname: $0.fullname, description: $0.description))
                        }
                    }
                    .map { [Home.Section(rows: $0)] }
            }
            .subscribe(sectionsSubject)
            .store(in: &cancellables)
    }
    
    func loadData(q: String, page: Int) {
        APIClient.shared.getRepositores(q: q, page: page)
            .compactMap { result in
                guard let repo = try? result.get() else { return nil }
                return repo
            }
            .subscribe(repositoresSubject)
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
}

