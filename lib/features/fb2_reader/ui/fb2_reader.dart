import 'package:every_read/common/models/document_model.dart';
import 'package:every_read/features/app/repositories/app_settings_repository.dart';
import 'package:every_read/features/fb2_reader/parser/fb2_parser.dart';
import 'package:every_read/features/fb2_reader/parser/models/fb2_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xml/xml.dart';

class Fb2Reader extends StatefulWidget {
  const Fb2Reader({super.key, required this.book});
  final DocumentModel book;

  @override
  Fb2ReadersState createState() => Fb2ReadersState();
}

class Fb2ReadersState extends State<Fb2Reader>  {
  final ScrollController _scrollController = ScrollController();
  late DocumentModel document;
  late FB2Parser book;
  late Future<void> _loadBookFuture;
  late int section;

  @override
  void initState() {
    super.initState();
    section = widget.book.currentPosition;
    _loadBookFuture = _loadBook();
  }

  Future<void> _loadBook() async {
    book = FB2Parser(widget.book.fileContent!);
    await book.parse();
  }

  Widget extractText(FB2Section section) {
    final document = XmlDocument.parse(section.content.toString());
    List<InlineSpan> bookPage = [];

    InlineSpan getTextFromNode(XmlNode node) {
      if (node is XmlText) {
        return TextSpan(text: node.value);
      } else if (node is XmlElement) {
        switch (node.name.local) {
          case 'strong':
            return TextSpan(
              children: node.children.map(getTextFromNode).toList(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          case 'emphasis':
            return TextSpan(
              children: node.children.map(getTextFromNode).toList(),
              style: const TextStyle(fontStyle: FontStyle.italic),
            );
          case 'emptyline':
            return const TextSpan(text: '\n\n');
          case 'p':
            return TextSpan(
              children: node.children.map(getTextFromNode).toList(),
            );
          default:
            return TextSpan(
              children: node.children.map(getTextFromNode).toList(),
            );
        }
      }
      return const TextSpan(text: "");
    }

    for (var node in document.descendants) {
      if (node is XmlElement && node.parent == document.rootElement) {
        final nodeSpan = getTextFromNode(node);
        bookPage.add(nodeSpan);
        bookPage.add(const TextSpan(text: '\n'));
      }
    }
    return RichText(
     text: TextSpan(
       style: const TextStyle(color: Colors.black, fontSize: 12),
       children: bookPage
     )
    );
  }


  Widget _buildBook() {
    AppSettingsRepository appSettingsRepository = RepositoryProvider.of<AppSettingsRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${book.description.title}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [extractText(book.body.sections![section])]
        )
      )),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        if (section != 0) ... [
          IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
               if (section > 0 ) {
                 section -= 1;
                 appSettingsRepository.updateCurrentDocument(
                   appSettingsRepository.currentDocument!.copyWith(
                     currentPosition: section,
                     docLength: book.body.sections!.length // TODO change this when load file first time
                   )
                 );
                  setState(() {
                    _scrollController.jumpTo(0.0);
                  });
               }
              }
          ),
        ],
        Text("$section of ${book.body.sections!.length - 1}"),
        if (section != book.body.sections!.length - 1) ... [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              if (section < book.body.sections!.length - 1) {
                section += 1;
                appSettingsRepository.updateCurrentDocument(
                  appSettingsRepository.currentDocument!.copyWith(
                      currentPosition: section,
                      docLength: book.body.sections!.length
                  )
                );
              setState(() {
                  _scrollController.jumpTo(0.0);
                });
              }
            }
          ),
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadBookFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error while parse fb2: ${snapshot.error}")); // TODO replace
        } else {
          return _buildBook();
        }
      }
    );
  }

}