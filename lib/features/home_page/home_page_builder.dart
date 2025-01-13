import 'package:every_read/features/home_page/widgets/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/routes_class.dart';
import '../../common/widgets/loading_widget.dart';
import 'bloc/home_page_bloc.dart';

class HomePageBuilder extends StatelessWidget {
  const HomePageBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      listener: (context, state) {
        if (state is HomePageStartLoadingDoc) {
          if (state.document.filePath.endsWith(".pdf")) {
            Navigator.of(context).pushNamed(RoutesClass.pdfViewer);
          }
          else if (state.document.filePath.endsWith(".fb2")) {
            Navigator.of(context).pushNamed(RoutesClass.fb2Viewer);
          }
          else if (state.document.filePath.endsWith(".txt")) {
            Navigator.of(context).pushNamed(RoutesClass.txtViewer);
          }
          else {
            BlocProvider.of<HomePageBloc>(context)
                .add(HomePageErrorOccurred("Unsupported file extension"));
          }
        }
      },
      buildWhen: (context, state) {
        if (state is HomePageStartLoadingDoc) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is HomePageLoading) {
          return const LoadingWidget();
        }
        if (state is HomePageLoaded) {
          return HomePage(previousDocs: state.previousDocs);
        }
        if (state is HomePageFailure) {
          return Center(child: Text("Load previous failure ${state.errorMessage}")); // TODO refactor to dialog?
        }
        return Center(child: Text("Something go wrong $state}"));
      }
    );
  }


}