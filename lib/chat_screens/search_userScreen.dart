import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_firebase_chat/auth/auth_screen.dart';
import 'package:demo_firebase_chat/models/auth_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SearchUserScreen extends StatefulWidget {
  final UsersModel? usersModel;

  const SearchUserScreen({super.key, this.usersModel});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}
RxList<Map> searchResult = <Map>[].obs;
class _SearchUserScreenState extends State<SearchUserScreen> {
  final searchController = TextEditingController();
  RxBool isLoading = false.obs;

  void onSearch() async {
    setState(() {
      isLoading.value = true;
    });
    await FirebaseFirestore.instance.collection('users').where('name', isEqualTo: searchController.text).get().then((value) {
      if (value.docs.isEmpty) {
        // const SnackBar(content: Text('No User Found'));
        customSnackBar(content: 'No User Found');
        setState(() {
          isLoading.value = false;
        });
        return;
      }
      for (var element in value.docs) {
        if (element.data()['email'] != widget.usersModel?.email) {
          searchResult.add(element.data());
        }
      }
      setState(() {
        isLoading.value = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search user for chat'), backgroundColor: Colors.deepPurple[200]),
      body: Column(children: [
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), hintText: 'search user'),
              ),
            )),
            ElevatedButton.icon(onPressed: () => onSearch(), icon: const Icon(Icons.search), label: const Text('Search')),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        if (searchResult.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: searchResult.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(searchResult[index]['image'])),
                title: Text(searchResult[index]['name']),
                subtitle: Text(searchResult[index]['email']),
                trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.chat)),
              );
            },
          )
        else if (isLoading.value == true)
          const Center(
            child: CircularProgressIndicator(),
          )
      ]),
    );
  }
}
