library package_list_transformer;

import 'dart:async';
import 'dart:convert';

import 'package:barback/barback.dart';
import 'package:pub_package_data/pub_package_data.dart';

/**
 * A barback transformer that can be used to transform a template file called
 * package_info.dart to a file that contains version, revision and build date
 * informations.
 */
class PackageListTransformer extends Transformer {
  /**
   * Create a new instance of a [PackageListTransformer].
   */
  PackageListTransformer.asPlugin();

  Future<bool> isPrimary(AssetId id) => new Future.value(
      id.path.endsWith('package_list.dart'));

  Future apply(Transform transform) {
    return fetchAllPackageNames().then((packageNames) {
      
      return transform.primaryInput.readAsString().then((input) {
        // Replace it
        var packageListJson = JSON.encode(packageNames);
        final output = input.replaceAll(new RegExp(r'\[(.*)\]'), packageListJson);
        transform.logger.info('package list: $output', asset: transform.primaryInput.id);
        if(input != output) {
          transform.addOutput(new Asset.fromString(transform.primaryInput.id, output));
        }
      });
    });
  }
}
