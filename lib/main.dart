import 'package:flut/layout_one.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() => runApp(new MyApp());

// StatelessWidget - виджеты без отслеживания состояния неизменяемые, их свойства не могут изменяться. Все значения являются окончательными
// StatefulWidget - виджеты с отслеживанием состояния поддерживают состояние, которое может изменяться с течением времени
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();                                         // Генерация рандомных слов

    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        accentColor: Colors.orange,
      ),

      home: RandomWords(),

      // home: new MyHomePage(title: 'Flutter Demo Home Page'),
      // home: Scaffold(                                                        // Scaffold - это виджет для отбражения стандартных app bar, title, and a body property
      // appBar: AppBar(title: Text("Welcome to Flutter")),
      // body: Center(child: RandomWords(),)
      // ),

    );
  }
}


/// Виджет с отслеживанием состояния
class RandomWords extends StatefulWidget {
  @override
  createState() => RandomWordsState();
}

///
/// Состояние для генерации случайных слов
class RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // Сохраненные состояния (аналог Set в Java - Нет повторяющихся элементов)
  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(                                                            // Scaffold - это виджет для отбражения стандартных app bar, title, and a body property
      appBar: AppBar(
        title: Text("Startup name generator"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved,)

        ],
      ),

      // ListView
      body: _buildSuggestions(),
    );

  }

  /// Переход на другую страницу с выбранными элементами из ListView
  void _pushSaved(){
    // Кладем в Navigator (stack) новую страницу
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) {
              final tiles = _saved.map(
                      (pair) {
                    return ListTile(
                      title: Text(pair.asPascalCase, style: _biggerFont,),
                    );
                  }
              );

              final divided = ListTile.divideTiles(context: context, tiles: tiles).toList();
              // Возвращает новый экран
              return Scaffold(
                appBar: AppBar(title: Text("Saved suggestions")),
                body: ListView(children: divided),
                floatingActionButton: FloatingActionButton(
                  tooltip: "Pushed button",
                  child: Icon(Icons.add),
                  onPressed: (){ _showLayoutExample(); },),     // onPressed - not realized (_showScreen();)
              );
            }
        )
    );
  }


  /// Перейти на страницу с моими виджетами
  void _showScreen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text("My custom page"),),
            body: Center(child: MyButton(),),
          );
        })
    );
  }


  void _showLayoutExample() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        // Return layout
        return new MyLayoutExample();
      })
    );
  }



  /// Виджет для построения ListView
  Widget _buildSuggestions() {
    return ListView.builder(
      // Отступы везде
        padding: const EdgeInsets.all(16.0),

        itemBuilder: (context, i) {
          // Добавляем разделитель перед каждой row
          if(i.isOdd) return Divider();

          // Делим i на 2 и возвращаем целый результат (остаток от деления)
          final index = i ~/ 2;

          if(index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  /// List Item row
  Widget _buildRow(WordPair pair) {
    // Уже сохраненные состояния в Set
    final alreadySaved = _saved.contains(pair);
    /// One List ITEM
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        // Icon
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        // Icon color
        color: alreadySaved ? Colors.red : null,
      ),
      /// Поведение при Tap на List item
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }


  // Examples layouts

  // Title section
  Widget titleSection = Container(
    padding: const EdgeInsets.all(32.0),
    child: Row(
      children: <Widget>[
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('Oeschinen Lake Campground', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Text('Kandersteg, Switzerland', style: TextStyle(color: Colors.grey),)
          ],
        )),
        Icon(Icons.stars, color: Colors.red[500],),
        Text('41')
      ],
    ),
  );


}




/// Test my custom Widgets
class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('MyButton was tapped!');
      },
      child: Container(
        height: 36.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: Center(
          child: Text('Engage'),
        ),
      ),
    );
  }
}







/*class ExampleLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Oeschinen Lake Campground', style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Text('Kandersteg, Switzerland', style: TextStyle(color: Colors.grey),)
            ],
          )),
          Icon(Icons.stars, color: Colors.red[500],),
          Text('41')
        ],
      ),
    );

    return titleSection;
  }
}*/


