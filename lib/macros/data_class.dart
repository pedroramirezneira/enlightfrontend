// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:macros/macros.dart';

macro class DataClass implements ClassDeclarationsMacro {
  const DataClass();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    // Import necessary libraries
    final override =
        await builder.resolveIdentifier(Uri.parse('dart:core'), 'override');
    final integer =
        await builder.resolveIdentifier(Uri.parse('dart:core'), 'int');
    final string =
        await builder.resolveIdentifier(Uri.parse('dart:core'), 'String');
    final boolean =
        await builder.resolveIdentifier(Uri.parse('dart:core'), 'bool');
    final object =
        await builder.resolveIdentifier(Uri.parse('dart:core'), 'Object');
    final identical =
        await builder.resolveIdentifier(Uri.parse('dart:core'), 'identical');

    // Buffer to build constructor parameters and initialization
    final constructorBuffer = StringBuffer();

    // Start the constructor definition
    constructorBuffer.write('  ${clazz.identifier.name}');
    constructorBuffer.write('({\n');

    // Collect field information
    final fields = await builder.fieldsOf(clazz);
    final fieldNames = <String>[];
    final copyWithParams = <Object>[];
    final copyWithBody = StringBuffer();
    final toStringParams = <Object>[];
    final toStringBody = StringBuffer();

    for (final field in fields) {
      final fieldName = field.identifier.name;
      final fieldType = field.type;
      fieldNames.add(fieldName);

      // Add fields to the constructor
      if (fieldType.isNullable) {
        constructorBuffer.write('    this.$fieldName,\n');
      } else {
        constructorBuffer.write('    required this.$fieldName,\n');
      }

      // Prepare parameters for copyWith method
      if (fieldType.isNullable) {
        copyWithParams.addAll([
          '    ',
          fieldType.code,
          ' ',
          fieldName,
          ',\n',
        ]);
      } else {
        copyWithParams.addAll([
          '    ',
          fieldType.code,
          '? ',
          fieldName,
          ',\n',
        ]);
      }

      // Prepare body for copyWith method
      copyWithBody.write('      $fieldName: $fieldName ?? this.$fieldName,\n');

      // Prepare parameters for toString method
      toStringParams.addAll([
        '    ',
        fieldName,
        ': \$$fieldName',
        ',\n',
      ]);

      // Prepare body for toString method
      toStringBody.write(
          '      $fieldName: $fieldName${fieldNames.last == fieldName ? '' : ', '}\n');
    }

    // Close the constructor definition
    constructorBuffer.write('  });');

    // Declare the constructor in the class
    builder.declareInType(
      DeclarationCode.fromString(constructorBuffer.toString()),
    );

    // Generate the == operator
    final equalityCodeParts = <Object>[
      '  @',
      override,
      '\n',
      '  ',
      boolean,
      ' operator ==(',
      object,
      ' other) {\n',
      '    if (',
      identical,
      '(this, other)) return true;\n',
      '    return other is ',
      clazz.identifier,
      ' &&\n',
    ];

    for (int i = 0; i < fieldNames.length; i++) {
      final fieldName = fieldNames[i];
      final isLast = i == fieldNames.length - 1;
      equalityCodeParts.add('      other.');
      equalityCodeParts.add(fieldName);
      equalityCodeParts.add(' == ');
      equalityCodeParts.add(fieldName);
      equalityCodeParts.add(isLast ? ';\n' : ' &&\n');
    }

    equalityCodeParts.add('  }');

    final equalityCode = DeclarationCode.fromParts(equalityCodeParts);
    builder.declareInType(equalityCode);

    // Generate hashCode
    final hashCodeParts = <Object>[
      '  @',
      override,
      '\n',
      '  ',
      integer,
      ' get hashCode => ',
      object,
      '.hash(\n',
      '    1, \n'
    ];
    for (int i = 0; i < fieldNames.length; i++) {
      final fieldName = fieldNames[i];
      hashCodeParts.add('    ');
      hashCodeParts.add(fieldName);
      hashCodeParts.add(',\n');
    }
    hashCodeParts.add('  );');
    final hashCodeCode = DeclarationCode.fromParts(hashCodeParts);
    builder.declareInType(hashCodeCode);

    // Generate toString method
    final toStringParts = <Object>[
      '  @',
      override,
      '\n',
      '  ',
      string,
      ' toString() {\n',
      '    return \'',
      clazz.identifier.name,
      '(',
    ];
    for (int i = 0; i < fieldNames.length; i++) {
      final fieldName = fieldNames[i];
      final isLast = i == fieldNames.length - 1;
      toStringParts.add('$fieldName: \$$fieldName${isLast ? '' : ', '}');
    }
    toStringParts.add(')\';\n');
    toStringParts.add('  }');

    final toStringCode = DeclarationCode.fromParts(toStringParts);
    builder.declareInType(toStringCode);

    // Generate copyWith method using DeclarationCode.fromParts
    final copyWithMethod = DeclarationCode.fromParts([
      '  ',
      clazz.identifier.name,
      ' copyWith({\n',
      ...copyWithParams,
      '  }) {\n',
      '    return ',
      clazz.identifier.name,
      '(\n',
      copyWithBody.toString(),
      '    );\n',
      '  }',
    ]);
    builder.declareInType(copyWithMethod);
  }
}
