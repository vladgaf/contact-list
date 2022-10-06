part of 'contact_bloc.dart';

@immutable
abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactSuccess extends ContactState {
  final List<Contact> contacts;
  ContactSuccess(this.contacts);
}

class ContactError extends ContactState {
  final String message;
  ContactError(this.message);
}
