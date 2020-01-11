class Holiday {
  final String date; // 01
  final String day; // Tues
  final String description; // New Year’s Day, which is on January 1, marks the start of the year in the Gregorian calendar and it's a public holiday in many countries. Count down to the New Year, no matter where you are.
  final String name; // new year day
  final String type; // Optional Holiday
  final String color;

  Holiday({this.date, this.day, this.description, this.name, this.type, this.color});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: json['date'], 
      day: json['day'], 
      description: json['description'], 
      name: json['name'], 
      type: json['type'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['day'] = this.day;
    data['description'] = this.description;
    data['name'] = this.name;
    data['type'] = this.type;
    data['color'] = this.color;
    return data;
  }
}
