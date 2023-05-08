//
//  SimulationViewController.swift
//  VirusSpreadSim
//
//  Created by Aleksandr Ataev on 07.05.2023.
//

import UIKit

class SimulationViewController: UIViewController {

    //MARK: - Properties
    var groupSize: Int = 0
    var infectionFactor: Int = 0
    var recalculationPeriod: Double = 0.0
    var matrix: [[Bool]] = [[]]

    private var timer: Timer?
    private var seconds = 0

    private var healthyPerson: Int {
        var count = 0

        for row in matrix {
            for element in row {
                if !element {
                    count += 1
                }
            }
        }
        return count
    }

    private var infectionPerson: Int {
        var count = 0

        for row in matrix {
            for element in row {
                if element {
                    count += 1
                }
            }
        }
        return count
    }

    private var matrixElements: Int {
        let rowCount = matrix.count
        let columnCount = matrix.first?.count ?? 0

        let totalCount = rowCount * columnCount
        return totalCount
    }

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "Simulation"
        personsCollectionView.dataSource = self
        personsCollectionView.delegate = self
        addSubviews()
        setConstraints()
        personsCollectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        personsCollectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    //MARK: - UIElements
    private lazy var healthyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemGreen
        label.text = "HEALTHY = \(matrixElements)"
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var infectedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemRed
        label.text = "INFECTED = \(infectionPerson)"
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var personsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.collectionView?.backgroundColor = .white
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PersonsCollectionViewCell.self, forCellWithReuseIdentifier: PersonsCollectionViewCell.reuseId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.setTitle("STOP!", for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.configuration?.cornerStyle = .large
        button.layer.shadowOpacity = 0.6
        button.layer.shadowRadius = 4
        button.setTitleColor(.white, for: .normal)
        button.configuration?.baseBackgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(stopIt), for: .touchUpInside)
        return button
    }()


    //MARK: - Methods
    private func setConstraints() {
        NSLayoutConstraint.activate([
            healthyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            healthyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

            infectedLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            infectedLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            infectedLabel.leadingAnchor.constraint(equalTo: healthyLabel.trailingAnchor, constant: 8),

            personsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            personsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            personsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            personsCollectionView.bottomAnchor.constraint(equalTo: stopButton.topAnchor, constant: -8),

            stopButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stopButton.widthAnchor.constraint(equalToConstant: 150),
            stopButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    private func addSubviews() {
        [healthyLabel, infectedLabel, personsCollectionView, stopButton].forEach { view.addSubview($0) }
    }

    private func updateView() {
        if healthyPerson <= 0 {
            timer?.invalidate()
            timer = nil
        }
        replaceRandomNeighbors(matrix: matrix, withFactor: infectionFactor)
        healthyLabel.text = "HEALTHY = \(healthyPerson)"
        infectedLabel.text = "INFECTED = \(infectionPerson)"
        self.personsCollectionView.reloadData()
    }

    private func replaceRandomNeighbors(matrix: [[Bool]], withFactor factor: Int) {
        let numRows = matrix.count
        let numColumns = matrix[0].count

        for row in 0..<numRows {
            for column in 0..<numColumns {
                if matrix[row][column] == true {
                    for _ in 0..<Int.random(in: 0...factor) {
                        let randomRow = Int.random(in: max(row - 1, 0)...min(row + 1, numRows - 1))
                        let randomColumn = Int.random(in: max(column - 1, 0)...min(column + 1, numColumns - 1))

                        DispatchQueue.main.async {
                            if matrix[randomRow][randomColumn] == false {
                                self.matrix[randomRow][randomColumn] = true
                            }
                        }
                    }
                }
            }
        }
    }

    private func selectCell() {
        if timer == nil {
            DispatchQueue.global(qos: .background).async {
                self.timer = Timer.scheduledTimer(withTimeInterval: self.recalculationPeriod, repeats: true) { timer in
                    self.seconds += 1
                    DispatchQueue.main.async {
                        self.updateView()
                    }
                }

                self.timer!.tolerance = 0.1
                let runLoop = RunLoop.current
                runLoop.add(self.timer!, forMode: .default)
                runLoop.run()
            }
            addRandomRedInMatrix(matrix)
        }
    }

    private func addRandomRedInMatrix(_ matrix: [[Bool]]) {
        DispatchQueue.global(qos: .background).async {
            let randomRow = Int.random(in: 0..<matrix.count)
            let randomColumn = Int.random(in: 0..<matrix[randomRow].count)
            DispatchQueue.main.async {
                if matrix[randomRow][randomColumn] == false {
                    self.matrix[randomRow][randomColumn] = true
                }
            }
        }
    }

    @objc func stopIt() {
        timer?.invalidate()
        timer = nil
    }
}

//MARK: - Extension
extension SimulationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        matrix.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        matrix.first?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonsCollectionViewCell.reuseId, for: indexPath) as! PersonsCollectionViewCell
        let item = matrix[indexPath.section][indexPath.row]
        if !item  {
            cell.imageView.backgroundColor = .systemGreen
        } else {
            cell.imageView.backgroundColor = .systemRed
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.global(qos: .background).async {
            self.selectCell()
            let item = self.matrix[indexPath.section][indexPath.row]
            DispatchQueue.main.async {
                if item {
                    self.matrix[indexPath.section][indexPath.row].toggle()
                } else {
                    self.matrix[indexPath.section][indexPath.row].toggle()
                }
            }
        }
        collectionView.reloadData()
    }
}

