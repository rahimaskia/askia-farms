import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../models/feed.dart';
import '../models/supplier.dart';
import '../notification_service.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/select_supplier.dart';

class NewFeed extends StatefulWidget {
  const NewFeed({Key? key}) : super(key: key);

  @override
  State<NewFeed> createState() => _NewFeedState();
}

class _NewFeedState extends State<NewFeed> {
  FormGroup get buildForm => fb.group({
        'type': FormControl<String>(validators: [Validators.required]),
        'quantity': FormControl<int>(
            validators: [Validators.number, Validators.required]),
        'date': FormControl<DateTime>(
            value: DateTime.now(), validators: [Validators.required]),
        'time': FormControl<TimeOfDay>(
            value: TimeOfDay.now(), validators: [Validators.required])
      });

  late FocusNode _focusNode;
  late FocusNode _focusNode1;
  bool _loading = false;
  Supplier? _supplier;
  final _controller = TextEditingController();

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode1 = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add feed'),
        ),
        body: SingleChildScrollView(
          child: ReactiveFormBuilder(
              form: () => buildForm,
              builder: (ctx, form, child) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Column(
                    children: [
                      ReactiveTextField<String>(
                        formControlName: 'type',
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration:
                            const InputDecoration(labelText: 'Feed type'),
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReactiveTextField<int>(
                        formControlName: 'quantity',
                        decoration:
                            const InputDecoration(labelText: 'Quantity'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                          ValidationMessage.number: 'Must be a number',
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onTap: () async {
                          final supplier = await Navigator.push<Supplier>(
                              context,
                              MaterialPageRoute<Supplier>(
                                  builder: (ctx) => SelectSupplier()));
                          _controller.text = supplier?.name ?? '';
                          setState(() => _supplier = supplier);
                        },
                        readOnly: true,
                        controller: _controller,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if ((v ?? '').isEmpty || _supplier == null) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Supplier',
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReactiveDatePicker<DateTime>(
                        formControlName: 'date',
                        firstDate: DateTime(1985),
                        lastDate: DateTime(2030),
                        builder: (context, picker, child) {
                          Widget suffix = InkWell(
                            onTap: () {
                              _focusNode.unfocus();

                              // Disable text field's focus node request
                              _focusNode.canRequestFocus = false;

                              // Clear field value
                              picker.control.value = null;
                              //Enable the text field's focus node request after
                              // some delay
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                _focusNode.canRequestFocus = true;
                              });
                            },
                            child: const Icon(Icons.clear),
                          );

                          if (picker.value == null) {
                            suffix = const Icon(Icons.calendar_today);
                          }

                          return ReactiveTextField(
                            onTap: () {
                              if (_focusNode.canRequestFocus) {
                                _focusNode.unfocus();
                                picker.showPicker();
                              }
                            },
                            valueAccessor: DateTimeValueAccessor(
                              dateTimeFormat: DateFormat('dd MMM yyyy'),
                            ),
                            focusNode: _focusNode,
                            formControlName: 'date',
                            validationMessages: (f) => {
                              ValidationMessage.required:
                                  'This field is required'
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              suffixIcon: suffix,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ReactiveTimePicker(
                        formControlName: 'time',
                        builder: (context, picker, child) {
                          Widget suffix = InkWell(
                            onTap: () {
                              _focusNode1.unfocus();

                              // Disable text field's focus node request
                              _focusNode1.canRequestFocus = false;

                              // Clear field value
                              picker.control.value = null;
                              //Enable the text field's focus node request after
                              // some delay
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                _focusNode1.canRequestFocus = true;
                              });
                            },
                            child: const Icon(Icons.clear),
                          );

                          if (picker.value == null) {
                            suffix = const Icon(Icons.calendar_today);
                          }

                          return ReactiveTextField(
                            onTap: () {
                              if (_focusNode1.canRequestFocus) {
                                _focusNode1.unfocus();
                                picker.showPicker();
                              }
                            },
                            valueAccessor: TimeOfDayValueAccessor(),
                            focusNode: _focusNode1,
                            formControlName: 'time',
                            validationMessages: (f) => {
                              ValidationMessage.required:
                                  'This field is required'
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Notify me each day at',
                              suffixIcon: suffix,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            if (form.invalid || _supplier == null) {
                              form.markAllAsTouched();
                              CustomSnackBar.snackBar(context,
                                  text: 'Please fill all fields',
                                  message: Message.success);
                              return;
                            }
                            setState(() => _loading = true);
                            final time =
                                form.control('time').value as TimeOfDay;
                            final feed = Feed(
                                type: form.control('type').value.toString(),
                                time: time.format(context),
                                supplier: _supplier!,
                                quantity: int.parse(
                                    form.control('quantity').value.toString()),
                                date: Timestamp.fromDate(
                                    form.control('date').value as DateTime));
                            final ref =
                                FirebaseFirestore.instance.collection('feed');
                            ref.add(feed.toMap()).then((value) {
                              final rand = Random().nextInt(10000);

                              NotificationService().notify(
                                  "It's ${feed.type} time",
                                  """Don't forget to feed your birds. 
                                This is the time to feed them ${feed.type}""",
                                  rand,
                                  DateTime.now()
                                      .add(Duration(
                                          hours: time.hour,
                                          minutes: time.minute))
                                      .millisecondsSinceEpoch,
                                  channel: 'feed',
                                  sound: 'workend.mp3');
                              form.reset();
                              _supplier = null;
                              setState(() => _loading = false);
                              CustomSnackBar.snackBar(context,
                                  text: 'Feed saved successfully',
                                  message: Message.success);
                              setState(() => _loading = false);
                            }).catchError((Object err) {
                              setState(() => _loading = false);
                            });
                          },
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : const Text('SAVE FEED'))
                    ],
                  ),
                );
              }),
        ));
  }
}
