import Foundation


enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    init?(calendarWeekday: Int) {
        self.init(rawValue: calendarWeekday)
    }
}
