import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchable_list/HttpService.dart';
import 'package:searchable_list/searchProvider.dart';
import 'package:searchable_list/todo_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HttpService>(create: (_)=>HttpService()),
        ChangeNotifierProvider<SearchProvider>(create: (_)=>SearchProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.green,
        ),
        home: const MyHomePage(title: 'Searchable list'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 late  HttpService httpService;
 List<TodoModel> _list = [];
 List<TodoModel> _searchlist = [];

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    httpService =  Provider.of<HttpService>(context, listen: false);
    super.initState();
    getData();
  }
  getData() async{
    _list = await httpService.getTodoList();
  }

  @override
  Widget build(BuildContext context) {

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
       actions: [
         Container(
           padding: const EdgeInsets.all(12),
           width: MediaQuery.of(context).size.width,
           child: Consumer<SearchProvider>(
             builder: (context, provider, child){
               return TextField(
                 textInputAction: TextInputAction.search,
                 decoration: InputDecoration(
                     hintText: "Search here..."
                 ),
                 controller: searchController,
                 onChanged: (value){
                   if(value.isEmpty){
                     _searchlist.clear();
                     provider.updateController(false);
                   }
                 },
                 onEditingComplete: (){
                   if(searchController.text.isNotEmpty) {

                     _list.forEach((element) {
                       if (element.title!.startsWith(searchController.text)) {
                         _searchlist.add(element);
                       }
                     });
                     provider.updateController(true);
                   }

                 },
               );
             },
           ),
         )
       ],
      ),
      body:Consumer2<HttpService,SearchProvider>(builder: (BuildContext context, httpService, searchProvider, Widget? child) {

        return httpService.isLoading == true? const Center(child: CircularProgressIndicator()): _list != []?
        searchProvider.isSearching ==true?ListView.builder(
          itemCount: _searchlist.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text(_searchlist[index].title??""),);
          },):ListView.builder(
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text(_list[index].title??""),);
          },)
            : Container();
      },
      )
    );
  }
}
