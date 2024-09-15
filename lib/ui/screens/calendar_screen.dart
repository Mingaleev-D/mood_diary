import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Экран для отображения календаря.
///
/// Позволяет переключаться между отображением одного месяца и всего года.
/// Пользователь может выбрать день, который будет подсвечен. Также предусмотрена
/// возможность возвращения к сегодняшнему дню.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _showYear = false; // Показывать ли весь год или только текущий месяц
  DateTime? _selectedDay; // Выбранный день
  DateTime _today = DateTime.now(); // Текущий день (сегодня)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Возвращаемся назад
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showYear = !_showYear; // Переключаем состояние между месяцем и годом

                // _selectedDay = _today; // Возвращаем подсветку на "сегодня"
              });
            },
            child: Text(
              "Сегодня",
              style: TextStyle(color: Colors.blueGrey),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _showYear
                  ? YearGridCalendar(
                      year: DateTime.now().year,
                      selectedDay: _selectedDay,
                      onDaySelected: (day) {
                        setState(() {
                          _selectedDay = day; // Обновляем выбранный день
                        });
                      },
                    )
                  : Column(
                      children: [
                        // Добавляем отображение текущего месяца и года
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            DateFormat('MMMM yyyy').format(DateTime.now()),
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 16),
                        MonthCalendar(
                          DateTime.now(),
                          selectedDay: _selectedDay,
                          onDaySelected: (day) {
                            setState(() {
                              _selectedDay = day; // Обновляем выбранный день
                            });
                          },
                        ),
                      ],
                    ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showYear = !_showYear; // Переключаем состояние между месяцем и годом
                  });
                },
                child: Text(_showYear ? "Показать текущий месяц" : "Показать весь год"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Генерация дат для месяца
List<DateTime> generateMonthCells(DateTime month) {
  List<DateTime> cells = [];
  var totalDaysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

  var firstDayOfMonth = DateTime(month.year, month.month, 1);
  var previousMonth = firstDayOfMonth.subtract(const Duration(days: 1));
  var nextMonth = DateTime(month.year, month.month, totalDaysInMonth).add(const Duration(days: 1));

  var firstDayOfWeek = firstDayOfMonth.weekday;
  var previousMonthDays = DateUtils.getDaysInMonth(previousMonth.year, previousMonth.month);

  // Генерация дней предыдущего месяца
  var previousMonthCells = List.generate(firstDayOfWeek - 1,
      (index) => DateTime(previousMonth.year, previousMonth.month, previousMonthDays - index));
  cells.addAll(previousMonthCells.reversed);

  // Генерация дней текущего месяца
  var currentMonthCells =
      List.generate(totalDaysInMonth, (index) => DateTime(month.year, month.month, index + 1));
  cells.addAll(currentMonthCells);

  // Генерация дней следующего месяца
  var remainingCellCount = 35 - cells.length;
  if (cells.length > 35) {
    remainingCellCount = 42 - cells.length;
  }
  var nextMonthCells = List.generate(
      remainingCellCount, (index) => DateTime(nextMonth.year, nextMonth.month, index + 1));
  cells.addAll(nextMonthCells);

  return cells;
}

// Интерфейс для отображения дней недели
class WeekHeaders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"].map((day) {
          return Expanded(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _getDayColor(day),
              ),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getDayColor(String day) {
    if (day == "Сб") {
      return Colors.blueAccent;
    } else if (day == "Вс") {
      return Colors.red;
    }
    return Colors.black;
  }
}

// Интерфейс для ячеек календаря
Widget buildDayCell(
    DateTime day, DateTime selectedMonth, DateTime? selectedDay, Function(DateTime) onDaySelected) {
  bool isToday = day.day == DateTime.now().day && day.month == DateTime.now().month;
  bool isCurrentMonth = day.month == selectedMonth.month;
  bool isSelectedDay = selectedDay != null &&
      day.day == selectedDay.day &&
      day.month == selectedDay.month &&
      day.year == selectedDay.year;

  return GestureDetector(
    onTap: () => onDaySelected(day), // Выбор дня
    child: Container(
      decoration: BoxDecoration(
        color: isSelectedDay
            ? Colors.orange // Подсветка выбранного дня
            : isToday
                ? Colors.blue // Подсветка текущего дня ("сегодня")
                : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          day.day.toString(),
          style: TextStyle(
            color: isCurrentMonth ? Colors.black : Colors.grey,
            fontWeight: isSelectedDay || isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    ),
  );
}

/// Календарь для одного месяца.
///
/// Отображает сетку с днями месяца и позволяет выбрать конкретный день.
// Календарь для одного месяца
class MonthCalendar extends StatelessWidget {
  final DateTime month;
  final DateTime? selectedDay;
  final Function(DateTime) onDaySelected;

  MonthCalendar(this.month, {required this.selectedDay, required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    var cells = generateMonthCells(month);
    return Column(
      children: [
        WeekHeaders(),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.5,
          ),
          itemCount: cells.length,
          itemBuilder: (context, index) {
            return buildDayCell(cells[index], month, selectedDay, onDaySelected);
          },
        ),
      ],
    );
  }
}

/// Календарь для отображения всего года.
///
/// Показывает сетку с 12 месяцами, каждый из которых можно открыть и выбрать день.
// Сетка для отображения календаря на весь год
class YearGridCalendar extends StatelessWidget {
  final int year;
  final DateTime? selectedDay;
  final Function(DateTime) onDaySelected;

  YearGridCalendar({required this.year, required this.selectedDay, required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          year.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Два месяца в строке
            childAspectRatio: 1.0,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            var month = DateTime(year, index + 1);
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat.MMMM().format(month),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                MonthCalendar(
                  month,
                  selectedDay: selectedDay,
                  onDaySelected: onDaySelected,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
