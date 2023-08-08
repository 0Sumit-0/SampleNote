import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Sample note taking app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TextEditingController> controller = [
    TextEditingController(),
  ];

  void _ideaCreate() {
    controller.add(TextEditingController());
    isready.add(false);
    setState(() {});
  }

  void _editIdea(int index) {
    isready[index] = false;
    setState(() {});
  }

  void _deleteIdea(int index) {
    controller.removeAt(index);
    isready.removeAt(index);
    backlinksMap.remove({backlinksMap[index]:index});
    selectedOption.removeAt(index);
    isaddedback.removeAt(index);
    setState(() {});
  }

  List<bool> isready = [
    false,
  ];

  Map<String, int> backlinksMap = {};
  List<String> backlink = [];
  List<String> selectedOption=[];
  List<bool> isaddedback=[false];

  // List<Map<int, String>> recommend = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              child: ListView.builder(
                itemCount: controller.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onLongPress: () {
                      _deleteIdea(index);
                    },
                    child: ListTile(
                      title: Row(
                        children: [
                          Text("Idea $index"),
                          SizedBox(width: 10,),
                          isaddedback[index]?Text("        "+selectedOption[index].toString(),style: TextStyle(color: Colors.blue),):(backlink.isEmpty?Text(""):
                          DropdownButton<String>(
                            // value: selectedOption[index],
                            items: backlink.map((String item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(
                                  'Backlink: $item',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                backlinksMap[value.toString()] = index;
                                selectedOption[index]=(value!);
                                isaddedback[index]=true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Backlink added for Idea $index',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              );
                            },
                          ))
                        ],
                      ),
                      subtitle: isready[index]
                          ? Row(children:[Text((controller[index].text)),SizedBox(width: 20,),isaddedback[index]?Text("Idea "+(backlinksMap[controller[index].text]).toString(),style: TextStyle(color: Colors.blue),):Text("")])
                          : TextFormField(
                              controller: controller[index],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Whats Your Idea",
                                  hintText: "Your Idea"),
                              onFieldSubmitted: (value) {
                                if (value.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    "Cannot be empty!",
                                    style: TextStyle(fontSize: 20),
                                  )));
                                } else {
                                  setState(() {
                                    isready[index] = true;
                                    backlink.add(controller[index].text);
                                    isaddedback.add(false);
                                    selectedOption.add("value");
                                  });
                                }
                              },
                            ),
                      trailing: isready[index]
                          ? IconButton(
                              icon: Icon(Icons.arrow_forward_ios_rounded),
                              onPressed: () {
                                _editIdea(index);
                              },
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ideaCreate,
        tooltip: 'Add Idea',
        child: const Icon(Icons.add),
      ),
    );
  }
}
