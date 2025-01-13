import 'package:every_read/common/widgets/loading_widget.dart';
import 'package:every_read/features/fb2_reader/bloc/fb2_reader_bloc.dart';
import 'package:every_read/features/fb2_reader/ui/fb2_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/routes_class.dart';

class Fb2ReaderBuilder extends StatelessWidget {
  const Fb2ReaderBuilder({super.key});

  @override
  Widget build(BuildContext context) {

    buildFailureScreen(String errorMessage)  {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(RoutesClass.home);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_outlined, color: Colors.red),
              Text("Something go wrong:\n $errorMessage")
            ]
          )
        )
      );
    }

    return BlocConsumer<Fb2ReaderBloc, Fb2ReaderState> (
      listener: (context, state) {

      },
      builder: (context, state) {
        switch (state) {
          case Fb2ReaderLoading():
            return const LoadingWidget();
          case Fb2ReaderFailure():
            return buildFailureScreen(state.message);
          case Fb2ReaderBookLoaded():
            return Fb2Reader(book: state.book);
        }
      }
    );
  }

}