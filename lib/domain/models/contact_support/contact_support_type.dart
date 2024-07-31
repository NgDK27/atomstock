enum ContactSupportType {
  bug('Bug or problem' ,'When I try...'),
  suggestion('Suggestion' ,"What if..."),
  featureRequest('Feature request' ,"It would be useful if...");

  final String supportingText;
  final String label;

  const ContactSupportType(this.label, this.supportingText);
}
