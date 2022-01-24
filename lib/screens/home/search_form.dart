import 'package:flutter/material.dart';
import 'package:flutter_test_bed/components/default_button.dart';
import 'package:flutter_test_bed/components/form_error.dart';
import 'package:flutter_test_bed/screens/gallery/gallery.dart';
import 'package:flutter_test_bed/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';


class SearchForm extends StatefulWidget {
  const SearchForm({Key? key, required User user}) :  _user = user, super(key: key);

  final User _user;
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {

  
  late User user;
  
  @override
  void initState() {
    user = widget._user;
    super.initState();
  }

  final _registerFormKey = GlobalKey<FormState>();

  String count = '10';
  String searchType = 'All';

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Form(
            key: _registerFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildNameFormField(),
                SizedBox(height: getProportionateScreenHeight(20)),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: getProportionateScreenWidth(10),
                        ),
                        child: buildDropdownCount(),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10),
                        ),
                        child: buildDropdownAPI(),
                      ),
                    ),
                  ],
                ),
               
                SizedBox(height: getProportionateScreenHeight(20)),
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
                                  builder: (context) => Gallery(
                                      user: user,
                                      search: _nameTextController.text,
                                      count: count,
                                      searchType: searchType,),
                                ),
                              );
                            }
                          }
                        },
                      ),
              ],
            ),
          ),
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

  DropdownButtonFormField buildDropdownCount() {
    return DropdownButtonFormField(
      value: count,
      elevation: 16,
      decoration: const InputDecoration(
        fillColor: Colors.indigo,
        labelText: 'Count',
      ),
      onChanged: (newValue) {
        setState(() {
          count = newValue!;
        });
      },
      items: <String>['10', '20', '30', '40']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField buildDropdownAPI() {
    return DropdownButtonFormField(
      value: searchType,
      elevation: 16,
      decoration: const InputDecoration(
        fillColor: Colors.indigo,
        labelText: 'Search Type',
      ),
      onChanged: (newApiValue) {
        setState(() {
          searchType = newApiValue!;
        });
      },
      items: <String>['All', 'User']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
