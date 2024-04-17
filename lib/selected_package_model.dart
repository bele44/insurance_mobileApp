class SelectedPackageModel {
  final String packageName;
  final double benefit;
  final double premium;

  SelectedPackageModel(this.packageName, this.benefit, this.premium);

  SelectedPackageModel updateValues({double? newBenefit, double? newPremium}) {
    return SelectedPackageModel(
      packageName,
      newBenefit ?? benefit,
      newPremium ?? premium,
    );
  }

  @override
  String toString() {
    return 'SelectedPackageModel(packageName: $packageName, benefit: $benefit, premium: $premium)';
  }
}

