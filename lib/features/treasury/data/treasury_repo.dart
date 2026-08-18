import '../../../core/storage/object_box/local_box.dart';
import '../../../core/storage/object_box/object_box_storage.dart';
import '../../orders/data/models/order_entity.dart';
import 'models/treasury_transaction_entity.dart';

class TreasuryRepo {
  TreasuryRepo({required ObjectBoxStorage storage})
      : _box = storage.box<TreasuryTransactionEntity>();

  final LocalBox<TreasuryTransactionEntity> _box;

  List<TreasuryTransactionEntity> getAll() {
    final all = _box.getAll();
    all.sort((a, b) =>
        (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    return all;
  }

  Stream<List<TreasuryTransactionEntity>> watchAll() =>
      _box.watchAll().map((all) => all
        ..sort((a, b) => (b.createdAt ?? DateTime(0))
            .compareTo(a.createdAt ?? DateTime(0))));

  TreasuryTransactionEntity add({
    required String title,
    required String subtitle,
    required double amount,
    required bool isIncome,
    PaymentMethod? paymentMethod,
    int? orderId,
    String? createdBy,
  }) {
    final transaction = TreasuryTransactionEntity(
      title: title,
      subtitle: subtitle,
      amount: amount,
      isIncome: isIncome,
      paymentMethod: paymentMethod?.index,
      orderId: orderId,
      createdAt: DateTime.now(),
      createdBy: createdBy,
    );
    transaction.id = _box.put(transaction);
    return transaction;
  }

  void updatePaymentMethod(
    TreasuryTransactionEntity transaction,
    PaymentMethod method,
  ) {
    transaction.paymentMethodEnum = method;
    _box.put(transaction);
  }

  List<TreasuryTransactionEntity> getByOrderId(int orderId) =>
      _box.getAll().where((t) => t.orderId == orderId).toList();

  int updatePaymentMethodForOrder(int orderId, PaymentMethod method) {
    final transactions = getByOrderId(orderId);
    for (final transaction in transactions) {
      updatePaymentMethod(transaction, method);
    }
    return transactions.length;
  }

  double totalIncome(List<TreasuryTransactionEntity> transactions) =>
      transactions
          .where((t) => t.isIncome)
          .fold<double>(0, (sum, t) => sum + t.amount);

  double totalExpense(List<TreasuryTransactionEntity> transactions) =>
      transactions
          .where((t) => !t.isIncome)
          .fold<double>(0, (sum, t) => sum + t.amount);

  double totalCash(List<TreasuryTransactionEntity> transactions) => transactions
      .where((t) => t.paymentMethodEnum != PaymentMethod.wallet)
      .fold<double>(0, (sum, t) => sum + (t.isIncome ? t.amount : -t.amount));

  double totalWallet(
          List<TreasuryTransactionEntity> transactions) =>
      transactions
          .where((t) => t.paymentMethodEnum == PaymentMethod.wallet)
          .fold<double>(
              0, (sum, t) => sum + (t.isIncome ? t.amount : -t.amount));
}
