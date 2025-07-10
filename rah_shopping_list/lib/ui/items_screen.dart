import 'package:flutter/material.dart';
import 'package:rah_shopping_list/ui/list_item_dialog.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';
import '../util/dbhelper.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  ItemsScreen(this.shoppingList);
  @override
  _ItemsScreenState createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  _ItemsScreenState(this.shoppingList);
  late DbHelper helper;
  List<ListItem> items = [];
  ListItemDialog dialog = ListItemDialog();


  @override
  void initState() {
    helper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    showData(shoppingList.id);
    return Scaffold(
        appBar: AppBar(
          title: Text(shoppingList.name),
        ),
        body: ListView.builder(

            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
              key: Key(items[index].name),
              onDismissed: (direction) {
                String strName = items[index].name;
                helper.deleteItem(items[index]);
                setState(() {
                  items.removeAt(index);
                });
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("$strName deleted")));
              },


              child: ListTile(
                  title: Text(items[index].name),
                  subtitle: Text(
                    'Quantity: ${items[index].quantity} - Note: ${items[index].note}',
                  ),
                  onTap: () {},
                    trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (BuildContext context) =>
                                dialog.buildAlert(context, items[index], false),
                      );
                    },
                  ),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (BuildContext context) => dialog.buildAlert(
                  context,
                  ListItem(0, shoppingList.id, '', '', ''),
                  true,
                ),
          );
        },
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
      ),
    );
  }
  
  Future showData(int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);
    setState(() {
      items = items;
    });
  }
}