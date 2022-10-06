import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_task/domain/data_providers/repository.dart';

import '../../entities/contact.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final Repository _repo = Repository();
  List<Contact> contactList = [];
  int page = 1;
  ContactBloc() : super(ContactInitial()) {
    on<ContactInit>(_init);
    on<ContactRefresh>(_refresh);
    on<ContactNextPage>(
      _nextpage,
      transformer: (events, mapper) {
        return events
            .debounceTime(const Duration(milliseconds: 300))
            .asyncExpand(mapper);
      },
    );
    on<ContactAddList>((event, emit) {
      contactList.addAll(event.contacts);
      emit(ContactSuccess(contactList));
    });
    on<ContactNewList>((event, emit) {
      contactList = event.contacts;
      emit(ContactSuccess(contactList));
    });
    on<ContactMistake>((event, emit) => emit(ContactError(event.e.toString())));
  }

  void _init(ContactInit event, Emitter<ContactState> emit) {
    _repo
        .generateContactList(page, count: 10)
        .then((value) => add(ContactNewList(value.contacts)))
        .onError<Exception>((error, _) => add(ContactMistake(error)));
  }

  FutureOr<void> _refresh(event, Emitter<ContactState> emit) {
    final int newSeed = Random().nextInt(100);
    seed = newSeed;
    page = 1;
    _repo
        .generateContactList(page, count: 10)
        .then((value) => add(ContactNewList(value.contacts)))
        .onError<Exception>((error, _) => add(ContactMistake(error)));
  }

  FutureOr<void> _nextpage(ContactNextPage event, Emitter<ContactState> emit) {
    print(state);
    if (state is! ContactError) {
      page++;
    }
    _repo
        .generateContactList(page, count: 10)
        .then((value) => add(ContactAddList(value.contacts)))
        .onError<Exception>((error, _) => page--);
  }
}
