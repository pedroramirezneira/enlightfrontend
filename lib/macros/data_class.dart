import 'dart:async';
import 'package:macros/macros.dart';

macro class DataClass implements ClassDeclarationsMacro {
  const DataClass();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    // Buffer to build constructor parameters and initialization
    final constructorBuffer = StringBuffer();

    // Start the constructor definition
    constructorBuffer.write('  ${clazz.identifier.name}');
    constructorBuffer.write('  ({\n');

    // Iterate over fields to add them to the constructor
    final fields = await builder.fieldsOf(clazz);
    for (final field in fields) {
      final fieldName = field.identifier.name;
      final fieldType = field.type;

      // Add each field in the required format with 'required' for non-nullable fields
      if (fieldType.isNullable) {
        constructorBuffer.write('    this.$fieldName,\n');
      } else {
        constructorBuffer.write('    required this.$fieldName,\n');
      }
    }

    // Close the constructor definition
    constructorBuffer.write('  });');

    // Declare the constructor in the class
    builder.declareInType(
      DeclarationCode.fromString(constructorBuffer.toString()),
    );
  }
}
