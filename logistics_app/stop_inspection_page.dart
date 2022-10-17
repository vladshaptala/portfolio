import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logistics/app/app_builder.dart';
import 'package:logistics/core/router/router.dart';
import 'package:logistics/core/router/routes_list.dart';
import 'package:logistics/models/inspection/inspection_field_model.dart';
import 'package:logistics/models/file/file_model.dart';
import 'package:logistics/models/stop/stop_inspection_model.dart';
import 'package:logistics/models/trip/stop_model.dart';
import 'package:logistics/styles/index.dart';
import 'package:logistics/utyls/helpers.dart';
import 'package:logistics/views/gallery_images/gallery_images_page.dart';
import 'package:logistics/views/stop_inspection/cubit/stop_inspection_cubit.dart';
import 'package:logistics/views/stop_inspection/cubit/stop_inspection_state.dart';
import 'package:logistics/widgets/add_photo_widget.dart';
import 'package:vector_logistics/widgets/comment_and_files_container.dart';
import 'package:logistics/widgets/bottom_bar_widget.dart';
import 'package:logistics/widgets/card_widget.dart';
import 'package:logistics/widgets/dialogs/app_dialog_android.dart';
import 'package:logistics/widgets/dispathcer_widget.dart';
import 'package:logistics/widgets/image_receipt.dart';
import 'package:logistics/widgets/inspection_container.dart';
import 'package:logistics/widgets/lumper_charge_widget.dart';
import 'package:logistics/widgets/unify/loading_wrapper.dart';
import 'package:image_picker/image_picker.dart';

final _formKey = new GlobalKey<FormState>();

class StopInspectionArgs {
  final StopModel stop;
  final List<InspectionFieldModel> inspectionFields;
  final String tripId;

  StopInspectionArgs({
    required this.stop,
    required this.inspectionFields,
    required this.tripId,
  });
}

class StopInspectionPage extends StatefulWidget {
  const StopInspectionPage({Key? key, required this.args}) : super(key: key);

  final StopInspectionArgs args;

  static MaterialPageRoute route(StopInspectionArgs args) {
    return MaterialPageRoute(
        builder: (context) => StopInspectionPage(args: args));
  }

  @override
  State<StopInspectionPage> createState() => _StopInspectionPageState();
}

class _StopInspectionPageState extends State<StopInspectionPage> {
  late final StopInspectionCubit _cubit;

  @override
  void initState() {
    _cubit = StopInspectionCubit(
      stopInspection: StopInspectionModel(
        stopId: widget.args.stop.id,
        inspectionFields: widget.args.inspectionFields,
        inspections: [],
        files: [],
        bolPhotos: [],
      ),
      tripId: widget.args.tripId,
    );
    _cubit.getChargeCategories();
    super.initState();
  }

  void _addBOLPhotosModal() {
    AppBuilder.showModalAppBottomSheet(
      AddPhotoWidget(
        addPhotoFrom: (source) => _cubit.addBOLPhotos(source),
      ),
    );
  }

