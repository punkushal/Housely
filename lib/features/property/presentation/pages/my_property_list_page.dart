import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/features/home/presentation/widgets/property_list.dart';
import 'package:housely/features/property/presentation/bloc/property_bloc.dart';

@RoutePage()
class MyPropertyListPage extends StatefulWidget {
  const MyPropertyListPage({super.key});

  @override
  State<MyPropertyListPage> createState() => _MyPropertyListPageState();
}

class _MyPropertyListPageState extends State<MyPropertyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My properties")),
      body: BlocBuilder<PropertyBloc, PropertyFetchState>(
        builder: (context, state) {
          if (state is PropertyLoaded && state.allProperties.isNotEmpty) {
            return PropertyList(propertyList: state.allProperties);
          } else if (state is PropertyFetchLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Text(
              "No properties added yet",
              style: AppTextStyle.headingSemiBold(
                context,
                color: AppColors.border,
              ),
            ),
          );
        },
      ),
    );
  }
}
