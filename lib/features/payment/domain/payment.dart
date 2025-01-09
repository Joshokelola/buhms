class Payment {
 
 Payment({
    required this.id,
    required this.userId,
    required this.amount,
    required this.paymentDate, // On the backend, need to update the value of this after successful payment
    required this.status,
  }); // 'pending', 'completed', 'failed'
factory Payment.defaultPayment() {
    return Payment(
      id: '',
      userId: '',
      amount: 0,
      paymentDate: DateTime.now(),
      status: 'pending',
    );
  }
  final String id;
  final String userId;
  final double amount;
  final DateTime paymentDate;
  final String status;
  

  @override
  String toString() {
    return 'Payment(id: $id, userId: $userId, amount: $amount, paymentDate: $paymentDate, status: $status)';
  }
}
