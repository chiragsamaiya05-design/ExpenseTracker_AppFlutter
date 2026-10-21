
class Expense {
  final int? id;
  final String? serverId;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final bool isSynced;


  const Expense({
    this.id,
    this.serverId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.isSynced= false,
  });

  Map<String,dynamic>toMap(){
    return{
      if(id!= null)'id': id,
      'title':title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id']as int?,
      serverId: map['server_id'] as String?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      isSynced: (map['is_synced'] as int? ?? 0)==1,
    );
  }

  Expense copyWith({
    int? id,
    String? serverId,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    bool? isSynced,

}){
    return Expense(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
    );
}
}