import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../utils.dart';
import '../widgets/custom_snackbar.dart';

class NewBird extends StatefulWidget {
  const NewBird({Key? key}) : super(key: key);

  @override
  State<NewBird> createState() => _NewBirdState();
}

class _NewBirdState extends State<NewBird> {
  FormGroup get buildForm => fb.group({
        'type': FormControl<String>(validators: [Validators.required]),
        'tag': FormControl<int>(
            validators: [Validators.number, Validators.required]),
      });
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a bird'),
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
                            const InputDecoration(labelText: 'Bird type'),
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ReactiveTextField<int>(
                        formControlName: 'tag',
                        decoration: const InputDecoration(labelText: 'Tag'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validationMessages: (f) => {
                          ValidationMessage.required: 'This field is required',
                          ValidationMessage.number: 'Must be a number',
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            if (form.invalid) {
                              form.markAllAsTouched();
                              return;
                            }
                            setState(() => _loading = true);
                            final ref =
                                FirebaseFirestore.instance.collection('birds');
                            ref.add(<String, dynamic>{
                              'tag': form.control('tag').value,
                              'type': form
                                  .control('tag')
                                  .value
                                  .toString()
                                  .capitalize()
                            }).then((value) {
                              form.reset();
                              setState(() => _loading = false);
                              CustomSnackBar.snackBar(context,
                                  text: 'Bird added successfully',
                                  message: Message.success);
                            });
                          },
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator())
                              : const Text('SUBMIT'))
                    ],
                  ),
                );
              }),
        ));
  }
}
