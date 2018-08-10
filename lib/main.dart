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
                floatingActionButton: FloatingActionButton(tooltip: "Pushed button", child: Icon(Icons.add), onPressed: (){ _showScreen(); },),     // onPressed - not realized
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







class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}