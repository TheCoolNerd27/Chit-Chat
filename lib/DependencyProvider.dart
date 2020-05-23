import 'package:flutter/material.dart';
import 'package:chitchat/Encryption.dart';

class DependencyProvider extends InheritedWidget {

    static DependencyProvider of(BuildContext context) {
        return (context.dependOnInheritedWidgetOfExactType<DependencyProvider>());
    }

    DependencyProvider({
        Key key,
        Widget child,
    }) : super(key: key, child: child);

    @override
    bool updateShouldNotify(InheritedWidget oldWidget) => false;

    Crypto getRsaKeyHelper() {
        return Crypto();
    }
}