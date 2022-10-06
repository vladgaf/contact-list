import 'package:flutter/material.dart';
import 'package:test_task/domain/blocs/bloc/contact_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/entities/contact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (_) => ContactBloc()..add(ContactInit()),
        child: HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  HomeBody({Key? key}) : super(key: key);

  final ScrollController controller = ScrollController();

  void refresh(BuildContext context) =>
      context.read<ContactBloc>().add(ContactInit());

  void controllerListener(BuildContext context) {
    final position = controller.offset / controller.position.maxScrollExtent;
    if (position >= 0.8) {
      context.read<ContactBloc>().add(ContactNextPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: ((context, state) {
        print(state);
        if (state is ContactSuccess) {
          return RefreshIndicator(
            onRefresh: () async => refresh(context),
            child: ListView(
              controller: controller
                ..addListener(() => controllerListener(context)),
              children:
                  state.contacts.map((e) => ContactCard(contact: e)).toList(),
            ),
          );
        }
        if (state is ContactError) {
          return Center(
            child: Column(
              children: [
                Text(state.message),
                ElevatedButton(
                  onPressed: () => refresh(context),
                  child: const Text("Refresh"),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

class ContactCard extends StatelessWidget {
  final Contact contact;
  const ContactCard({
    Key? key,
    required this.contact,
  }) : super(key: key);

  void showModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModal(context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color.fromARGB(255, 184, 184, 184)),
          ),
          //color: Color.fromARGB(255, 238, 238, 238),
          //borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        width: double.infinity,
        //height: 100,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: ClipOval(
              child: Image(
                image: NetworkImage(contact.photo),
                width: 50,
                height: 50,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${contact.name} ${contact.surname}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text('${contact.phoneNumber}',
                      style: TextStyle(
                          color: Color.fromARGB(255, 90, 90, 90),
                          fontWeight: FontWeight.w300,
                          fontSize: 15)),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
