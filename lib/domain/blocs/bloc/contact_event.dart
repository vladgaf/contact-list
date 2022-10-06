part of 'contact_bloc.dart';

@immutable
abstract class ContactEvent {}

class ContactInit extends ContactEvent {}

class ContactNewList extends ContactEvent {
  final List<Contact> contacts;
  ContactNewList(this.contacts);
}

class ContactMistake extends ContactEvent {
  final Exception e;
  ContactMistake(this.e);
}

class ContactRefresh extends ContactEvent {}

class ContactNextPage extends ContactEvent {}

class ContactAddList extends ContactEvent {
  final List<Contact> contacts;
  ContactAddList(this.contacts);
}
