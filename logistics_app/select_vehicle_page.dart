import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistics/core/router/index.dart';
import 'package:logistics/styles/index.dart';
import 'package:logistics/utyls/global_enums.dart';
import 'package:logistics/views/inspection/select_vehicle/cubit/select_vehicle_cubit.dart';
import 'package:logistics/views/inspection/select_vehicle/cubit/select_vehicle_state.dart';
import 'package:logistics/views/inspection/select_vehicle/widgets/search_field.dart';
import 'package:logistics/widgets/list_item.dart';

class SelectVehicleArgs {
  final List<VehicleType> vehicleType;

  SelectVehicleArgs({
    required this.vehicleType,
  });
}

class SelectVehiclePage extends StatefulWidget {
  const SelectVehiclePage({Key? key, required this.arg}) : super(key: key);

  final SelectVehicleArgs arg;

  static Widget build(SelectVehicleArgs arg) {
    return SelectVehiclePage(arg: arg);
  }

  static MaterialPageRoute route(SelectVehicleArgs arg) {
    return MaterialPageRoute(
        builder: (context) => SelectVehiclePage.build(arg));
  }

  @override
  State<SelectVehiclePage> createState() => _SelectVehiclePageState();
}

class _SelectVehiclePageState extends State<SelectVehiclePage> {
  final SelectVehicleCubit _cubit = SelectVehicleCubit();

  @override
  void initState() {
    // TODO: implement initState

    _cubit.getVehicles(widget.arg.vehicleType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocBuilder<SelectVehicleCubit, SelectVehicleState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: SearchField(
                onSearch: (searchText) => {
                  _cubit.searchVehicle(
                    searchText,
                    widget.arg.vehicleType,
                  ),
                },
              ),
            ),
            body: Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: listTypes.length,
                itemBuilder: (context, index) {
                  return ListItem(
                    label: state.vehicleList[index].unit,
                    onTap: () => RouterCore.pop(
                      data: state.trailerList[index],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