  void _next(int step) {
    if (step == 1) {
      _cubit.next();
    }
    if (step == 2) {
      final isInputValid = _formKey.currentState!.validate();
      if (isInputValid) {
        _cubit.next();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocProvider(
        create: (context) => _cubit,
        child: BlocBuilder<StopInspectionCubit, StopInspectionState>(
          builder: (context, state) {
            return LoadingWrapper(
              loading: state.loading,
              child: Scaffold(
                appBar: AppBar(
                  title: Text("common_inspection".t),
                ),
                body: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DispatcherContainer(
                        dispatcherName: widget.args.stop.contactPerson,
                        phone: widget.args.stop.phone,
                      ),
                      AppSpacer.xlg,
                      if (state.step == 1)
                        _Step1InspectionContainer(
                          deleteBOLPhoto: _cubit.deleteBOLPhoto,
                          addBOLPhotosModal: _addBOLPhotosModal,
                        ),
                      if (state.step == 2)
                        _Step2InspectionContainer(
                          setFieldValue: _cubit.setFieldValue,
                          updateLumperPrice: _cubit.updateLumperPrice,
                          setLumper: _cubit.setLumper,
                          addLumperPhoto: _cubit.addLumperPhoto,
                          deleteLumperPhoto: _cubit.deleteLumperPhoto,
                          setFieldPhoto: _cubit.setFieldPhoto,
                          deleteFieldPhoto: _cubit.deleteFieldPhoto,
                          deleteFile: _cubit.deleteFile,
                          addFile: _cubit.addFile,
                        ),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomBarWidget(
                  step: state.step,
                  isDataFilled: state.isDataFilled,
                  next: () => _next(state.step),
                  back: _cubit.back,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Step1InspectionContainer extends StatelessWidget {
  final Function deleteBOLPhoto;
  final VoidCallback addBOLPhotosModal;
  const _Step1InspectionContainer({
    Key? key,
    required this.deleteBOLPhoto,
    required this.addBOLPhotosModal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopInspectionCubit, StopInspectionState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpaces.xmd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "common_bol".t,
                    style: AppTextStyles.subhead2,
                  ),
                  AppSpacer.md,
                  Text(
                    "add_photos".t,
                    style: AppTextStyles.point,
                  ),
                ],
              ),
              AppSpacer.mds,
              Wrap(
                alignment: WrapAlignment.start,
                spacing: AppSpaces.sm,
                runSpacing: AppSpaces.sm,
                children: [
                  ImageReceipt(
                    onImageAdd: state.stopInspection.bolPhotos.length < 7
                        ? addBOLPhotosModal
                        : null,
                  ),
                  for (final file in state.stopInspection.bolPhotos)
                    ImageReceipt(
                      image: file.originalUrl,
                      onImageTap: () => RouterCore.goTo(
                        GalleryImagesRoute,
                        arguments: GalleryImagesArgs(
                          images: state.stopInspection.bolPhotos,
                        ),
                      ),
                      onImageDelete: () => AppBuilder.showAppDialog(
                        AppDialogAndroid(
                          title: 'common_confirm_action'.t,
                          content: 'want_to_delete_file'.t,
                          actions: AppDialogAndroid.cancelOkButtons(
                            () => deleteBOLPhoto(file),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              AppSpacer.xlg,
              Container(
                padding: EdgeInsets.all(AppSpaces.xmd),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Photos must be taken of all BOL pages, which must be of good quality, readable, well-lit, and free of foreign objects.',
                  style: AppTextStyles.body,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _Step2InspectionContainer extends StatelessWidget {
  final Function(String, String, bool) setFieldValue;
  final Function(String) updateLumperPrice;
  final Function(bool) setLumper;
  final Function(ImageSource) addLumperPhoto;
  final VoidCallback deleteLumperPhoto;
  final Function({required String fieldName}) setFieldPhoto;
  final Function({required String fieldName}) deleteFieldPhoto;
  final Function(FileModel file) addFile;
  final Function(int index) deleteFile;
  const _Step2InspectionContainer({
    Key? key,
    required this.setFieldValue,
    required this.updateLumperPrice,
    required this.setLumper,
    required this.addLumperPhoto,
    required this.deleteLumperPhoto,
    required this.setFieldPhoto,
    required this.deleteFieldPhoto,
    required this.addFile,
    required this.deleteFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopInspectionCubit, StopInspectionState>(
      builder: (context, state) {
        return Column(
          children: [
            InspectionContainer(
              title: "common_reefer_settings".t,
              inspections: state.stopInspection.inspections,
              inspectionFields: state.reeferInspectionFields,
              setInspectionValue: setFieldValue,
              setFieldPhoto: setFieldPhoto,
              deletePhoto: deleteFieldPhoto,
            ),
            if (state.reeferInspectionFields.isNotEmpty) AppSpacer.xlg,
            InspectionContainer(
              title: "common_temperature".t,
              inspections: state.stopInspection.inspections,
              inspectionFields: state.tepmeratureInspectionFields,
              setInspectionValue: setFieldValue,
              setFieldPhoto: setFieldPhoto,
              deletePhoto: deleteFieldPhoto,
            ),
            if (state.tepmeratureInspectionFields.isNotEmpty) AppSpacer.xlg,
            InspectionContainer(
              title: "common_trailer_settings".t,
              inspections: state.stopInspection.inspections,
              inspectionFields: state.stepDeckInspectionFields,
              setInspectionValue: setFieldValue,
              setFieldPhoto: setFieldPhoto,
              deletePhoto: deleteFieldPhoto,
            ),
            AppSpacer.xlg,
            CommentAndFilesContainer(
              title: "common_other".t,
              files: state.stopInspection.files,
              addFile: addFile,
              deleteFile: deleteFile,
              setInspectionValue: setFieldValue,
            ),
            AppSpacer.xlg,
          ],
        );
      },
    );
  }
}

class _DispatcherContainer extends StatelessWidget {
  final String? dispatcherName;
  final String? phone;

  const _DispatcherContainer({
    this.dispatcherName,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      topNoRounded: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpaces.md,
          horizontal: AppSpaces.mds,
        ),
        child: DispatcherWidget(
          dispatcherName: dispatcherName,
          phone: phone,
        ),
      ),
    );
  }
}
