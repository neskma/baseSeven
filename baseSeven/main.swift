//
//  main.swift
//  baseSeven
//
//  Created by Dmitry on 04.11.2021.
//
//
//


import Foundation

// MARK - возможные ошибки при попытке оплатить кредиткой
enum CreditCardOperationError: Error {
    case noMoney (moneyNeeded: Double)
    case frozenBalance
}

struct thing {
    var price: Double
}

final class CreditCardOperation {
    private let limit: Double = -100000
    var balance: Double = 0
    private var cardBlocked = false
    
    func buySomethig(thing: thing) throws {
        guard cardBlocked == false else {
            throw CreditCardOperationError.frozenBalance
        }
        // MARK - провека на возможность покупки товара
        guard thing.price <= (-limit + self.balance) else {
            // MARK - рассчет остатка средств на карте с учётом лимита
            if balance < 0 {
                throw CreditCardOperationError.noMoney(moneyNeeded: thing.price + limit + balance)
            } else {
                throw CreditCardOperationError.noMoney(moneyNeeded: thing.price + limit - balance)
            }
        }
        // MARK - списание денег за товар с карты
        balance = self.balance - thing.price
    }
    
    // MARK - пополнение карты
    func depositeMoney (someMoney: Double) {
        balance = self.balance + someMoney
    }
    
    // MARK - отображение баланса
    func printBalance() {
        print ("У Вас на счету \(balance) рублей")
    }
    
    // MARK - блокировка карты
    func changeCardState(cardBlocked: Bool) {
        switch cardBlocked {
        case true:
            self.cardBlocked = true
        case false:
            self.cardBlocked = false
        }
    }
}

extension CreditCardOperationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .noMoney(let moneyNeeded):
            return "Недостаточно средств на счеты для данной операции. Ваш баланс: \(operation.balance) рублей, необходимо: \(moneyNeeded) рублей"
        case .frozenBalance:
            return "Ваша карта заблокированна. Для получения дополнительной информации обратитесь в банк."
        }
    }
}


// MARK - операции по карте
let operation = CreditCardOperation()
do {
    try operation.buySomethig(thing: .init(price: 8990))
} catch let error as CreditCardOperationError {
    print(error.description)
}
operation.printBalance()
operation.depositeMoney(someMoney: 10000)
operation.printBalance()
do {
    try operation.buySomethig(thing: .init(price: 120000))
} catch let error as CreditCardOperationError {
    print(error.description)
}
operation.printBalance()
do {
    try operation.buySomethig(thing: .init(price: 39990))
} catch let error as CreditCardOperationError {
    print(error.description)
}
operation.printBalance()

// MARK - банк блокирует карту
operation.changeCardState(cardBlocked: true)

// MARK - попытка покупки после блокировки карты
do {
    try operation.buySomethig(thing: .init(price: 490))
} catch let error as CreditCardOperationError {
    print(error.description)
}
