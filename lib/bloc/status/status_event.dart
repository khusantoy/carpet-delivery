part of 'status_bloc.dart';

sealed class StatusEvent {}

class ChangeStatusEvent extends StatusEvent {
  final String orderId;
  final String status;

  ChangeStatusEvent({required this.orderId, required this.status});
}
