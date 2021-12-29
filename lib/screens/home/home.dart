import 'package:flutter/material.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/components/form_error.dart';
import 'package:flutter_test_bed/screens/gallery/gallery.dart';
import 'package:flutter_test_bed/size_config.dart';

import '../../constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
            vertical: getProportionateScreenHeight(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(20)),
                    const Text(
                      "Search a Category",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    const SearchForm(),
                    SizedBox(height: getProportionateScreenHeight(20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({Key? key}) : super(key: key);

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _registerFormKey = GlobalKey<FormState>();
  String? name;
  final _nameTextController = TextEditingController();
  final _focusName = FocusNode();
  bool _isProcessing = false;

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _registerFormKey,
            child: Column(
              children: [
                buildNameFormField(),
                SizedBox(height: getProportionateScreenHeight(10)),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(40)),
                _isProcessing
                    ? const CircularProgressIndicator()
                    : DefaultButton(
                        text: "Search",
                        press: () async {
                          setState(() {
                            _isProcessing = true;
                          });

                          if (_registerFormKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = false;
                            });

                            if (_nameTextController.text != '') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Gallery(search: _nameTextController.text),
                                ),
                              );
                            }
                          }
                        },
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        } else if (value.length >= 8) {
          removeError(error: kNamelNullError);
        }
        return;
      },
      controller: _nameTextController,
      focusNode: _focusName,
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Search",
        errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
